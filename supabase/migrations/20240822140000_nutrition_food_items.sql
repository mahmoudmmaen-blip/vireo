-- Food catalog, fridge scan fixes, subscription tier, storage bucket.

alter table public.users
  add column if not exists subscription_tier text not null default 'free'
    check (subscription_tier in ('free', 'premium'));

alter table public.fridge_scans
  add column if not exists image_url text;

create table if not exists public.food_items (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_ar text not null,
  category text,
  created_at timestamptz not null default now()
);

create index if not exists food_items_name_en_idx on public.food_items (lower(name_en));
create index if not exists food_items_name_ar_idx on public.food_items (lower(name_ar));

alter table public.food_items enable row level security;

create policy food_items_select_authenticated
  on public.food_items for select
  to authenticated
  using (true);

insert into storage.buckets (id, name, public)
values ('fridge-scans', 'fridge-scans', true)
on conflict (id) do nothing;

create policy fridge_scans_storage_own on storage.objects for all to authenticated
  using (
    bucket_id = 'fridge-scans'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'fridge-scans'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Starter food catalog for autocomplete.
insert into public.food_items (name_en, name_ar, category) values
  ('Eggs', 'بيض', 'protein'),
  ('Chicken breast', 'صدر دجاج', 'protein'),
  ('Greek yogurt', 'زبادي يوناني', 'dairy'),
  ('Oats', 'شوفان', 'grain'),
  ('Rice', 'أرز', 'grain'),
  ('Lentils', 'عدس', 'legume'),
  ('Chickpeas', 'حمص', 'legume'),
  ('Tomatoes', 'طماطم', 'vegetable'),
  ('Cucumber', 'خيار', 'vegetable'),
  ('Spinach', 'سبانخ', 'vegetable'),
  ('Bell pepper', 'فلفل رومي', 'vegetable'),
  ('Onion', 'بصل', 'vegetable'),
  ('Garlic', 'ثوم', 'vegetable'),
  ('Olive oil', 'زيت زيتون', 'fat'),
  ('Avocado', 'أفocado', 'fat'),
  ('Banana', 'موز', 'fruit'),
  ('Apple', 'تفاح', 'fruit'),
  ('Milk', 'حليب', 'dairy'),
  ('Cheese', 'جبن', 'dairy'),
  ('Tuna', 'تونة', 'protein'),
  ('Salmon', 'سلmon', 'protein'),
  ('Beef', 'لحم بقر', 'protein'),
  ('Potato', 'بطاطس', 'vegetable'),
  ('Sweet potato', 'بطاطا حلوة', 'vegetable'),
  ('Broccoli', 'بروكلي', 'vegetable'),
  ('Carrot', 'جزر', 'vegetable'),
  ('Lemon', 'ليمون', 'fruit'),
  ('Parsley', 'بقدونس', 'herb'),
  ('Mint', 'نعناع', 'herb'),
  ('Whole wheat bread', 'خبز قمح كامل', 'grain')
on conflict do nothing;

-- Demo recipes (referenced by meal plan when no server plan exists).
insert into public.recipes (
  id, title_en, title_ar, prep_time_minutes, goal_tag, cuisine_tag, meal_type, dietary_tags, steps_en, steps_ar
) values
  ('11111111-1111-1111-1111-111111111101', 'Protein Oats Bowl', 'شوفان بالبروtein', 10, 'high_protein', 'international_healthy', 'breakfast', '{halal}', '{Mix oats with yogurt and top with banana.}', '{اخلط الشوفان مع الزبادي وزيّن بالموز.}'),
  ('11111111-1111-1111-1111-111111111102', 'Shakshuka Lite', 'شكشوكة خفيفة', 20, 'light_energy', 'levantine', 'breakfast', '{halal}', '{Simmer tomatoes with eggs and spices.}', '{اطبخ الطماطم مع البيض والبهارات.}'),
  ('11111111-1111-1111-1111-111111111201', 'Grilled Chicken Plate', 'طبق دجاج مشوي', 25, 'high_protein', 'international_healthy', 'lunch', '{halal,gluten_free}', '{Grill chicken with salad and olive oil.}', '{اشوي الدجاج مع سلطة وزيت زيتون.}'),
  ('11111111-1111-1111-1111-111111111202', 'Lentil Soup', 'شوربة عدس', 30, 'light_energy', 'egyptian', 'lunch', '{halal,vegan,vegetarian}', '{Simmer lentils with onion and cumin.}', '{اسلق العدس مع البصل والكمون.}'),
  ('11111111-1111-1111-1111-111111111301', 'Salmon & Greens', 'سلmon مع خضار', 20, 'high_protein', 'international_healthy', 'dinner', '{halal,gluten_free}', '{Pan-sear salmon with steamed broccoli.}', '{حمّر السلمon مع بروكلي على البخار.}'),
  ('11111111-1111-1111-1111-111111111302', 'Chickpea Salad', 'سلطة حمص', 15, 'quick_easy', 'levantine', 'dinner', '{halal,vegan,vegetarian}', '{Toss chickpeas with cucumber and lemon.}', '{اخلط الحمص مع الخيار والليمون.}'),
  ('11111111-1111-1111-1111-111111111401', 'Greek Yogurt & Fruit', 'زبادي وفاكهة', 5, 'quick_easy', 'international_healthy', 'snack', '{halal,vegetarian}', '{Top yogurt with apple slices.}', '{زيّن الزبادي بشرائح التفاح.}'),
  ('11111111-1111-1111-1111-111111111402', 'Hummus & Veggies', 'حummus وخضار', 8, 'light_energy', 'levantine', 'snack', '{halal,vegan,vegetarian}', '{Serve hummus with carrot sticks.}', '{قدّم الحummus مع أعواد الجزر.}')
on conflict (id) do nothing;
