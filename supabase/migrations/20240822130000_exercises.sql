-- Exercise library for workout programs and swap alternatives.

create table if not exists public.exercises (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  name_ar text,
  target_muscle text not null,
  target_muscle_ar text,
  sets int not null default 3,
  reps int not null default 10,
  rest_seconds int not null default 60,
  video_url text not null default '',
  type text not null default 'strength'
    check (type in ('strength', 'mobility', 'cardio')),
  environments text[] not null default '{}',
  created_at timestamptz not null default now()
);

create index if not exists exercises_target_muscle_idx
  on public.exercises (target_muscle);

create index if not exists exercises_environments_gin
  on public.exercises using gin (environments);

alter table public.exercises enable row level security;

create policy exercises_select_authenticated
  on public.exercises for select
  to authenticated
  using (true);

-- Align workout_checkins feedback column naming with client.
alter table public.workout_checkins
  add column if not exists feedback text;
