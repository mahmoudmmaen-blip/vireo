-- Table: public.subscriptions
-- Tracks current subscription & entitlement state synced from RevenueCat webhook.

create table if not exists public.subscriptions (
  user_id uuid primary key references auth.users (id) on delete cascade,
  entitlement text not null default 'pro',
  expires_at timestamptz,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists subscriptions_user_status_idx
  on public.subscriptions (user_id, status);

alter table public.subscriptions enable row level security;

-- Authenticated users can view their own subscription row.
drop policy if exists subscriptions_select_own on public.subscriptions;
create policy subscriptions_select_own on public.subscriptions
  for select to authenticated
  using (auth.uid() = user_id);

-- Service role handles inserts/updates via RevenueCat webhook edge function.
drop policy if exists subscriptions_service_role_all on public.subscriptions;
