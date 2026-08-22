-- Progress tracking extensions and monthly re-assessment.

alter table public.users
  add column if not exists weight_goal_kg numeric,
  add column if not exists program_phase int not null default 1,
  add column if not exists last_reassessment_at timestamptz;

alter table public.checkins
  add column if not exists energy_score int check (energy_score between 1 and 10),
  add column if not exists adherence_pct int check (adherence_pct between 0 and 100);

create table if not exists public.reassessments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  weight_kg numeric not null,
  activity_level text not null,
  training_environment text not null,
  program_phase int not null default 1,
  previous_weight_kg numeric,
  previous_activity_level text,
  previous_training_environment text,
  phase_recalculated boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists reassessments_user_created_idx
  on public.reassessments (user_id, created_at desc);

alter table public.reassessments enable row level security;

create policy reassessments_own_rows on public.reassessments for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
