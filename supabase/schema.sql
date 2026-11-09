-- Run once in Supabase SQL Editor. Staff accounts are created in Authentication > Users.
create extension if not exists pgcrypto;
create table if not exists public.staff_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '', office text not null default '',
  role text not null default 'editor' check (role in ('editor','admin')),
  created_at timestamptz not null default now()
);
create table if not exists public.events (
  id uuid primary key default gen_random_uuid(), title text not null,
  agency text not null, start_at timestamptz not null, end_at timestamptz,
  timezone text not null default 'UTC', city text not null default '',country text not null default '',
  venue text not null default '',format text not null default 'In person',theme text not null default '',
  description text not null default '',official_url text not null default '',
  registration_deadline date,status text not null default 'Published' check(status in ('Published','Cancelled','Tentative')),
  attendance_status text not null default 'Representative needed' check(attendance_status in ('Representative needed','Nominated','Invited','Confirmed','Attended','Declined')),
  representative_name text not null default '',representative_office text not null default '',representative_email text not null default '',
  notes text not null default '',source text not null default 'Manual',
  created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists events_start_idx on public.events(start_at);
create or replace function public.is_staff() returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.staff_profiles where user_id=auth.uid())$$;
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.staff_profiles where user_id=auth.uid() and role='admin')$$;
create or replace function public.set_updated_at() returns trigger language plpgsql as $$begin new.updated_at=now();return new;end$$;
drop trigger if exists events_updated_at on public.events;
create trigger events_updated_at before update on public.events for each row execute function public.set_updated_at();
alter table public.staff_profiles enable row level security;
alter table public.events enable row level security;
create policy "staff read own profile" on public.staff_profiles for select to authenticated using (user_id=auth.uid() or public.is_admin());
create policy "public read events" on public.events for select to anon,authenticated using (true);
create policy "staff create events" on public.events for insert to authenticated with check(public.is_staff() and created_by=auth.uid());
create policy "staff update events" on public.events for update to authenticated using(public.is_staff()) with check(public.is_staff());
create policy "admins delete events" on public.events for delete to authenticated using(public.is_admin());
-- To authorize a staff user after creating them in Authentication > Users:
-- insert into public.staff_profiles (user_id,full_name,office,role)
-- values ('PASTE-AUTH-USER-UUID','Staff Member','ADRA International','admin');
