-- Daily AI usage counters for meal scan + coach chat rate limits.

create table if not exists public.ai_usage (
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  kind text not null check (kind in ('meal_scan', 'coach_chat')),
  count int not null default 0 check (count >= 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, day, kind)
);

create index if not exists ai_usage_user_day_idx
  on public.ai_usage (user_id, day desc);

alter table public.ai_usage enable row level security;

drop policy if exists ai_usage_select_own on public.ai_usage;
create policy ai_usage_select_own on public.ai_usage
  for select to authenticated
  using (auth.uid() = user_id);

-- Inserts/updates are performed by Edge Functions with the service role.
drop policy if exists ai_usage_insert_own on public.ai_usage;
drop policy if exists ai_usage_update_own on public.ai_usage;
