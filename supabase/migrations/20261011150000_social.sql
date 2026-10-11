-- Migration: 20261011150000_social.sql
-- Description: Social schema for privacy-first friend sharing, challenges, family groups, and block/report.
-- Privacy guarantee: Users only share steps, streak, and logged_today. Never food, weight, or health data.

-- 1. profiles_public
create table if not exists public.profiles_public (
  user_id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null default 'Vireo Member',
  avatar_seed text not null default 'vireo_default',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles_public enable row level security;

drop policy if exists profiles_public_select on public.profiles_public;
create policy profiles_public_select on public.profiles_public
  for select to authenticated
  using (true);

drop policy if exists profiles_public_insert on public.profiles_public;
create policy profiles_public_insert on public.profiles_public
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists profiles_public_update on public.profiles_public;
create policy profiles_public_update on public.profiles_public
  for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists profiles_public_delete on public.profiles_public;
create policy profiles_public_delete on public.profiles_public
  for delete to authenticated
  using (auth.uid() = user_id);


-- 2. friendships (user_id, friend_id, status: 'pending' | 'accepted' | 'blocked')
create table if not exists public.friendships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  friend_id uuid not null references auth.users (id) on delete cascade,
  status text not null default 'accepted' check (status in ('pending', 'accepted', 'blocked')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, friend_id)
);

create index if not exists friendships_user_idx on public.friendships (user_id);
create index if not exists friendships_friend_idx on public.friendships (friend_id);

alter table public.friendships enable row level security;

drop policy if exists friendships_select on public.friendships;
create policy friendships_select on public.friendships
  for select to authenticated
  using (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists friendships_insert on public.friendships;
create policy friendships_insert on public.friendships
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists friendships_update on public.friendships;
create policy friendships_update on public.friendships
  for update to authenticated
  using (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists friendships_delete on public.friendships;
create policy friendships_delete on public.friendships
  for delete to authenticated
  using (auth.uid() = user_id or auth.uid() = friend_id);


-- 3. challenges (id, owner_id, type 'weekly_steps'|'logging_streak', starts_at, ends_at, invite_code, is_family bool)
create table if not exists public.challenges (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users (id) on delete cascade,
  title text not null default 'Weekly Step Challenge',
  type text not null default 'weekly_steps' check (type in ('weekly_steps', 'logging_streak')),
  starts_at timestamptz not null default now(),
  ends_at timestamptz not null default (now() + interval '7 days'),
  invite_code text not null unique,
  is_family boolean not null default false,
  max_members int not null default 20,
  created_at timestamptz not null default now()
);

alter table public.challenges enable row level security;

drop policy if exists challenges_select on public.challenges;
create policy challenges_select on public.challenges
  for select to authenticated
  using (true);

drop policy if exists challenges_insert on public.challenges;
create policy challenges_insert on public.challenges
  for insert to authenticated
  with check (auth.uid() = owner_id);

drop policy if exists challenges_update on public.challenges;
create policy challenges_update on public.challenges
  for update to authenticated
  using (auth.uid() = owner_id);

drop policy if exists challenges_delete on public.challenges;
create policy challenges_delete on public.challenges
  for delete to authenticated
  using (auth.uid() = owner_id);


-- 4. challenge_members (challenge_id, user_id)
create table if not exists public.challenge_members (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null references public.challenges (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  joined_at timestamptz not null default now(),
  unique (challenge_id, user_id)
);

create index if not exists challenge_members_challenge_idx on public.challenge_members (challenge_id);
create index if not exists challenge_members_user_idx on public.challenge_members (user_id);

alter table public.challenge_members enable row level security;

drop policy if exists challenge_members_select on public.challenge_members;
create policy challenge_members_select on public.challenge_members
  for select to authenticated
  using (true);

drop policy if exists challenge_members_insert on public.challenge_members;
create policy challenge_members_insert on public.challenge_members
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists challenge_members_delete on public.challenge_members;
create policy challenge_members_delete on public.challenge_members
  for delete to authenticated
  using (auth.uid() = user_id);


-- 5. daily_shared_stats (user_id, day, steps, logged bool)
-- ONLY steps, streak & logged-today are ever shared. Never food, weight or health data.
create table if not exists public.daily_shared_stats (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  steps int not null default 0,
  logged boolean not null default false,
  streak int not null default 0,
  updated_at timestamptz not null default now(),
  unique (user_id, day)
);

create index if not exists daily_shared_stats_user_day_idx on public.daily_shared_stats (user_id, day);

alter table public.daily_shared_stats enable row level security;

drop policy if exists daily_shared_stats_select on public.daily_shared_stats;
create policy daily_shared_stats_select on public.daily_shared_stats
  for select to authenticated
  using (true);

drop policy if exists daily_shared_stats_insert on public.daily_shared_stats;
create policy daily_shared_stats_insert on public.daily_shared_stats
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists daily_shared_stats_update on public.daily_shared_stats;
create policy daily_shared_stats_update on public.daily_shared_stats
  for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists daily_shared_stats_delete on public.daily_shared_stats;
create policy daily_shared_stats_delete on public.daily_shared_stats
  for delete to authenticated
  using (auth.uid() = user_id);


-- 6. user_reports (reporter_id, reported_user_id, reason, details)
create table if not exists public.user_reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references auth.users (id) on delete cascade,
  reported_user_id uuid not null references auth.users (id) on delete cascade,
  reason text not null,
  details text,
  created_at timestamptz not null default now()
);

alter table public.user_reports enable row level security;

drop policy if exists user_reports_insert on public.user_reports;
create policy user_reports_insert on public.user_reports
  for insert to authenticated
  with check (auth.uid() = reporter_id);
