-- Server-side seed for the 42-exercise catalog (replaces client-side seeding).
-- Clients only have SELECT access on public.exercises via RLS.

alter table public.exercises
  add column if not exists name text,
  add column if not exists name_en text,
  add column if not exists name_ar text,
  add column if not exists target_muscle text,
  add column if not exists target_muscle_ar text,
  add column if not exists sets int not null default 3,
  add column if not exists reps int not null default 10,
  add column if not exists rest_seconds int not null default 60,
  add column if not exists video_url text not null default '',
  add column if not exists type text not null default 'strength',
  add column if not exists difficulty text not null default 'moderate',
  add column if not exists environments text[] not null default '{}',
  add column if not exists environment_tags text[] not null default '{}';

alter table public.exercises enable row level security;

drop policy if exists exercises_select_public on public.exercises;
create policy exercises_select_public
  on public.exercises for select
  to anon, authenticated
  using (true);

insert into public.exercises (
  id, name, name_en, name_ar, target_muscle, target_muscle_ar,
  sets, reps, rest_seconds, video_url, type, difficulty, environments, environment_tags
) values
  -- Home — no equipment (8)
  ('33333333-3333-3333-3333-333333333101', 'Push-up', 'Push-up', 'ضغط', 'chest', 'صدر', 3, 12, 45, '', 'strength', 'beginner', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333102', 'Bodyweight Squat', 'Bodyweight Squat', 'سكوات', 'legs', 'أرجل', 3, 15, 45, '', 'strength', 'beginner', '{home_no_equipment,home_light_equipment,gym_full,walking_only}', '{home_no_equipment,home_light_equipment,gym_full,walking_only}'),
  ('33333333-3333-3333-3333-333333333103', 'Burpee', 'Burpee', 'برنس', 'full_body', 'جسم كامل', 3, 10, 60, '', 'strength', 'moderate', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333104', 'Plank', 'Plank', 'بلانك', 'core', 'بطن', 3, 45, 30, '', 'strength', 'beginner', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333105', 'Mountain Climber', 'Mountain Climber', 'ماونتن كلايمبر', 'core', 'بطن', 3, 20, 30, '', 'cardio', 'moderate', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333106', 'Jumping Jack', 'Jumping Jack', 'جامبينج جاك', 'cardio', 'كارديو', 3, 30, 20, '', 'cardio', 'beginner', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}'),
  ('33333333-3333-3333-3333-333333333107', 'High Knees', 'High Knees', 'هاي ني', 'cardio', 'كارديو', 3, 30, 20, '', 'cardio', 'beginner', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}'),
  ('33333333-3333-3333-3333-333333333108', 'Triceps Dips', 'Triceps Dips', 'ترايسبس ديبس', 'triceps', 'ترايسبس', 3, 12, 45, '', 'strength', 'moderate', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}'),
  -- Home — light equipment (8)
  ('33333333-3333-3333-3333-333333333201', 'Dumbbell Curl', 'Dumbbell Curl', 'دمبل كيرل', 'biceps', 'بايسبس', 3, 12, 60, '', 'strength', 'beginner', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333202', 'Dumbbell Press', 'Dumbbell Press', 'دمبل برس', 'chest', 'صدر', 3, 10, 75, '', 'strength', 'moderate', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333203', 'Dumbbell Squat', 'Dumbbell Squat', 'دمبل سكوات', 'legs', 'أرجل', 3, 12, 60, '', 'strength', 'beginner', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333204', 'Lunge', 'Lunge', 'لانج', 'legs', 'أرجل', 3, 12, 60, '', 'strength', 'beginner', '{home_light_equipment,gym_full,home_no_equipment}', '{home_light_equipment,gym_full,home_no_equipment}'),
  ('33333333-3333-3333-3333-333333333205', 'Dumbbell Row', 'Dumbbell Row', 'روينج', 'back', 'ظهر', 3, 10, 60, '', 'strength', 'moderate', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333206', 'Shoulder Press', 'Shoulder Press', 'شولدر برس', 'shoulders', 'أكتاف', 3, 10, 75, '', 'strength', 'moderate', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333207', 'Band Lat Pulldown', 'Band Lat Pulldown', 'لات بولداون بأستك', 'back', 'ظهر', 3, 12, 60, '', 'strength', 'beginner', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333208', 'Dumbbell Deadlift', 'Dumbbell Deadlift', 'ديدليفت دمبل', 'posterior_chain', 'سلسلة خلفية', 3, 10, 75, '', 'strength', 'moderate', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  -- Walking / cardio (4)
  ('33333333-3333-3333-3333-333333333301', 'Brisk Walk', 'Brisk Walk', 'مشي سريع', 'cardio', 'كارديو', 1, 20, 0, '', 'cardio', 'beginner', '{walking_only,home_no_equipment,gym_full}', '{walking_only,home_no_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333302', 'March in Place', 'March in Place', 'مشي في المكان', 'cardio', 'كارديو', 1, 60, 15, '', 'cardio', 'beginner', '{walking_only,home_no_equipment,gym_full}', '{walking_only,home_no_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333303', 'Step-ups', 'Step-ups', 'صعود درج', 'legs', 'أرجل', 3, 15, 45, '', 'cardio', 'beginner', '{walking_only,home_no_equipment,home_light_equipment}', '{walking_only,home_no_equipment,home_light_equipment}'),
  ('33333333-3333-3333-3333-333333333304', 'Shadow Boxing', 'Shadow Boxing', 'ملاكمة ظل', 'cardio', 'كارديو', 3, 45, 30, '', 'cardio', 'moderate', '{home_no_equipment,home_light_equipment,walking_only}', '{home_no_equipment,home_light_equipment,walking_only}'),
  -- HIIT Cardio (6)
  ('33333333-3333-3333-3333-333333333401', 'Sprint Intervals', 'Sprint Intervals', 'سبرنت إنترفال', 'cardio', 'كارديو', 6, 20, 40, '', 'cardio', 'advanced', '{home_no_equipment,gym_full,walking_only}', '{home_no_equipment,gym_full,walking_only}'),
  ('33333333-3333-3333-3333-333333333402', 'Jump Rope', 'Jump Rope', 'نط الحبل', 'cardio', 'كارديو', 4, 45, 30, '', 'cardio', 'moderate', '{home_light_equipment,gym_full,home_no_equipment}', '{home_light_equipment,gym_full,home_no_equipment}'),
  ('33333333-3333-3333-3333-333333333403', 'Box Jump', 'Box Jump', 'بوكس جامب', 'legs', 'أرجل', 4, 10, 45, '', 'cardio', 'advanced', '{gym_full,home_light_equipment}', '{gym_full,home_light_equipment}'),
  ('33333333-3333-3333-3333-333333333404', 'Battle Ropes', 'Battle Ropes', 'باتل روب', 'full_body', 'جسم كامل', 4, 30, 45, '', 'cardio', 'advanced', '{gym_full}', '{gym_full}'),
  ('33333333-3333-3333-3333-333333333405', 'Kettlebell Swing', 'Kettlebell Swing', 'كيتل بيل سوينج', 'posterior_chain', 'سلسلة خلفية', 4, 15, 45, '', 'strength', 'moderate', '{gym_full,home_light_equipment}', '{gym_full,home_light_equipment}'),
  ('33333333-3333-3333-3333-333333333406', 'Skater Hops', 'Skater Hops', 'سكيت هوب', 'legs', 'أرجل', 3, 20, 30, '', 'cardio', 'moderate', '{home_no_equipment,gym_full}', '{home_no_equipment,gym_full}'),
  -- Calisthenics (6)
  ('33333333-3333-3333-3333-333333333501', 'Pull-up', 'Pull-up', 'عقلة', 'back', 'ظهر', 3, 8, 90, '', 'strength', 'advanced', '{gym_full,home_light_equipment}', '{gym_full,home_light_equipment}'),
  ('33333333-3333-3333-3333-333333333502', 'Pike Push-up', 'Pike Push-up', 'بايك بوش أب', 'shoulders', 'أكتاف', 3, 10, 60, '', 'strength', 'moderate', '{home_no_equipment,home_light_equipment,gym_full}', '{home_no_equipment,home_light_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333503', 'Pistol Squat Assist', 'Pistol Squat Assist', 'بستول سكوات', 'legs', 'أرجل', 3, 6, 75, '', 'strength', 'advanced', '{home_no_equipment,gym_full}', '{home_no_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333504', 'Hanging Knee Raise', 'Hanging Knee Raise', 'رفع ركب معلق', 'core', 'بطن', 3, 12, 45, '', 'strength', 'moderate', '{gym_full,home_light_equipment}', '{gym_full,home_light_equipment}'),
  ('33333333-3333-3333-3333-333333333505', 'Diamond Push-up', 'Diamond Push-up', 'دايموند بوش أب', 'triceps', 'ترايسبس', 3, 12, 45, '', 'strength', 'moderate', '{home_no_equipment,gym_full}', '{home_no_equipment,gym_full}'),
  ('33333333-3333-3333-3333-333333333506', 'Inverted Row', 'Inverted Row', 'رو صف معكوس', 'back', 'ظهر', 3, 10, 60, '', 'strength', 'beginner', '{home_light_equipment,gym_full}', '{home_light_equipment,gym_full}'),
  -- Low Impact / Mobility (6)
  ('33333333-3333-3333-3333-333333333601', 'Cat-Cow Stretch', 'Cat-Cow Stretch', 'قطة-بقرة', 'core', 'بطن', 2, 10, 15, '', 'mobility', 'beginner', '{home_no_equipment,walking_only,gym_full,home_light_equipment}', '{home_no_equipment,walking_only,gym_full,home_light_equipment}'),
  ('33333333-3333-3333-3333-333333333602', 'World''s Greatest Stretch', 'World''s Greatest Stretch', 'أكبر تمدد', 'full_body', 'جسم كامل', 2, 8, 20, '', 'mobility', 'beginner', '{home_no_equipment,gym_full,walking_only}', '{home_no_equipment,gym_full,walking_only}'),
  ('33333333-3333-3333-3333-333333333603', 'Hip Opener', 'Hip Opener', 'فتح ورك', 'legs', 'أرجل', 2, 30, 15, '', 'mobility', 'beginner', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}'),
  ('33333333-3333-3333-3333-333333333604', 'Thoracic Rotation', 'Thoracic Rotation', 'دوران صدري', 'back', 'ظهر', 2, 10, 15, '', 'mobility', 'beginner', '{home_no_equipment,gym_full,walking_only}', '{home_no_equipment,gym_full,walking_only}'),
  ('33333333-3333-3333-3333-333333333605', 'Ankle Rocks', 'Ankle Rocks', 'تحريك كاحل', 'legs', 'أرجل', 2, 12, 10, '', 'mobility', 'beginner', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}'),
  ('33333333-3333-3333-3333-333333333606', 'Child''s Pose Flow', 'Child''s Pose Flow', 'وضعية الطفل', 'full_body', 'جسم كامل', 2, 45, 10, '', 'mobility', 'beginner', '{home_no_equipment,walking_only,gym_full}', '{home_no_equipment,walking_only,gym_full}'),
  -- Gym machines / heavy (4)
  ('33333333-3333-3333-3333-333333333701', 'Barbell Bench Press', 'Barbell Bench Press', 'بنش بار', 'chest', 'صدر', 4, 8, 90, '', 'strength', 'moderate', '{gym_full}', '{gym_full}'),
  ('33333333-3333-3333-3333-333333333702', 'Lat Pulldown', 'Lat Pulldown', 'لات بولداون', 'back', 'ظهر', 3, 12, 60, '', 'strength', 'beginner', '{gym_full}', '{gym_full}'),
  ('33333333-3333-3333-3333-333333333703', 'Leg Press', 'Leg Press', 'ليج برس', 'legs', 'أرجل', 4, 12, 75, '', 'strength', 'beginner', '{gym_full}', '{gym_full}'),
  ('33333333-3333-3333-3333-333333333704', 'Cable Lateral Raise', 'Cable Lateral Raise', 'رفرفة كابل', 'shoulders', 'أكتاف', 3, 15, 45, '', 'strength', 'beginner', '{gym_full}', '{gym_full}')
on conflict (id) do nothing;
