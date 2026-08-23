-- Seed catalog data + allow public (anon) read for offline/guest browsing.

drop policy if exists exercises_select_authenticated on public.exercises;
drop policy if exists food_items_select_authenticated on public.food_items;
drop policy if exists recipes_select_authenticated on public.recipes;
drop policy if exists exercises_select_public on public.exercises;
drop policy if exists food_items_select_public on public.food_items;
drop policy if exists recipes_select_public on public.recipes;

create policy exercises_select_public
  on public.exercises for select
  to anon, authenticated
  using (true);

create policy food_items_select_public
  on public.food_items for select
  to anon, authenticated
  using (true);

create policy recipes_select_public
  on public.recipes for select
  to anon, authenticated
  using (true);

-- Fill both legacy + new columns so seed works on merged schema.
insert into public.exercises (
  id, name, name_en, name_ar, target_muscle, target_muscle_ar,
  sets, reps, rest_seconds, video_url, type, environments, environment_tags, difficulty
) values
  ('22222222-2222-2222-2222-222222222101', 'Push-up', 'Push-up', 'ضغط', 'chest', 'صدر', 3, 12, 60, '', 'strength', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}', 'beginner'),
  ('22222222-2222-2222-2222-222222222102', 'Bodyweight Squat', 'Bodyweight Squat', 'قرفصاء', 'legs', 'أرجل', 3, 15, 60, '', 'strength', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', 'beginner'),
  ('22222222-2222-2222-2222-222222222103', 'Plank', 'Plank', 'بلانك', 'core', 'بطن', 3, 30, 45, '', 'strength', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}', 'beginner'),
  ('22222222-2222-2222-2222-222222222104', 'Dumbbell Row', 'Dumbbell Row', 'جدف دمبل', 'back', 'ظهر', 3, 10, 60, '', 'strength', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}', 'moderate'),
  ('22222222-2222-2222-2222-222222222105', 'Overhead Press', 'Overhead Press', 'ضغط كتف', 'shoulders', 'أكتاف', 3, 10, 75, '', 'strength', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}', 'moderate'),
  ('22222222-2222-2222-2222-222222222106', 'Lunges', 'Lunges', 'اندفاع', 'legs', 'أرجل', 3, 12, 60, '', 'strength', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}', 'beginner'),
  ('22222222-2222-2222-2222-222222222107', 'Glute Bridge', 'Glute Bridge', 'جسر المؤخرة', 'glutes', 'أرداف', 3, 15, 45, '', 'strength', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}', 'beginner'),
  ('22222222-2222-2222-2222-222222222108', 'Dead Bug', 'Dead Bug', 'الحشرة الميتة', 'core', 'بطن', 3, 10, 45, '', 'mobility', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}', 'beginner'),
  ('22222222-2222-2222-2222-222222222109', 'Shoulder Circles', 'Shoulder Circles', 'دوران الكتفين', 'shoulders', 'أكتاف', 2, 20, 30, '', 'mobility', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', 'beginner'),
  ('22222222-2222-2222-2222-222222222110', 'March in Place', 'March in Place', 'مشي في المكان', 'cardio', 'كارديو', 1, 60, 20, '', 'cardio', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}', 'beginner'),
  ('22222222-2222-2222-2222-222222222111', 'Hip Opener', 'Hip Opener', 'فتح الورك', 'hips', 'ورك', 2, 15, 30, '', 'mobility', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', 'beginner'),
  ('22222222-2222-2222-2222-222222222112', 'Ankle Circles', 'Ankle Circles', 'لف الكاحل', 'ankles', 'كاحل', 2, 20, 20, '', 'mobility', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}', 'beginner')
on conflict (id) do nothing;

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
  ('Olive oil', 'زيت زيتون', 'fat'),
  ('Banana', 'موز', 'fruit'),
  ('Apple', 'تفاح', 'fruit'),
  ('Tuna', 'تونة', 'protein'),
  ('Salmon', 'سلمون', 'protein'),
  ('Broccoli', 'بروكلي', 'vegetable'),
  ('Avocado', 'أفوكادو', 'fat'),
  ('White cheese', 'جبنة بيضا', 'dairy'),
  ('Peanut butter', 'زبدة فول سوداني', 'fat'),
  ('Mixed nuts', 'مكسرات مشكلة', 'snack')
on conflict do nothing;

insert into public.recipes (
  id, title_en, title_ar, prep_time_minutes, goal_tag, cuisine_tag, meal_type, dietary_tags, steps_en, steps_ar
) values
  ('11111111-1111-1111-1111-111111111101', 'Protein Oats Bowl', 'شوفان بالبروتين', 10, 'high_protein', 'international_healthy', 'breakfast', '{halal}', '{Mix oats with yogurt and top with banana.}', '{اخلط الشوفان مع الزبادي وزيّن بالموز.}'),
  ('11111111-1111-1111-1111-111111111102', 'Shakshuka Lite', 'شكشوكة خفيفة', 20, 'light_energy', 'levantine', 'breakfast', '{halal}', '{Simmer tomatoes with eggs and spices.}', '{اطبخ الطماطم مع البيض والبهارات.}'),
  ('11111111-1111-1111-1111-111111111103', 'Egg & Cheese Omelette', 'أومليت بيض وجبنة', 10, 'high_protein', 'international_healthy', 'breakfast', '{halal,vegetarian}', '{Whisk eggs, cook with cheese.}', '{اخفق البيض واطبخه مع الجبنة.}'),
  ('11111111-1111-1111-1111-111111111201', 'Grilled Chicken Plate', 'طبق دجاج مشوي', 25, 'high_protein', 'international_healthy', 'lunch', '{halal,gluten_free}', '{Grill chicken with salad and olive oil.}', '{اشوي الدجاج مع سلطة وزيت زيتون.}'),
  ('11111111-1111-1111-1111-111111111202', 'Lentil Soup', 'شوربة عدس', 30, 'light_energy', 'egyptian', 'lunch', '{halal,vegan,vegetarian}', '{Simmer lentils with onion and cumin.}', '{اسلق العدس مع البصل والكمون.}'),
  ('11111111-1111-1111-1111-111111111203', 'Grilled Fish & Rice', 'سمك مشوي + أرز بني', 30, 'high_protein', 'international_healthy', 'lunch', '{halal,gluten_free}', '{Grill fish and serve with brown rice.}', '{اشوي السمك وقدّمه مع أرز بني.}'),
  ('11111111-1111-1111-1111-111111111301', 'Salmon & Greens', 'سلمون مع خضار', 20, 'high_protein', 'international_healthy', 'dinner', '{halal,gluten_free}', '{Pan-sear salmon with steamed broccoli.}', '{حمّر السلمون مع بروكلي على البخار.}'),
  ('11111111-1111-1111-1111-111111111302', 'Chickpea Salad', 'سلطة حمص', 15, 'quick_easy', 'levantine', 'dinner', '{halal,vegan,vegetarian}', '{Toss chickpeas with cucumber and lemon.}', '{اخلط الحمص مع الخيار والليمون.}'),
  ('11111111-1111-1111-1111-111111111303', 'Tuna with Vegetables', 'تونة بالخضار', 10, 'high_protein', 'international_healthy', 'dinner', '{halal}', '{Mix tuna with chopped vegetables.}', '{اخلط التونة مع خضار مقطّعة.}'),
  ('11111111-1111-1111-1111-111111111401', 'Greek Yogurt & Fruit', 'زبادي وفاكهة', 5, 'quick_easy', 'international_healthy', 'snack', '{halal,vegetarian}', '{Top yogurt with apple slices.}', '{زيّن الزبادي بشرائح التفاح.}'),
  ('11111111-1111-1111-1111-111111111402', 'Hummus & Veggies', 'حمص وخضار', 8, 'light_energy', 'levantine', 'snack', '{halal,vegan,vegetarian}', '{Serve hummus with carrot sticks.}', '{قدّم الحمص مع أعواد الجزر.}'),
  ('11111111-1111-1111-1111-111111111403', 'Apple & Peanut Butter', 'تفاح + زبدة فول سوداني', 2, 'light_energy', 'international_healthy', 'snack', '{halal,vegetarian}', '{Slice apple and serve with peanut butter.}', '{قطّع التفاح وقدّمه مع زبدة فول سوداني.}')
on conflict (id) do nothing;
