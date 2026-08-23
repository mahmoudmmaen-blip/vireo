import 'package:vireo/data/models/exercise.dart';

/// Local catalog of 20+ exercises for client-side Supabase seeding and offline fallback.
abstract final class ExerciseDemoCatalog {
  static final List<Map<String, dynamic>> seedRows = [
    // Home — no equipment (8)
    _row('33333333-3333-3333-3333-333333333101', 'Push-up', 'ضغط', 'chest', 'صدر', 3, 12, 45, 'strength', 'beginner', ['home_no_equipment', 'home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333102', 'Bodyweight Squat', 'سكوات', 'legs', 'أرجل', 3, 15, 45, 'strength', 'beginner', ['home_no_equipment', 'home_light_equipment', 'gym_full', 'walking_only']),
    _row('33333333-3333-3333-3333-333333333103', 'Burpee', 'برنس', 'full_body', 'جسم كامل', 3, 10, 60, 'strength', 'moderate', ['home_no_equipment', 'home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333104', 'Plank', 'بلانك', 'core', 'بطن', 3, 45, 30, 'strength', 'beginner', ['home_no_equipment', 'home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333105', 'Mountain Climber', 'ماونتن كلايمبر', 'core', 'بطن', 3, 20, 30, 'cardio', 'moderate', ['home_no_equipment', 'home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333106', 'Jumping Jack', 'جامبينج جاك', 'cardio', 'كارديو', 3, 30, 20, 'cardio', 'beginner', ['home_no_equipment', 'walking_only', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333107', 'High Knees', 'هاي ني', 'cardio', 'كارديو', 3, 30, 20, 'cardio', 'beginner', ['home_no_equipment', 'walking_only', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333108', 'Triceps Dips', 'ترايسبس ديبس', 'triceps', 'ترايسبس', 3, 12, 45, 'strength', 'moderate', ['home_no_equipment', 'home_light_equipment', 'gym_full']),
    // Home — light equipment (8)
    _row('33333333-3333-3333-3333-333333333201', 'Dumbbell Curl', 'دمبل كيرل', 'biceps', 'بايسبس', 3, 12, 60, 'strength', 'beginner', ['home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333202', 'Dumbbell Press', 'دمبل برس', 'chest', 'صدر', 3, 10, 75, 'strength', 'moderate', ['home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333203', 'Dumbbell Squat', 'دمبل سكوات', 'legs', 'أرجل', 3, 12, 60, 'strength', 'beginner', ['home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333204', 'Lunge', 'لانج', 'legs', 'أرجل', 3, 12, 60, 'strength', 'beginner', ['home_light_equipment', 'gym_full', 'home_no_equipment']),
    _row('33333333-3333-3333-3333-333333333205', 'Dumbbell Row', 'روينج', 'back', 'ظهر', 3, 10, 60, 'strength', 'moderate', ['home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333206', 'Shoulder Press', 'شولدر برس', 'shoulders', 'أكتاف', 3, 10, 75, 'strength', 'moderate', ['home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333207', 'Band Lat Pulldown', 'لات بولداون بأستك', 'back', 'ظهر', 3, 12, 60, 'strength', 'beginner', ['home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333208', 'Dumbbell Deadlift', 'ديدليفت دمبل', 'posterior_chain', 'سلسلة خلفية', 3, 10, 75, 'strength', 'moderate', ['home_light_equipment', 'gym_full']),
    // Walking / cardio (4)
    _row('33333333-3333-3333-3333-333333333301', 'Brisk Walk', 'مشي سريع', 'cardio', 'كارديو', 1, 20, 0, 'cardio', 'beginner', ['walking_only', 'home_no_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333302', 'March in Place', 'مشي في المكان', 'cardio', 'كارديو', 1, 60, 15, 'cardio', 'beginner', ['walking_only', 'home_no_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333303', 'Step-ups', 'صعود درج', 'legs', 'أرجل', 3, 15, 45, 'cardio', 'beginner', ['walking_only', 'home_no_equipment', 'home_light_equipment']),
    _row('33333333-3333-3333-3333-333333333304', 'Shadow Boxing', 'ملاكمة ظل', 'cardio', 'كارديو', 3, 45, 30, 'cardio', 'moderate', ['home_no_equipment', 'home_light_equipment', 'walking_only']),
    // HIIT Cardio (6)
    _row('33333333-3333-3333-3333-333333333401', 'Sprint Intervals', 'سبرنت إنترفال', 'cardio', 'كارديو', 6, 20, 40, 'cardio', 'advanced', ['home_no_equipment', 'gym_full', 'walking_only']),
    _row('33333333-3333-3333-3333-333333333402', 'Jump Rope', 'نط الحبل', 'cardio', 'كارديو', 4, 45, 30, 'cardio', 'moderate', ['home_light_equipment', 'gym_full', 'home_no_equipment']),
    _row('33333333-3333-3333-3333-333333333403', 'Box Jump', 'بوكس جامب', 'legs', 'أرجل', 4, 10, 45, 'cardio', 'advanced', ['gym_full', 'home_light_equipment']),
    _row('33333333-3333-3333-3333-333333333404', 'Battle Ropes', 'باتل روب', 'full_body', 'جسم كامل', 4, 30, 45, 'cardio', 'advanced', ['gym_full']),
    _row('33333333-3333-3333-3333-333333333405', 'Kettlebell Swing', 'كيتل بيل سوينج', 'posterior_chain', 'سلسلة خلفية', 4, 15, 45, 'strength', 'moderate', ['gym_full', 'home_light_equipment']),
    _row('33333333-3333-3333-3333-333333333406', 'Skater Hops', 'سكيت هوب', 'legs', 'أرجل', 3, 20, 30, 'cardio', 'moderate', ['home_no_equipment', 'gym_full']),
    // Calisthenics (6)
    _row('33333333-3333-3333-3333-333333333501', 'Pull-up', 'عقلة', 'back', 'ظهر', 3, 8, 90, 'strength', 'advanced', ['gym_full', 'home_light_equipment']),
    _row('33333333-3333-3333-3333-333333333502', 'Pike Push-up', 'بايك بوش أب', 'shoulders', 'أكتاف', 3, 10, 60, 'strength', 'moderate', ['home_no_equipment', 'home_light_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333503', 'Pistol Squat Assist', 'بستول سكوات', 'legs', 'أرجل', 3, 6, 75, 'strength', 'advanced', ['home_no_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333504', 'Hanging Knee Raise', 'رفع ركب معلق', 'core', 'بطن', 3, 12, 45, 'strength', 'moderate', ['gym_full', 'home_light_equipment']),
    _row('33333333-3333-3333-3333-333333333505', 'Diamond Push-up', 'دايموند بوش أب', 'triceps', 'ترايسبس', 3, 12, 45, 'strength', 'moderate', ['home_no_equipment', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333506', 'Inverted Row', 'رو صف معكوس', 'back', 'ظهر', 3, 10, 60, 'strength', 'beginner', ['home_light_equipment', 'gym_full']),
    // Low Impact / Mobility (6)
    _row('33333333-3333-3333-3333-333333333601', 'Cat-Cow Stretch', 'قطة-بقرة', 'core', 'بطن', 2, 10, 15, 'mobility', 'beginner', ['home_no_equipment', 'walking_only', 'gym_full', 'home_light_equipment']),
    _row('33333333-3333-3333-3333-333333333602', 'World\'s Greatest Stretch', 'أكبر تمدد', 'full_body', 'جسم كامل', 2, 8, 20, 'mobility', 'beginner', ['home_no_equipment', 'gym_full', 'walking_only']),
    _row('33333333-3333-3333-3333-333333333603', 'Hip Opener', 'فتح ورك', 'legs', 'أرجل', 2, 30, 15, 'mobility', 'beginner', ['home_no_equipment', 'walking_only', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333604', 'Thoracic Rotation', 'دوران صدري', 'back', 'ظهر', 2, 10, 15, 'mobility', 'beginner', ['home_no_equipment', 'gym_full', 'walking_only']),
    _row('33333333-3333-3333-3333-333333333605', 'Ankle Rocks', 'تحريك كاحل', 'legs', 'أرجل', 2, 12, 10, 'mobility', 'beginner', ['home_no_equipment', 'walking_only', 'gym_full']),
    _row('33333333-3333-3333-3333-333333333606', 'Child\'s Pose Flow', 'وضعية الطفل', 'full_body', 'جسم كامل', 2, 45, 10, 'mobility', 'beginner', ['home_no_equipment', 'walking_only', 'gym_full']),
    // Gym machines / heavy (4)
    _row('33333333-3333-3333-3333-333333333701', 'Barbell Bench Press', 'بنش بار', 'chest', 'صدر', 4, 8, 90, 'strength', 'moderate', ['gym_full']),
    _row('33333333-3333-3333-3333-333333333702', 'Lat Pulldown', 'لات بولداون', 'back', 'ظهر', 3, 12, 60, 'strength', 'beginner', ['gym_full']),
    _row('33333333-3333-3333-3333-333333333703', 'Leg Press', 'ليج برس', 'legs', 'أرجل', 4, 12, 75, 'strength', 'beginner', ['gym_full']),
    _row('33333333-3333-3333-3333-333333333704', 'Cable Lateral Raise', 'رفرفة كابل', 'shoulders', 'أكتاف', 3, 15, 45, 'strength', 'beginner', ['gym_full']),
  ];

  static Map<String, dynamic> _row(
    String id,
    String nameEn,
    String nameAr,
    String muscle,
    String muscleAr,
    int sets,
    int reps,
    int rest,
    String type,
    String difficulty,
    List<String> envTags,
  ) =>
      {
        'id': id,
        'name': nameEn,
        'name_en': nameEn,
        'name_ar': nameAr,
        'target_muscle': muscle,
        'target_muscle_ar': muscleAr,
        'sets': sets,
        'reps': reps,
        'rest_seconds': rest,
        'video_url': '',
        'type': type,
        'difficulty': difficulty,
        'environments': envTags,
        'environment_tags': envTags,
      };

  static List<Exercise> asExercises() {
    return seedRows
        .map((row) => Exercise.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }
}
