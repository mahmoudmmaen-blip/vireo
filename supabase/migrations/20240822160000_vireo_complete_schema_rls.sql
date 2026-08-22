-- Vireo complete schema alignment, RLS on every table, and catalog read policies.
-- Idempotent: safe to run after earlier incremental migrations.

-- ---------------------------------------------------------------------------
-- users
-- ---------------------------------------------------------------------------
create table if not exists public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  age int,
  height_cm numeric,
  weight_kg numeric,
  activity_level text,
  medical_flag boolean not null default false,
  training_environment text,
  goal text,
  dietary_restrictions text[] not null default '{}',
  consent_accepted_at timestamptz,
  unit_preference text,
  created_at timestamptz not null default now()
);

alter table public.users
  add column if not exists age int,
  add column if not exists height_cm numeric,
  add column if not exists weight_kg numeric,
  add column if not exists activity_level text,
  add column if not exists medical_flag boolean not null default false,
  add column if not exists training_environment text,
  add column if not exists goal text,
  add column if not exists dietary_restrictions text[] not null default '{}',
  add column if not exists consent_accepted_at timestamptz,
  add column if not exists unit_preference text,
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists weight_goal_kg numeric,
  add column if not exists program_phase int not null default 1,
  add column if not exists last_reassessment_at timestamptz,
  add column if not exists subscription_tier text not null default 'free',
  add column if not exists cuisine_preference text[] not null default '{international_healthy}';

-- ---------------------------------------------------------------------------
-- exercises (global catalog — authenticated read, no client writes)
-- ---------------------------------------------------------------------------
create table if not exists public.exercises (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null,
  name_en text not null,
  environment_tags text[] not null default '{}',
  target_muscle text not null,
  sets int not null default 3,
  reps int not null default 10,
  rest_seconds int not null default 60,
  video_url text not null default '',
  description_ar text not null default '',
  description_en text not null default '',
  difficulty text not null default 'moderate'
    check (difficulty in ('beginner', 'moderate', 'advanced')),
  created_at timestamptz not null default now()
);

alter table public.exercises
  add column if not exists name_ar text,
  add column if not exists name_en text,
  add column if not exists environment_tags text[] not null default '{}',
  add column if not exists target_muscle text,
  add column if not exists sets int not null default 3,
  add column if not exists reps int not null default 10,
  add column if not exists rest_seconds int not null default 60,
  add column if not exists video_url text not null default '',
  add column if not exists description_ar text not null default '',
  add column if not exists description_en text not null default '',
  add column if not exists difficulty text not null default 'moderate';

-- Backfill from legacy column names when present.
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'exercises' and column_name = 'name'
  ) then
    execute $sql$
      update public.exercises
      set name_en = coalesce(name_en, name)
      where name_en is null and name is not null
    $sql$;
  end if;

  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'exercises' and column_name = 'environments'
  ) then
    execute $sql$
      update public.exercises
      set environment_tags = coalesce(environment_tags, environments)
      where (environment_tags is null or environment_tags = '{}')
        and environments is not null
    $sql$;
  end if;
end $$;

update public.exercises
set name_en = coalesce(name_en, 'Exercise'),
    name_ar = coalesce(name_ar, name_en, 'تمرين'),
    target_muscle = coalesce(target_muscle, 'full_body')
where name_en is null or name_ar is null or target_muscle is null;

alter table public.exercises
  alter column name_en set not null,
  alter column name_ar set not null,
  alter column target_muscle set not null;

create index if not exists exercises_target_muscle_idx
  on public.exercises (target_muscle);

create index if not exists exercises_environment_tags_gin
  on public.exercises using gin (environment_tags);

-- ---------------------------------------------------------------------------
-- programs & program_days
-- ---------------------------------------------------------------------------
create table if not exists public.programs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  phase_number int not null default 1,
  week_number int not null default 1,
  start_date date not null,
  created_at timestamptz not null default now()
);

create index if not exists programs_user_idx on public.programs (user_id);

create table if not exists public.program_days (
  id uuid primary key default gen_random_uuid(),
  program_id uuid not null references public.programs (id) on delete cascade,
  day_index int not null check (day_index between 0 and 6),
  type text not null,
  exercise_ids uuid[] not null default '{}'
);

create index if not exists program_days_program_idx on public.program_days (program_id);

-- ---------------------------------------------------------------------------
-- checkins
-- ---------------------------------------------------------------------------
create table if not exists public.checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  week_number int not null,
  adherence int check (adherence between 0 and 100),
  energy_score int check (energy_score between 1 and 10),
  created_at timestamptz not null default now()
);

alter table public.checkins
  add column if not exists adherence int check (adherence between 0 and 100),
  add column if not exists adherence_pct int check (adherence_pct between 0 and 100),
  add column if not exists energy_score int check (energy_score between 1 and 10),
  add column if not exists notes text;

do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'checkins' and column_name = 'adherence_pct'
  ) then
    execute $sql$
      update public.checkins
      set adherence = coalesce(adherence, adherence_pct)
      where adherence is null and adherence_pct is not null
    $sql$;
  end if;
end $$;

create index if not exists checkins_user_week_idx
  on public.checkins (user_id, week_number);

-- ---------------------------------------------------------------------------
-- walking_logs
-- ---------------------------------------------------------------------------
create table if not exists public.walking_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  date date not null default (timezone('utc', now()))::date,
  steps int not null default 0,
  source text not null default 'health_kit',
  logged_at timestamptz not null default now()
);

alter table public.walking_logs
  add column if not exists date date,
  add column if not exists steps int not null default 0,
  add column if not exists source text not null default 'health_kit',
  add column if not exists logged_at timestamptz not null default now();

update public.walking_logs
set date = coalesce(date, logged_at::date)
where date is null;

alter table public.walking_logs
  alter column date set not null;

create index if not exists walking_logs_user_date_idx
  on public.walking_logs (user_id, date desc);

-- ---------------------------------------------------------------------------
-- weight_logs
-- ---------------------------------------------------------------------------
create table if not exists public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  weight_kg numeric not null,
  logged_at timestamptz not null default now()
);

create index if not exists weight_logs_user_idx
  on public.weight_logs (user_id, logged_at desc);

-- ---------------------------------------------------------------------------
-- reassessments
-- ---------------------------------------------------------------------------
create table if not exists public.reassessments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  weight_kg numeric not null,
  activity_level text not null,
  training_environment text not null,
  phase_recalculated boolean not null default false,
  created_at timestamptz not null default now(),
  program_phase int not null default 1,
  previous_weight_kg numeric,
  previous_activity_level text,
  previous_training_environment text
);

alter table public.reassessments
  add column if not exists phase_recalculated boolean not null default false,
  add column if not exists program_phase int not null default 1,
  add column if not exists previous_weight_kg numeric,
  add column if not exists previous_activity_level text,
  add column if not exists previous_training_environment text;

create index if not exists reassessments_user_created_idx
  on public.reassessments (user_id, created_at desc);

-- ---------------------------------------------------------------------------
-- progress_photos
-- ---------------------------------------------------------------------------
create table if not exists public.progress_photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  image_url text not null,
  taken_at timestamptz not null default now(),
  is_private boolean not null default true,
  storage_path text
);

alter table public.progress_photos
  add column if not exists image_url text,
  add column if not exists taken_at timestamptz not null default now(),
  add column if not exists is_private boolean not null default true,
  add column if not exists storage_path text;

update public.progress_photos
set image_url = coalesce(image_url, storage_path)
where image_url is null and storage_path is not null;

create index if not exists progress_photos_user_idx
  on public.progress_photos (user_id, taken_at desc);

-- ---------------------------------------------------------------------------
-- food_items (global catalog)
-- ---------------------------------------------------------------------------
create table if not exists public.food_items (
  id uuid primary key default gen_random_uuid(),
  name_ar text not null,
  name_en text not null,
  category text,
  region_tags text[] not null default '{}',
  prep_difficulty text not null default 'easy'
    check (prep_difficulty in ('easy', 'medium', 'hard')),
  created_at timestamptz not null default now()
);

alter table public.food_items
  add column if not exists region_tags text[] not null default '{}',
  add column if not exists prep_difficulty text not null default 'easy';

create index if not exists food_items_name_en_idx on public.food_items (lower(name_en));
create index if not exists food_items_name_ar_idx on public.food_items (lower(name_ar));
create index if not exists food_items_region_tags_gin
  on public.food_items using gin (region_tags);

-- ---------------------------------------------------------------------------
-- recipes (global catalog)
-- ---------------------------------------------------------------------------
create table if not exists public.recipes (
  id uuid primary key default gen_random_uuid(),
  title_ar text not null,
  title_en text not null,
  ingredient_ids uuid[] not null default '{}',
  prep_time_minutes int not null default 15,
  goal_tag text not null,
  steps_ar text[] not null default '{}',
  steps_en text[] not null default '{}',
  created_at timestamptz not null default now()
);

alter table public.recipes
  add column if not exists ingredient_ids uuid[] not null default '{}',
  add column if not exists steps_ar text[] not null default '{}',
  add column if not exists steps_en text[] not null default '{}';

create index if not exists recipes_goal_tag_idx on public.recipes (goal_tag);

-- ---------------------------------------------------------------------------
-- fridge_scans
-- ---------------------------------------------------------------------------
create table if not exists public.fridge_scans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  image_url text,
  detected_items text[] not null default '{}',
  confirmed_items text[] not null default '{}',
  created_at timestamptz not null default now(),
  image_path text
);

alter table public.fridge_scans
  add column if not exists image_url text,
  add column if not exists detected_items text[] not null default '{}',
  add column if not exists confirmed_items text[] not null default '{}',
  add column if not exists image_path text;

update public.fridge_scans
set image_url = coalesce(image_url, image_path)
where image_url is null and image_path is not null;

create index if not exists fridge_scans_user_idx
  on public.fridge_scans (user_id, created_at desc);

-- ---------------------------------------------------------------------------
-- meal_plans
-- ---------------------------------------------------------------------------
create table if not exists public.meal_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  week_number int not null,
  day_index int not null check (day_index between 0 and 6),
  meal_type text not null check (
    meal_type in ('breakfast', 'lunch', 'dinner', 'snack')
  ),
  recipe_id uuid not null references public.recipes (id),
  created_at timestamptz not null default now(),
  unique (user_id, week_number, day_index, meal_type)
);

create index if not exists meal_plans_user_week_idx
  on public.meal_plans (user_id, week_number, day_index);

-- ---------------------------------------------------------------------------
-- Supporting tables used by the app (kept for compatibility)
-- ---------------------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  program_day_id uuid references public.program_days (id) on delete set null,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.workout_checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  session_id uuid references public.workout_sessions (id) on delete cascade,
  feedback text,
  created_at timestamptz not null default now()
);

create table if not exists public.user_recipe_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  recipe_id uuid not null references public.recipes (id) on delete cascade,
  meal_plan_id uuid,
  served_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Auth trigger: provision users + profiles rows
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id) values (new.id)
  on conflict (id) do nothing;
  insert into public.profiles (id) values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Row Level Security — enable on EVERY table
-- ---------------------------------------------------------------------------
alter table public.users enable row level security;
alter table public.exercises enable row level security;
alter table public.programs enable row level security;
alter table public.program_days enable row level security;
alter table public.checkins enable row level security;
alter table public.walking_logs enable row level security;
alter table public.weight_logs enable row level security;
alter table public.reassessments enable row level security;
alter table public.progress_photos enable row level security;
alter table public.food_items enable row level security;
alter table public.recipes enable row level security;
alter table public.fridge_scans enable row level security;
alter table public.meal_plans enable row level security;
alter table public.profiles enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.workout_checkins enable row level security;
alter table public.user_recipe_history enable row level security;

-- Drop legacy policies so this migration is idempotent.
do $$
declare
  r record;
begin
  for r in
    select schemaname, tablename, policyname
    from pg_policies
    where schemaname = 'public'
      and tablename in (
        'users', 'exercises', 'programs', 'program_days', 'checkins',
        'walking_logs', 'weight_logs', 'reassessments', 'progress_photos',
        'food_items', 'recipes', 'fridge_scans', 'meal_plans', 'profiles',
        'workout_sessions', 'workout_checkins', 'user_recipe_history'
      )
  loop
    execute format('drop policy if exists %I on public.%I', r.policyname, r.tablename);
  end loop;
end $$;

-- User-owned rows: full CRUD restricted to auth.uid().
create policy users_select_own on public.users
  for select to authenticated using (id = auth.uid());
create policy users_insert_own on public.users
  for insert to authenticated with check (id = auth.uid());
create policy users_update_own on public.users
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy users_delete_own on public.users
  for delete to authenticated using (id = auth.uid());

create policy profiles_select_own on public.profiles
  for select to authenticated using (id = auth.uid());
create policy profiles_insert_own on public.profiles
  for insert to authenticated with check (id = auth.uid());
create policy profiles_update_own on public.profiles
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy profiles_delete_own on public.profiles
  for delete to authenticated using (id = auth.uid());

create policy programs_select_own on public.programs
  for select to authenticated using (user_id = auth.uid());
create policy programs_insert_own on public.programs
  for insert to authenticated with check (user_id = auth.uid());
create policy programs_update_own on public.programs
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy programs_delete_own on public.programs
  for delete to authenticated using (user_id = auth.uid());

create policy program_days_select_own on public.program_days
  for select to authenticated using (
    program_id in (select id from public.programs where user_id = auth.uid())
  );
create policy program_days_insert_own on public.program_days
  for insert to authenticated with check (
    program_id in (select id from public.programs where user_id = auth.uid())
  );
create policy program_days_update_own on public.program_days
  for update to authenticated using (
    program_id in (select id from public.programs where user_id = auth.uid())
  )
  with check (
    program_id in (select id from public.programs where user_id = auth.uid())
  );
create policy program_days_delete_own on public.program_days
  for delete to authenticated using (
    program_id in (select id from public.programs where user_id = auth.uid())
  );

create policy checkins_select_own on public.checkins
  for select to authenticated using (user_id = auth.uid());
create policy checkins_insert_own on public.checkins
  for insert to authenticated with check (user_id = auth.uid());
create policy checkins_update_own on public.checkins
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy checkins_delete_own on public.checkins
  for delete to authenticated using (user_id = auth.uid());

create policy walking_logs_select_own on public.walking_logs
  for select to authenticated using (user_id = auth.uid());
create policy walking_logs_insert_own on public.walking_logs
  for insert to authenticated with check (user_id = auth.uid());
create policy walking_logs_update_own on public.walking_logs
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy walking_logs_delete_own on public.walking_logs
  for delete to authenticated using (user_id = auth.uid());

create policy weight_logs_select_own on public.weight_logs
  for select to authenticated using (user_id = auth.uid());
create policy weight_logs_insert_own on public.weight_logs
  for insert to authenticated with check (user_id = auth.uid());
create policy weight_logs_update_own on public.weight_logs
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy weight_logs_delete_own on public.weight_logs
  for delete to authenticated using (user_id = auth.uid());

create policy reassessments_select_own on public.reassessments
  for select to authenticated using (user_id = auth.uid());
create policy reassessments_insert_own on public.reassessments
  for insert to authenticated with check (user_id = auth.uid());
create policy reassessments_update_own on public.reassessments
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy reassessments_delete_own on public.reassessments
  for delete to authenticated using (user_id = auth.uid());

create policy progress_photos_select_own on public.progress_photos
  for select to authenticated using (user_id = auth.uid());
create policy progress_photos_insert_own on public.progress_photos
  for insert to authenticated with check (user_id = auth.uid());
create policy progress_photos_update_own on public.progress_photos
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy progress_photos_delete_own on public.progress_photos
  for delete to authenticated using (user_id = auth.uid());

create policy fridge_scans_select_own on public.fridge_scans
  for select to authenticated using (user_id = auth.uid());
create policy fridge_scans_insert_own on public.fridge_scans
  for insert to authenticated with check (user_id = auth.uid());
create policy fridge_scans_update_own on public.fridge_scans
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy fridge_scans_delete_own on public.fridge_scans
  for delete to authenticated using (user_id = auth.uid());

create policy meal_plans_select_own on public.meal_plans
  for select to authenticated using (user_id = auth.uid());
create policy meal_plans_insert_own on public.meal_plans
  for insert to authenticated with check (user_id = auth.uid());
create policy meal_plans_update_own on public.meal_plans
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy meal_plans_delete_own on public.meal_plans
  for delete to authenticated using (user_id = auth.uid());

create policy workout_sessions_select_own on public.workout_sessions
  for select to authenticated using (user_id = auth.uid());
create policy workout_sessions_insert_own on public.workout_sessions
  for insert to authenticated with check (user_id = auth.uid());
create policy workout_sessions_update_own on public.workout_sessions
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy workout_sessions_delete_own on public.workout_sessions
  for delete to authenticated using (user_id = auth.uid());

create policy workout_checkins_select_own on public.workout_checkins
  for select to authenticated using (user_id = auth.uid());
create policy workout_checkins_insert_own on public.workout_checkins
  for insert to authenticated with check (user_id = auth.uid());
create policy workout_checkins_update_own on public.workout_checkins
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy workout_checkins_delete_own on public.workout_checkins
  for delete to authenticated using (user_id = auth.uid());

create policy user_recipe_history_select_own on public.user_recipe_history
  for select to authenticated using (user_id = auth.uid());
create policy user_recipe_history_insert_own on public.user_recipe_history
  for insert to authenticated with check (user_id = auth.uid());
create policy user_recipe_history_update_own on public.user_recipe_history
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy user_recipe_history_delete_own on public.user_recipe_history
  for delete to authenticated using (user_id = auth.uid());

-- Global catalogs: read-only for authenticated clients (writes via service role).
create policy exercises_select_authenticated on public.exercises
  for select to authenticated using (true);

create policy food_items_select_authenticated on public.food_items
  for select to authenticated using (true);

create policy recipes_select_authenticated on public.recipes
  for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- Storage buckets
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values
  ('progress-photos', 'progress-photos', false),
  ('fridge-scans', 'fridge-scans', true)
on conflict (id) do nothing;

drop policy if exists progress_photos_storage_own on storage.objects;
create policy progress_photos_storage_own on storage.objects for all to authenticated
  using (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists fridge_scans_storage_own on storage.objects;
create policy fridge_scans_storage_own on storage.objects for all to authenticated
  using (
    bucket_id = 'fridge-scans'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'fridge-scans'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Keep adherence_pct in sync when clients still write the legacy column.
create or replace function public.sync_checkin_adherence()
returns trigger
language plpgsql
as $$
begin
  if new.adherence is null and new.adherence_pct is not null then
    new.adherence := new.adherence_pct;
  elsif new.adherence_pct is null and new.adherence is not null then
    new.adherence_pct := new.adherence;
  end if;
  return new;
end;
$$;

drop trigger if exists checkins_sync_adherence on public.checkins;
create trigger checkins_sync_adherence
  before insert or update on public.checkins
  for each row execute function public.sync_checkin_adherence();
