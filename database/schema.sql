-- ============================================================
-- AvarieApp (Gamis) — Schéma Supabase (PostgreSQL)
-- Source de vérité pour toutes les tables côté serveur.
-- À exécuter dans l'éditeur SQL Supabase (SQL Editor → New query).
-- Idempotent : peut être ré-exécuté sans erreur (if not exists / drop if exists).
-- ============================================================

-- Extensions
create extension if not exists "uuid-ossp";

-- ─── Profils utilisateurs ──────────────────────────────────────────────────
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text not null,
  nom         text,
  initiales   text check (initiales is null or length(initiales) <= 2),
  role        text not null default 'agent'
                check (role in ('admin','expert','agent','comptable','rh')),
  actif       boolean not null default true,
  entreprise_id text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- Migration : ajouter la colonne initiales si la table existait déjà sans elle
alter table public.profiles add column if not exists initiales text;
alter table public.profiles drop constraint if exists profiles_initiales_check;
alter table public.profiles add constraint profiles_initiales_check
  check (initiales is null or length(initiales) <= 2);

-- Migration : permissions granulaires par utilisateur (surcharges du rôle)
-- Clés possibles : dossiers.annuler, factures.valider, factures.encaisser (cf. lib/core/constants/permissions.dart)
-- ⚠️ Filtre UI uniquement — la sécurité réelle reste assurée par les politiques RLS ci-dessous.
alter table public.profiles add column if not exists permissions jsonb not null default '{}'::jsonb;

-- Trigger : créer automatiquement un profil à l'inscription
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, email, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'role', 'agent')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Helper function : évite la récursion infinie dans les politiques RLS de profiles
create or replace function public.is_admin()
returns boolean language sql security definer stable as $$
  select exists (
    select 1 from public.profiles where id = auth.uid() and role = 'admin'
  )
$$;

-- RLS profiles
alter table public.profiles enable row level security;
drop policy if exists "Lecture propre profil" on public.profiles;
create policy "Lecture propre profil" on public.profiles
  for select using (auth.uid() = id);
drop policy if exists "Admin voit tout" on public.profiles;
create policy "Admin voit tout" on public.profiles
  for all using (public.is_admin());

-- Auto-édition des initiales : un utilisateur ne peut modifier QUE la colonne
-- `initiales` de son propre profil (le reste de la table reste protégé par RLS).
create or replace function public.update_my_initiales(p_initiales text)
returns void language plpgsql security definer as $$
begin
  if p_initiales is not null and length(p_initiales) > 2 then
    raise exception 'Les initiales sont limitées à 2 caractères';
  end if;
  update public.profiles set initiales = p_initiales, updated_at = now()
  where id = auth.uid();
end;
$$;
grant execute on function public.update_my_initiales(text) to authenticated;

-- ─── Numérotation automatique ──────────────────────────────────────────────
-- Séquences annuelles par type de document

create table if not exists public.document_sequences (
  type  text not null,
  annee int  not null,
  last  int  not null default 0,
  primary key (type, annee)
);

-- Formate un numéro de document à partir d'un gabarit configurable.
-- Jetons reconnus : PREFIXE, AAAA, MMAA, ABREV, INITIALES, N+ (séquence, le nombre
-- de N définit le nombre de chiffres). Tout autre segment est repris tel quel.
-- Les segments dont la valeur résolue est vide (ABREV/INITIALES absents) sont supprimés.
create or replace function public.formater_numero(
  p_format text,
  p_prefixe text,
  p_annee int,
  p_sequence int,
  p_abrev text,
  p_initiales text
)
returns text language plpgsql stable as $$
declare
  v_segments text[];
  v_result text[] := array[]::text[];
  v_segment text;
  v_value text;
begin
  v_segments := string_to_array(p_format, '-');
  foreach v_segment in array v_segments loop
    if v_segment = 'PREFIXE' then
      v_value := p_prefixe;
    elsif v_segment = 'AAAA' then
      v_value := p_annee::text;
    elsif v_segment = 'MMAA' then
      v_value := lpad(extract(month from now())::text, 2, '0') || right(p_annee::text, 2);
    elsif v_segment = 'ABREV' then
      v_value := p_abrev;
    elsif v_segment = 'INITIALES' then
      v_value := p_initiales;
    elsif v_segment ~ '^N+$' then
      v_value := lpad(p_sequence::text, length(v_segment), '0');
    else
      v_value := v_segment;
    end if;

    if v_value is not null and v_value <> '' then
      v_result := array_append(v_result, v_value);
    end if;
  end loop;

  return array_to_string(v_result, '-');
end;
$$;

-- security definer : permet d'écrire dans document_sequences (RLS) même
-- quand la fonction est appelée par le trigger lors d'un insert authentifié
create or replace function public.next_numero(
  p_type text,
  p_annee int,
  p_entreprise_id text default 'default',
  p_dossier_id text default null,
  p_cree_par uuid default null
)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_next int;
  v_prefix text;
  v_format text;
  v_abrev text := '';
  v_initiales text := '';
begin
  insert into public.document_sequences (type, annee, last)
  values (p_type, p_annee, 1)
  on conflict (type, annee)
  do update set last = document_sequences.last + 1
  returning last into v_next;

  v_prefix := case p_type
    when 'dossier' then 'AV'
    when 'devis'   then 'DEV'
    when 'facture' then 'FAC'
    else upper(p_type)
  end;

  -- Dossiers, devis, factures : format configurable par entreprise
  select case p_type
    when 'dossier'  then format_dossier
    when 'devis'    then format_devis
    else format_facture
  end
  into v_format
  from public.parametres_numerotation
  where entreprise_id = p_entreprise_id;

  if v_format is null then
    v_format := 'PREFIXE-AAAA-NNNN';
  end if;

  -- Abréviation du type de mission, via le dossier lié au document
  if p_dossier_id is not null then
    select coalesce(tm.abreviation, '') into v_abrev
    from public.dossiers d
    left join public.types_mission tm
      on tm.entreprise_id = d.entreprise_id and tm.nom = d.type_mission_id
    where d.id = p_dossier_id
    limit 1;
  end if;
  v_abrev := coalesce(v_abrev, '');

  -- Initiales du créateur du document
  if p_cree_par is not null then
    select coalesce(initiales, '') into v_initiales
    from public.profiles where id = p_cree_par;
  end if;
  v_initiales := coalesce(v_initiales, '');

  return public.formater_numero(v_format, v_prefix, p_annee, v_next, v_abrev, v_initiales);
end;
$$;

-- Triggers numérotation (exemple pour factures — même pattern pour dossiers/devis)
create or replace function public.set_facture_numero()
returns trigger language plpgsql as $$
begin
  if new.numero is null or new.numero like '%-LOCAL-%' then
    new.numero := public.next_numero(
      'facture',
      extract(year from now())::int,
      coalesce(new.entreprise_id, 'default'),
      new.dossier_id,
      case when new.cree_par is null or new.cree_par = '' then null else new.cree_par::uuid end
    );
  end if;
  return new;
end;
$$;

create or replace function public.set_dossier_numero()
returns trigger language plpgsql as $$
begin
  -- Numéro permanent assigné uniquement lors du premier passage à 'en_cours'
  if new.statut = 'en_cours'
     and (old.statut is null or old.statut <> 'en_cours')
     and (new.numero is null or new.numero like '%-LOCAL-%') then
    new.numero := public.next_numero(
      'dossier',
      coalesce(new.annee, extract(year from now())::int),
      coalesce(new.entreprise_id, 'default'),
      null,
      null
    );
  end if;
  return new;
end;
$$;

create or replace function public.set_devis_numero()
returns trigger language plpgsql as $$
begin
  if new.numero is null or new.numero like '%-LOCAL-%' then
    new.numero := public.next_numero(
      'devis',
      coalesce(new.annee, extract(year from now())::int),
      coalesce(new.entreprise_id, 'default'),
      new.dossier_id,
      case when new.cree_par is null or new.cree_par = '' then null else new.cree_par::uuid end
    );
  end if;
  return new;
end;
$$;

-- Maj automatique de updated_at (résolution de conflit "last write wins")
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- ============================================================
-- Tables métier (alignées sur les tables Drift locales)
-- Pas de FK strictes entre elles : la sync offline peut pousser
-- les entités dans un ordre non garanti (last write wins).
-- RLS : tout utilisateur authentifié a accès complet (mono-cabinet).
-- ============================================================

-- ─── Clients ────────────────────────────────────────────────────────────────
create table if not exists public.clients (
  id            text primary key,
  entreprise_id text not null default 'default',
  type_client   text not null default 'entreprise',
  nom           text not null,
  contact_nom   text,
  email         text,
  telephone     text,
  adresse       text,
  ville         text,
  pays          text not null default 'Gabon',
  numero_tva    text,
  rccm          text,
  nif           text,
  notes         text,
  total_facture double precision not null default 0,
  total_paye    double precision not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- Ajout colonnes (idempotent — si table déjà existante)
alter table public.clients add column if not exists numero_tva    text;
alter table public.clients add column if not exists rccm          text;
alter table public.clients add column if not exists nif           text;
-- v10 : référence interne + champs OLEA
alter table public.clients add column if not exists reference       text;
alter table public.clients add column if not exists ref_olea_unique text;
alter table public.clients add column if not exists ref_agl         text;
alter table public.clients add column if not exists ref_ds          text;
alter table public.clients add column if not exists cabinet_bce     text;

alter table public.clients enable row level security;
drop policy if exists "Authentifié - accès complet" on public.clients;
create policy "Authentifié - accès complet" on public.clients
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_clients_updated_at on public.clients;
create trigger trg_clients_updated_at before update on public.clients
  for each row execute procedure public.set_updated_at();

-- ─── Contacts clients (multi-contacts par client) ──────────────────────────
create table if not exists public.client_contacts (
  id          text primary key,
  client_id   text not null references public.clients(id) on delete cascade,
  nom         text not null,
  fonction    text,
  telephone   text,
  email       text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

alter table public.client_contacts enable row level security;
drop policy if exists "Authentifié - accès complet" on public.client_contacts;
create policy "Authentifié - accès complet" on public.client_contacts
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_client_contacts_updated_at on public.client_contacts;
create trigger trg_client_contacts_updated_at before update on public.client_contacts
  for each row execute procedure public.set_updated_at();

-- ─── Dossiers ───────────────────────────────────────────────────────────────
create table if not exists public.dossiers (
  id                  text primary key,
  entreprise_id       text not null default 'default',
  client_id           text,
  expert_id           text,
  type_mission_id     text,

  numero              text,
  annee               int not null default extract(year from now())::int,

  titre               text not null,
  description         text,
  date_sinistre       timestamptz,
  lieu_sinistre       text,
  nature_sinistre     text,
  montant_sinistre    double precision,

  statut              text not null default 'brouillon',
  priorite            text not null default 'normale',

  date_ouverture      timestamptz not null default now(),
  date_expertise      timestamptz,
  date_rapport        timestamptz,
  date_cloture        timestamptz,
  deadline            timestamptz,

  compagnie_assurance text,
  numero_police       text,
  courtier            text,

  notes_internes      text,
  observations        text,
  motif_annulation    text,

  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

alter table public.dossiers enable row level security;
drop policy if exists "Authentifié - accès complet" on public.dossiers;
create policy "Authentifié - accès complet" on public.dossiers
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_dossiers_numero on public.dossiers;
create trigger trg_dossiers_numero before update on public.dossiers
  for each row execute procedure public.set_dossier_numero();

drop trigger if exists trg_dossiers_updated_at on public.dossiers;
create trigger trg_dossiers_updated_at before update on public.dossiers
  for each row execute procedure public.set_updated_at();

-- ─── Devis ──────────────────────────────────────────────────────────────────
create table if not exists public.devis (
  id            text primary key,
  entreprise_id text not null default 'default',
  dossier_id    text,
  client_id     text not null,
  cree_par      text,

  numero        text,
  annee         int not null default extract(year from now())::int,

  statut        text not null default 'brouillon',

  date_emission timestamptz not null default now(),
  date_validite timestamptz not null default (now() + interval '30 days'),

  montant_ht    double precision not null default 0,
  taux_tva      double precision not null default 18,
  montant_tva   double precision not null default 0,
  taux_tps      double precision not null default 0,
  montant_tps   double precision not null default 0,
  montant_ttc   double precision not null default 0,

  objet         text,
  conditions    text,
  notes         text,

  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.devis enable row level security;
drop policy if exists "Authentifié - accès complet" on public.devis;
create policy "Authentifié - accès complet" on public.devis
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_devis_numero on public.devis;
create trigger trg_devis_numero before insert on public.devis
  for each row execute procedure public.set_devis_numero();

drop trigger if exists trg_devis_updated_at on public.devis;
create trigger trg_devis_updated_at before update on public.devis
  for each row execute procedure public.set_updated_at();

-- ─── Factures ───────────────────────────────────────────────────────────────
create table if not exists public.factures (
  id                 text primary key,
  entreprise_id      text not null default 'default',
  dossier_id         text,
  client_id          text not null,
  devis_id           text,
  cree_par           text,

  numero             text,
  annee              int not null default extract(year from now())::int,

  statut             text not null default 'brouillon',

  date_emission      timestamptz not null default now(),
  date_echeance      timestamptz not null default (now() + interval '30 days'),
  date_paiement      timestamptz,

  montant_ht         double precision not null default 0,
  taux_tva           double precision not null default 18,
  montant_tva        double precision not null default 0,
  taux_tps           double precision not null default 0,
  montant_tps        double precision not null default 0,
  montant_ttc        double precision not null default 0,
  montant_paye       double precision not null default 0,
  montant_restant    double precision not null default 0,

  mode_paiement      text,
  reference_paiement text,

  objet              text,
  conditions         text,
  notes              text,
  motif_annulation   text,

  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

alter table public.factures enable row level security;
drop policy if exists "Authentifié - accès complet" on public.factures;
create policy "Authentifié - accès complet" on public.factures
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_factures_numero on public.factures;
create trigger trg_factures_numero before insert on public.factures
  for each row execute procedure public.set_facture_numero();

drop trigger if exists trg_factures_updated_at on public.factures;
create trigger trg_factures_updated_at before update on public.factures
  for each row execute procedure public.set_updated_at();

-- ─── Pièces jointes ─────────────────────────────────────────────────────────
create table if not exists public.pieces_jointes (
  id           text primary key,
  dossier_id   text not null,
  nom          text not null,
  type_fichier text not null,
  chemin_local text not null,
  url_storage  text,
  taille       int,
  latitude     double precision,
  longitude    double precision,
  notes        text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

alter table public.pieces_jointes enable row level security;
drop policy if exists "Authentifié - accès complet" on public.pieces_jointes;
create policy "Authentifié - accès complet" on public.pieces_jointes
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_pieces_jointes_updated_at on public.pieces_jointes;
create trigger trg_pieces_jointes_updated_at before update on public.pieces_jointes
  for each row execute procedure public.set_updated_at();

-- ─── Taxes (TVA, TPS, etc. configurables par entreprise) ────────────────────
create table if not exists public.taxes (
  id            text primary key,
  entreprise_id text not null default 'default',
  nom           text not null,
  taux          double precision not null default 0,
  description   text,
  actif         boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.taxes enable row level security;
drop policy if exists "Authentifié - accès complet" on public.taxes;
create policy "Authentifié - accès complet" on public.taxes
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_taxes_updated_at on public.taxes;
create trigger trg_taxes_updated_at before update on public.taxes
  for each row execute procedure public.set_updated_at();

-- ─── Types de mission (catégories de dossiers, avec abréviation pour la numérotation) ──
create table if not exists public.types_mission (
  id            text primary key,
  entreprise_id text not null default 'default',
  nom           text not null,
  abreviation   text,
  ordre         int not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.types_mission enable row level security;
drop policy if exists "Authentifié - accès complet" on public.types_mission;
create policy "Authentifié - accès complet" on public.types_mission
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_types_mission_updated_at on public.types_mission;
create trigger trg_types_mission_updated_at before update on public.types_mission
  for each row execute procedure public.set_updated_at();

-- ─── Paramètres de numérotation des devis/factures (par entreprise) ────────
create table if not exists public.parametres_numerotation (
  entreprise_id  text primary key default 'default',
  format_devis   text not null default 'PREFIXE-AAAA-NNNN',
  format_facture text not null default 'PREFIXE-AAAA-NNNN',
  format_dossier text not null default 'AV-AAAA-NNNN',
  updated_at     timestamptz not null default now()
);
-- Migration : ajouter la colonne si elle n'existe pas encore (idempotent)
alter table public.parametres_numerotation
  add column if not exists format_dossier text not null default 'AV-AAAA-NNNN';

alter table public.parametres_numerotation enable row level security;
drop policy if exists "Authentifié - accès complet" on public.parametres_numerotation;
create policy "Authentifié - accès complet" on public.parametres_numerotation
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_parametres_numerotation_updated_at on public.parametres_numerotation;
create trigger trg_parametres_numerotation_updated_at before update on public.parametres_numerotation
  for each row execute procedure public.set_updated_at();

-- ─── Lignes de devis ────────────────────────────────────────────────────────
-- Pas de FK stricte vers devis : la sync offline peut pousser les lignes
-- avant ou après le document parent (last write wins).
create table if not exists public.devis_lignes (
  id          text primary key,
  devis_id    text not null,
  ordre       int not null default 0,
  designation text not null,
  description text,
  quantite    double precision not null default 1,
  unite       text not null default 'forfait',
  prix_unit   double precision not null default 0,
  montant_ht  double precision not null default 0,
  taxes_json  text,
  created_at  timestamptz not null default now()
);

alter table public.devis_lignes enable row level security;
drop policy if exists "Authentifié - accès complet" on public.devis_lignes;
create policy "Authentifié - accès complet" on public.devis_lignes
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

-- ─── Lignes de factures ─────────────────────────────────────────────────────
create table if not exists public.factures_lignes (
  id          text primary key,
  facture_id  text not null,
  ordre       int not null default 0,
  designation text not null,
  description text,
  quantite    double precision not null default 1,
  unite       text not null default 'forfait',
  prix_unit   double precision not null default 0,
  montant_ht  double precision not null default 0,
  taxes_json  text,
  created_at  timestamptz not null default now()
);

alter table public.factures_lignes enable row level security;
drop policy if exists "Authentifié - accès complet" on public.factures_lignes;
create policy "Authentifié - accès complet" on public.factures_lignes
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

-- ─── Charges (comptabilité) ─────────────────────────────────────────────────
create table if not exists public.charges (
  id               text primary key,
  entreprise_id    text not null default 'default',
  dossier_id       text,
  saisi_par        text,
  categorie        text not null,
  libelle          text not null,
  montant          double precision not null default 0,
  date_charge      timestamptz not null default now(),
  mois             int not null,
  annee            int not null,
  justificatif_url text,
  notes            text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

alter table public.charges enable row level security;
drop policy if exists "Authentifié - accès complet" on public.charges;
create policy "Authentifié - accès complet" on public.charges
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_charges_updated_at on public.charges;
create trigger trg_charges_updated_at before update on public.charges
  for each row execute procedure public.set_updated_at();

-- ─── Modèles de charges (workflow de soumission/validation) ────────────────
create table if not exists public.charges_modeles (
  id              text primary key,
  entreprise_id   text not null default 'default',
  mois            int not null,
  annee           int not null,
  titre           text not null,
  soumis_par_id   text,
  soumis_par_nom  text,
  statut          text not null default 'brouillon',
  motif_refus     text,
  date_submission timestamptz,
  date_validation timestamptz,
  valide_par_id   text,
  valide_par_nom  text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.charges_modeles enable row level security;
drop policy if exists "Authentifié - accès complet" on public.charges_modeles;
create policy "Authentifié - accès complet" on public.charges_modeles
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_charges_modeles_updated_at on public.charges_modeles;
create trigger trg_charges_modeles_updated_at before update on public.charges_modeles
  for each row execute procedure public.set_updated_at();

create table if not exists public.charges_modele_lines (
  id            text primary key,
  modele_id     text not null,
  ordre         int not null default 0,
  designation   text not null,
  montant       double precision not null default 0,
  date_echeance timestamptz,
  priorite      text not null default 'normale',
  statut        text not null default 'pending',
  motif_refus   text,
  notes         text,
  created_at    timestamptz not null default now()
);

alter table public.charges_modele_lines enable row level security;
drop policy if exists "Authentifié - accès complet" on public.charges_modele_lines;
create policy "Authentifié - accès complet" on public.charges_modele_lines
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

-- ─── Helper : admin ou rh (tables RH/Paie — données sensibles) ─────────────
create or replace function public.is_admin_or_rh()
returns boolean language sql security definer stable as $$
  select exists (
    select 1 from public.profiles where id = auth.uid() and role in ('admin','rh')
  )
$$;

-- ─── Personnel ───────────────────────────────────────────────────────────────
create table if not exists public.personnel (
  id               text primary key,
  entreprise_id    text not null default 'default',
  utilisateur_id   text,
  nom              text not null,
  prenom           text,
  poste            text,
  departement      text,
  type_contrat     text not null default 'CDI',
  date_embauche    timestamptz,
  date_fin_contrat timestamptz,
  salaire_base     double precision,
  actif            boolean not null default true,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

alter table public.personnel enable row level security;
drop policy if exists "Admin/RH - accès complet" on public.personnel;
create policy "Admin/RH - accès complet" on public.personnel
  for all using (public.is_admin_or_rh()) with check (public.is_admin_or_rh());

drop trigger if exists trg_personnel_updated_at on public.personnel;
create trigger trg_personnel_updated_at before update on public.personnel
  for each row execute procedure public.set_updated_at();

-- ─── Congés ──────────────────────────────────────────────────────────────────
create table if not exists public.conges (
  id           text primary key,
  personnel_id text not null,
  date_debut   timestamptz not null,
  date_fin     timestamptz not null,
  type         text not null default 'conge_annuel',
  motif        text,
  statut       text not null default 'demande',
  valide_par   text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

alter table public.conges enable row level security;
drop policy if exists "Admin/RH - accès complet" on public.conges;
create policy "Admin/RH - accès complet" on public.conges
  for all using (public.is_admin_or_rh()) with check (public.is_admin_or_rh());

drop trigger if exists trg_conges_updated_at on public.conges;
create trigger trg_conges_updated_at before update on public.conges
  for each row execute procedure public.set_updated_at();

-- ─── Salaires ────────────────────────────────────────────────────────────────
create table if not exists public.salaires (
  id              text primary key,
  entreprise_id   text not null default 'default',
  personnel_id    text not null,
  mois            int not null,
  annee           int not null,
  salaire_brut    double precision not null default 0,
  cnps            double precision not null default 0,
  irpp            double precision not null default 0,
  autres_retenues double precision not null default 0,
  salaire_net     double precision not null default 0,
  statut          text not null default 'en_attente',
  date_validation timestamptz,
  valide_par      text,
  date_paiement   timestamptz,
  mode_paiement   text,
  comptabilise    boolean not null default false,
  charge_id       text,
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.salaires enable row level security;
drop policy if exists "Admin/RH - accès complet" on public.salaires;
create policy "Admin/RH - accès complet" on public.salaires
  for all using (public.is_admin_or_rh()) with check (public.is_admin_or_rh());

drop trigger if exists trg_salaires_updated_at on public.salaires;
create trigger trg_salaires_updated_at before update on public.salaires
  for each row execute procedure public.set_updated_at();

-- ─── Stockage : pièces jointes (photos terrain, documents) ─────────────────
insert into storage.buckets (id, name, public)
values ('pieces-jointes', 'pieces-jointes', true)
on conflict (id) do nothing;

drop policy if exists "Pieces jointes - lecture authentifiée" on storage.objects;
create policy "Pieces jointes - lecture authentifiée" on storage.objects
  for select using (bucket_id = 'pieces-jointes' and auth.uid() is not null);
drop policy if exists "Pieces jointes - upload authentifié" on storage.objects;
create policy "Pieces jointes - upload authentifié" on storage.objects
  for insert with check (bucket_id = 'pieces-jointes' and auth.uid() is not null);
drop policy if exists "Pieces jointes - update authentifié" on storage.objects;
create policy "Pieces jointes - update authentifié" on storage.objects
  for update using (bucket_id = 'pieces-jointes' and auth.uid() is not null);
drop policy if exists "Pieces jointes - suppression authentifiée" on storage.objects;
create policy "Pieces jointes - suppression authentifiée" on storage.objects
  for delete using (bucket_id = 'pieces-jointes' and auth.uid() is not null);

-- ─── Variables d'environnement à configurer dans Supabase ─────────────────
-- Dashboard → Settings → Edge Functions → Secrets :
--   RESEND_API_KEY   : clé API Resend.com
--   FROM_EMAIL       : adresse expéditeur (ex: facturation@votrecabinet.ga)
--   CABINET_NOM      : nom du cabinet (ex: Cabinet Maritime Gabon)
--   APP_URL          : URL de l'app déployée (ex: https://gemex.vercel.app)
--   SUPABASE_SERVICE_ROLE_KEY : clé service_role (auto-injectée dans Edge Functions)

-- ============================================================
-- Migration Lot 2 : nouveaux statuts dossiers (idempotent)
-- ============================================================
-- Mapping : nouveau→brouillon, expertise_en_cours→en_cours, rapport_redige/clos→termine
update public.dossiers set statut = 'brouillon' where statut = 'nouveau';
update public.dossiers set statut = 'en_cours'  where statut = 'expertise_en_cours';
update public.dossiers set statut = 'termine'   where statut in ('rapport_redige', 'clos');
-- Mise à jour du DEFAULT de la colonne statut
alter table public.dossiers alter column statut set default 'brouillon';

-- ============================================================
-- Migration Lot 3 : documents professionnels des dossiers
-- ============================================================
-- Table : documents_rapport (contenus des 6 types de documents PDF)
create table if not exists public.documents_rapport (
  id              text primary key,
  dossier_id      text not null references public.dossiers(id) on delete cascade,
  type            text not null,           -- TypeDocumentMetier.name
  contenu_json    jsonb not null default '{}'::jsonb,
  statut          text not null default 'brouillon', -- 'brouillon' | 'finalise'
  entreprise_id   text not null default 'default',
  sync_status     text not null default 'pending',
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  constraint documents_rapport_type_check
    check (type in ('ordreMission','lettreMission','ficheConstatation',
                    'rapportPrelim','rapportExpertise','pvConstatation')),
  constraint documents_rapport_statut_check
    check (statut in ('brouillon','finalise')),
  unique (dossier_id, type)
);

alter table public.documents_rapport enable row level security;
drop policy if exists "Authentifié - accès complet" on public.documents_rapport;
create policy "Authentifié - accès complet" on public.documents_rapport
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_documents_rapport_updated_at on public.documents_rapport;
create trigger trg_documents_rapport_updated_at before update on public.documents_rapport
  for each row execute procedure public.set_updated_at();

-- ============================================================
-- Migration Lot Produits & Stock
-- ============================================================

create table if not exists public.produits (
  id            text primary key,
  entreprise_id text not null default 'default',
  code          text not null,
  nom           text not null,
  description   text,
  unite         text not null default 'unité',
  prix_vente    double precision not null default 0,
  prix_achat    double precision not null default 0,
  est_vente     boolean not null default true,
  est_achat     boolean not null default false,
  categorie     text,
  stock_min     double precision not null default 0,
  actif         boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (entreprise_id, code)
);

alter table public.produits enable row level security;
drop policy if exists "Authentifié - accès complet" on public.produits;
create policy "Authentifié - accès complet" on public.produits
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_produits_updated_at on public.produits;
create trigger trg_produits_updated_at before update on public.produits
  for each row execute procedure public.set_updated_at();

create table if not exists public.stock_mouvements (
  id              text primary key,
  entreprise_id   text not null default 'default',
  produit_id      text not null,
  type            text not null check (type in ('entree','sortie')),
  quantite        double precision not null,
  prix_unitaire   double precision not null default 0,
  date_mouvement  timestamptz not null default now(),
  reference       text,
  dossier_id      text,
  effectue_par    text,
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.stock_mouvements enable row level security;
drop policy if exists "Authentifié - accès complet" on public.stock_mouvements;
create policy "Authentifié - accès complet" on public.stock_mouvements
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_stock_mouvements_updated_at on public.stock_mouvements;
create trigger trg_stock_mouvements_updated_at before update on public.stock_mouvements
  for each row execute procedure public.set_updated_at();

-- ─── Migration Lot 2 : Référentiels (postes, départements) ──────────────
create table if not exists public.referentiels (
  id            text primary key,
  entreprise_id text not null default 'default',
  type          text not null check (type in ('poste','departement')),
  nom           text not null,
  actif         boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.referentiels enable row level security;
drop policy if exists "Authentifié - accès complet" on public.referentiels;
create policy "Authentifié - accès complet" on public.referentiels
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_referentiels_updated_at on public.referentiels;
create trigger trg_referentiels_updated_at before update on public.referentiels
  for each row execute procedure public.set_updated_at();

-- ─── Migration Lot 6 : Récurrence sur les charges ──────────────────────
alter table public.charges add column if not exists recurrence text not null default 'unique';
