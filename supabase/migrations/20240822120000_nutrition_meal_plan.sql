-- Nutrition & meal-plan schema additions for Vireo.

-- Extend users profile fields used by meal-plan generation.
alter table public.users
  add column if not exists cuisine_preference text[] not null default '{international_healthy}',
  add column if not exists dietary_restrictions text[] not null default '{}';

-- Recipes catalog (global read, service-role write).
create table if not exists public.recipes (
  id uuid primary key default gen_random_uuid(),
  title_ar text not null,
  title_en text not null,
  ingredient_ids uuid[] not null default '{}',
  prep_time_minutes int not null default 15,
  goal_tag text not null check (goal_tag in ('high_protein', 'quick_easy', 'light_energy')),
  cuisine_tag text not null check (
    cuisine_tag in ('egyptian', 'khaleeji', 'levantine', 'international_healthy')
  ),
  meal_type text not null check (
    meal_type in ('breakfast', 'lunch', 'dinner', 'snack')
  ),
  dietary_tags text[] not null default '{}',
  steps_ar text[] not null default '{}',
  steps_en text[] not null default '{}',
  created_at timestamptz not null default now()
);

create index if not exists recipes_cuisine_meal_idx
  on public.recipes (cuisine_tag, meal_type);

create index if not exists recipes_dietary_tags_gin
  on public.recipes using gin (dietary_tags);

-- Tracks served recipes to avoid repetition.
create table if not exists public.user_recipe_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  recipe_id uuid not null references public.recipes (id) on delete cascade,
  meal_plan_id uuid,
  served_at timestamptz not null default now()
);

create index if not exists user_recipe_history_user_served_idx
  on public.user_recipe_history (user_id, served_at desc);

create index if not exists user_recipe_history_user_recipe_idx
  on public.user_recipe_history (user_id, recipe_id, served_at desc);

-- Weekly meal plan slots.
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

-- RLS
alter table public.recipes enable row level security;
alter table public.user_recipe_history enable row level security;
alter table public.meal_plans enable row level security;

create policy recipes_select_authenticated
  on public.recipes for select
  to authenticated
  using (true);

create policy user_recipe_history_own_rows
  on public.user_recipe_history for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy meal_plans_own_rows
  on public.meal_plans for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
