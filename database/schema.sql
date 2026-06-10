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
  role        text not null default 'agent'
                check (role in ('admin','expert','agent','comptable','rh')),
  actif       boolean not null default true,
  entreprise_id text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

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

-- ─── Numérotation automatique ──────────────────────────────────────────────
-- Séquences annuelles par type de document

create table if not exists public.document_sequences (
  type  text not null,
  annee int  not null,
  last  int  not null default 0,
  primary key (type, annee)
);

-- security definer : permet d'écrire dans document_sequences (RLS) même
-- quand la fonction est appelée par le trigger lors d'un insert authentifié
create or replace function public.next_numero(p_type text, p_annee int)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_next int;
  v_prefix text;
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

  return v_prefix || '-' || p_annee::text || '-' || lpad(v_next::text, 4, '0');
end;
$$;

-- Triggers numérotation (exemple pour factures — même pattern pour dossiers/devis)
create or replace function public.set_facture_numero()
returns trigger language plpgsql as $$
begin
  if new.numero is null or new.numero like '%-LOCAL-%' then
    new.numero := public.next_numero('facture', extract(year from now())::int);
  end if;
  return new;
end;
$$;

create or replace function public.set_dossier_numero()
returns trigger language plpgsql as $$
begin
  if new.numero is null or new.numero like '%-LOCAL-%' then
    new.numero := public.next_numero('dossier', coalesce(new.annee, extract(year from now())::int));
  end if;
  return new;
end;
$$;

create or replace function public.set_devis_numero()
returns trigger language plpgsql as $$
begin
  if new.numero is null or new.numero like '%-LOCAL-%' then
    new.numero := public.next_numero('devis', coalesce(new.annee, extract(year from now())::int));
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
  notes         text,
  total_facture double precision not null default 0,
  total_paye    double precision not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.clients enable row level security;
drop policy if exists "Authentifié - accès complet" on public.clients;
create policy "Authentifié - accès complet" on public.clients
  for all using (auth.uid() is not null) with check (auth.uid() is not null);

drop trigger if exists trg_clients_updated_at on public.clients;
create trigger trg_clients_updated_at before update on public.clients
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

  statut              text not null default 'nouveau',
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
create trigger trg_dossiers_numero before insert on public.dossiers
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
