-- Body composition reports (InBody / Tanita / Health Connect)
-- Also allow body_report AI usage kind.

alter table public.ai_usage
  drop constraint if exists ai_usage_kind_check;

alter table public.ai_usage
  add constraint ai_usage_kind_check
  check (kind in ('meal_scan', 'coach_chat', 'body_report'));

create table if not exists public.body_composition (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  test_date date not null,
  device_model text,
  source text not null default 'inbody_scan'
    check (source in ('inbody_scan', 'health_connect', 'manual')),
  weight_kg double precision,
  skeletal_muscle_mass_kg double precision,
  body_fat_mass_kg double precision,
  percent_body_fat double precision,
  bmi double precision,
  visceral_fat_level double precision,
  bmr_kcal double precision,
  total_body_water_l double precision,
  protein_kg double precision,
  minerals_kg double precision,
  inbody_score double precision,
  waist_hip_ratio double precision,
  segmental_lean jsonb,
  segmental_fat jsonb,
  field_confidence jsonb,
  raw_payload jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists body_composition_user_date_idx
  on public.body_composition (user_id, test_date desc);

alter table public.body_composition enable row level security;

drop policy if exists body_composition_select_own on public.body_composition;
create policy body_composition_select_own on public.body_composition
  for select using (auth.uid() = user_id);

drop policy if exists body_composition_insert_own on public.body_composition;
create policy body_composition_insert_own on public.body_composition
  for insert with check (auth.uid() = user_id);

drop policy if exists body_composition_update_own on public.body_composition;
create policy body_composition_update_own on public.body_composition
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists body_composition_delete_own on public.body_composition;
create policy body_composition_delete_own on public.body_composition
  for delete using (auth.uid() = user_id);
