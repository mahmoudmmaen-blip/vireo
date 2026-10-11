-- Migration: 20261011160000_offline_sync.sql
-- Description: Tables supporting offline-first sync engine with user_id, updated_at, deleted_at and RLS (owner only).

-- 1. nutrition_logs (meals, items, calories, macros)
create table if not exists public.nutrition_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  meal_type text not null,
  logged_at timestamptz not null default now(),
  items jsonb not null default '[]'::jsonb,
  total_calories int not null default 0,
  total_protein double precision not null default 0,
  total_carbs double precision not null default 0,
  total_fat double precision not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index if not exists nutrition_logs_user_date_idx on public.nutrition_logs (user_id, logged_at);
alter table public.nutrition_logs enable row level security;

drop policy if exists nutrition_logs_owner_all on public.nutrition_logs;
create policy nutrition_logs_owner_all on public.nutrition_logs
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 2. water_logs (water entries, cups, daily total)
create table if not exists public.water_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  amount_ml int not null default 0,
  goal_ml int not null default 2500,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id, day)
);

create index if not exists water_logs_user_day_idx on public.water_logs (user_id, day);
alter table public.water_logs enable row level security;

drop policy if exists water_logs_owner_all on public.water_logs;
create policy water_logs_owner_all on public.water_logs
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 3. daily_steps_history
create table if not exists public.daily_steps_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  steps int not null default 0,
  goal int not null default 6000,
  distance_km double precision not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id, day)
);

create index if not exists daily_steps_user_day_idx on public.daily_steps_history (user_id, day);
alter table public.daily_steps_history enable row level security;

drop policy if exists daily_steps_owner_all on public.daily_steps_history;
create policy daily_steps_owner_all on public.daily_steps_history
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 4. gps_workouts (outdoor routes, distance, pace, polyline/points)
create table if not exists public.gps_workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  activity_type text not null default 'walking',
  duration_seconds int not null default 0,
  distance_meters double precision not null default 0,
  route_points jsonb not null default '[]'::jsonb,
  started_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index if not exists gps_workouts_user_idx on public.gps_workouts (user_id, started_at);
alter table public.gps_workouts enable row level security;

drop policy if exists gps_workouts_owner_all on public.gps_workouts;
create policy gps_workouts_owner_all on public.gps_workouts
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 5. weight_logs
create table if not exists public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  logged_at timestamptz not null default now(),
  weight_kg double precision not null,
  body_fat_percentage double precision,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index if not exists weight_logs_user_date_idx on public.weight_logs (user_id, logged_at);
alter table public.weight_logs enable row level security;

drop policy if exists weight_logs_owner_all on public.weight_logs;
create policy weight_logs_owner_all on public.weight_logs
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 6. user_diet_programs
create table if not exists public.user_diet_programs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  program_id text not null,
  phase int not null default 1,
  started_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id)
);

alter table public.user_diet_programs enable row level security;

drop policy if exists user_diet_programs_owner_all on public.user_diet_programs;
create policy user_diet_programs_owner_all on public.user_diet_programs
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 7. today_plan_completions
create table if not exists public.today_plan_completions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  task_id text not null,
  completed boolean not null default false,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id, day, task_id)
);

create index if not exists today_plan_user_day_idx on public.today_plan_completions (user_id, day);
alter table public.today_plan_completions enable row level security;

drop policy if exists today_plan_owner_all on public.today_plan_completions;
create policy today_plan_owner_all on public.today_plan_completions
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 8. vitality_daily_logs
create table if not exists public.vitality_daily_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null,
  protocol_data jsonb not null default '{}'::jsonb,
  sunlight_done boolean not null default false,
  workout_done boolean not null default false,
  breathing_sessions int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (user_id, day)
);

create index if not exists vitality_logs_user_day_idx on public.vitality_daily_logs (user_id, day);
alter table public.vitality_daily_logs enable row level security;

drop policy if exists vitality_logs_owner_all on public.vitality_daily_logs;
create policy vitality_logs_owner_all on public.vitality_daily_logs
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- 9. user_settings
create table if not exists public.user_settings (
  user_id uuid primary key references auth.users (id) on delete cascade,
  settings_json jsonb not null default '{}'::jsonb,
  backup_photos_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

alter table public.user_settings enable row level security;

drop policy if exists user_settings_owner_all on public.user_settings;
create policy user_settings_owner_all on public.user_settings
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
