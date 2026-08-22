-- Core Vireo schema: users, profiles, workouts, progress, and logs.
-- Required before nutrition migration and delete-account edge function.

create table if not exists public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  age int,
  height_cm numeric,
  weight_kg numeric,
  activity_level text,
  medical_flag boolean not null default false,
  training_environment text,
  goal text,
  unit_preference text,
  consent_accepted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

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

create table if not exists public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  program_day_id uuid references public.program_days (id) on delete set null,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists workout_sessions_user_idx on public.workout_sessions (user_id);

create table if not exists public.workout_checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  session_id uuid references public.workout_sessions (id) on delete cascade,
  feedback text,
  created_at timestamptz not null default now()
);

create table if not exists public.checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  week_number int not null,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  weight_kg numeric not null,
  logged_at timestamptz not null default now()
);

create index if not exists weight_logs_user_idx on public.weight_logs (user_id, logged_at desc);

create table if not exists public.walking_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  steps int not null default 0,
  logged_at timestamptz not null default now()
);

create index if not exists walking_logs_user_idx on public.walking_logs (user_id, logged_at desc);

create table if not exists public.progress_photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  storage_path text not null,
  taken_at timestamptz not null default now()
);

create index if not exists progress_photos_user_idx on public.progress_photos (user_id);

create table if not exists public.fridge_scans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  image_path text,
  detected_items text[] not null default '{}',
  confirmed_items text[] not null default '{}',
  created_at timestamptz not null default now()
);

create index if not exists fridge_scans_user_idx on public.fridge_scans (user_id, created_at desc);

-- Auto-create profile row on sign-up.
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

-- RLS
alter table public.users enable row level security;
alter table public.profiles enable row level security;
alter table public.programs enable row level security;
alter table public.program_days enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.workout_checkins enable row level security;
alter table public.checkins enable row level security;
alter table public.weight_logs enable row level security;
alter table public.walking_logs enable row level security;
alter table public.progress_photos enable row level security;
alter table public.fridge_scans enable row level security;

create policy users_own_row on public.users for all to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

create policy profiles_own_row on public.profiles for all to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

create policy programs_own_rows on public.programs for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy program_days_own_rows on public.program_days for all to authenticated
  using (
    program_id in (select id from public.programs where user_id = auth.uid())
  )
  with check (
    program_id in (select id from public.programs where user_id = auth.uid())
  );

create policy workout_sessions_own_rows on public.workout_sessions for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy workout_checkins_own_rows on public.workout_checkins for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy checkins_own_rows on public.checkins for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy weight_logs_own_rows on public.weight_logs for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy walking_logs_own_rows on public.walking_logs for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy progress_photos_own_rows on public.progress_photos for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy fridge_scans_own_rows on public.fridge_scans for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Storage bucket for progress photos (private per-user folders).
insert into storage.buckets (id, name, public)
values ('progress-photos', 'progress-photos', false)
on conflict (id) do nothing;

create policy progress_photos_storage_own on storage.objects for all to authenticated
  using (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'progress-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
