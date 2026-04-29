-- ============================================================
-- AvarieApp — Schéma Supabase (PostgreSQL)
-- Source de vérité pour toutes les tables côté serveur.
-- À exécuter dans l'éditeur SQL Supabase une seule fois.
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
create policy "Lecture propre profil" on public.profiles
  for select using (auth.uid() = id);
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

create or replace function public.next_numero(p_type text, p_annee int)
returns text language plpgsql as $$
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

-- ─── Variables d'environnement à configurer dans Supabase ─────────────────
-- Dashboard → Settings → Edge Functions → Secrets :
--   RESEND_API_KEY   : clé API Resend.com
--   FROM_EMAIL       : adresse expéditeur (ex: facturation@votrecabinet.ga)
--   CABINET_NOM      : nom du cabinet (ex: Cabinet Maritime Gabon)
--   APP_URL          : URL de l'app déployée (ex: https://gemex.vercel.app)
--   SUPABASE_SERVICE_ROLE_KEY : clé service_role (auto-injectée dans Edge Functions)
