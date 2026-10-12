-- Table: public.pro_grants
-- Allows manual reviewer or testing Pro grants (e.g. Google Play reviewer access).
-- Reviewers need full Pro access without paying.

create table if not exists public.pro_grants (
  email text primary key,
  note text,
  expires_at timestamptz null,
  created_at timestamptz not null default now()
);

alter table public.pro_grants enable row level security;

-- Authenticated user can select only the row matching auth.email().
drop policy if exists pro_grants_select_own on public.pro_grants;
create policy pro_grants_select_own on public.pro_grants
  for select to authenticated
  using (lower(email) = lower(auth.jwt()->>'email'));
