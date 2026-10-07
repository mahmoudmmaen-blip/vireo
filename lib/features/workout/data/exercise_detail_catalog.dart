import 'package:vireo/data/demo/exercise_demo_catalog.dart';
import 'package:vireo/features/workout/domain/exercise_detail.dart';
import 'package:vireo/features/workout/domain/exercise_media.dart';

/// Offline catalog of 50+ exercises with bilingual coaching content.
abstract final class ExerciseDetailCatalog {
  static final List<ExerciseDetail> all = [
    ...ExerciseDemoCatalog.seedRows.map(_fromDemoRow),
    ..._extraCompoundLifts,
  ];

  static ExerciseDetail? byId(String id) {
    for (final e in all) {
      if (e.id == id) return e;
    }
    return null;
  }

  static ExerciseDetail _fromDemoRow(Map<String, dynamic> row) {
    final name = row['name'] as String;
    final muscle = row['target_muscle'] as String;
    final media = ExerciseMediaResolver.resolve(row['id'] as String);
    final diff = _difficulty(row['difficulty'] as String? ?? 'beginner');
    final compound = _isCompound(name, muscle);

    return ExerciseDetail(
      id: row['id'] as String,
      name: name,
      nameAr: row['name_ar'] as String? ?? name,
      muscleGroups: [_normalizeMuscle(muscle)],
      secondaryMuscles: _secondaryFor(muscle, name),
      instructions: _instructions(name, muscle),
      commonMistakes: _mistakes(name),
      tips: _tips(name, muscle),
      equipment: _equipment(name, row),
      difficulty: diff,
      mediaPath: media.path,
      mediaType: media.type,
      targetSets: row['sets'] as int? ?? 3,
      targetReps: row['reps'] as int? ?? 10,
      restSeconds: row['rest_seconds'] as int? ?? 60,
      isCompound: compound,
      vitalityBoost: compound,
    );
  }

  static final List<ExerciseDetail> _extraCompoundLifts = [
    _compound(
      id: 'vireo-ex-barbell-squat',
      name: 'Barbell Back Squat',
      nameAr: 'سكوات بالبار',
      muscles: ['quads', 'glutes'],
      secondary: ['core', 'hamstrings'],
      slug: 'squat',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-conventional-deadlift',
      name: 'Conventional Deadlift',
      nameAr: 'ديدليفت تقليدي',
      muscles: ['hamstrings', 'glutes'],
      secondary: ['back', 'core'],
      slug: 'deadlift',
      sets: 4,
      reps: 6,
      rest: 120,
    ),
    _compound(
      id: 'vireo-ex-barbell-ohp',
      name: 'Barbell Overhead Press',
      nameAr: 'ضغط كتف بالبار',
      muscles: ['shoulders'],
      secondary: ['triceps', 'core'],
      slug: 'overhead_press',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-barbell-row',
      name: 'Barbell Bent-over Row',
      nameAr: 'روينج بالبار',
      muscles: ['back'],
      secondary: ['biceps', 'core'],
      slug: 'row',
      sets: 4,
      reps: 10,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-romanian-deadlift',
      name: 'Romanian Deadlift',
      nameAr: 'ديدليفت روماني',
      muscles: ['hamstrings', 'glutes'],
      secondary: ['back'],
      slug: 'deadlift',
      sets: 3,
      reps: 10,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-incline-bench',
      name: 'Incline Bench Press',
      nameAr: 'بنش مائل',
      muscles: ['chest'],
      secondary: ['shoulders', 'triceps'],
      slug: 'bench_press',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-hip-thrust',
      name: 'Barbell Hip Thrust',
      nameAr: 'هيب ثرست',
      muscles: ['glutes'],
      secondary: ['hamstrings', 'core'],
      slug: 'squat',
      sets: 4,
      reps: 12,
      rest: 60,
    ),
    _compound(
      id: 'vireo-ex-front-squat',
      name: 'Front Squat',
      nameAr: 'سكوات أمامي',
      muscles: ['quads'],
      secondary: ['core', 'glutes'],
      slug: 'squat',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-chin-up',
      name: 'Chin-up',
      nameAr: 'عقلة قبضة',
      muscles: ['back', 'biceps'],
      secondary: ['core'],
      slug: 'pullup',
      sets: 3,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-walking-lunge',
      name: 'Walking Lunge',
      nameAr: 'لانج مشي',
      muscles: ['quads', 'glutes'],
      secondary: ['core'],
      slug: 'lunge',
      sets: 3,
      reps: 12,
      rest: 60,
    ),
    _compound(
      id: 'vireo-ex-farmer-walk',
      name: 'Farmer Walk',
      nameAr: 'مشي المزارع',
      muscles: ['core'],
      secondary: ['shoulders'],
      slug: 'row',
      sets: 3,
      reps: 40,
      rest: 60,
      diff: ExerciseDifficulty.intermediate,
    ),
    _compound(
      id: 'vireo-ex-t-bar-row',
      name: 'T-Bar Row',
      nameAr: 'رو T بار',
      muscles: ['back'],
      secondary: ['biceps'],
      slug: 'row',
      sets: 4,
      reps: 10,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-leg-press-compound',
      name: 'Leg Press (Compound)',
      nameAr: 'ليج برس مركب',
      muscles: ['quads', 'glutes'],
      secondary: ['hamstrings'],
      slug: 'squat',
      sets: 4,
      reps: 12,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-push-press',
      name: 'Push Press',
      nameAr: 'ضغط اندفاعي',
      muscles: ['shoulders'],
      secondary: ['triceps', 'quads'],
      slug: 'overhead_press',
      sets: 4,
      reps: 6,
      rest: 90,
      diff: ExerciseDifficulty.advanced,
    ),
    _compound(
      id: 'vireo-ex-sumo-deadlift',
      name: 'Sumo Deadlift',
      nameAr: 'ديدليفت سومو',
      muscles: ['glutes', 'quads'],
      secondary: ['back', 'hamstrings'],
      slug: 'deadlift',
      sets: 4,
      reps: 6,
      rest: 120,
      diff: ExerciseDifficulty.advanced,
    ),
  ];

  static ExerciseDetail _compound({
    required String id,
    required String name,
    required String nameAr,
    required List<String> muscles,
    required List<String> secondary,
    required String slug,
    required int sets,
    required int reps,
    required int rest,
    ExerciseDifficulty diff = ExerciseDifficulty.intermediate,
  }) {
    final mediaType = ExerciseMediaResolver.mediaTypeForSlug(slug);
    return ExerciseDetail(
      id: id,
      name: name,
      nameAr: nameAr,
      muscleGroups: muscles,
      secondaryMuscles: secondary,
      instructions: _instructions(name, muscles.first),
      commonMistakes: _mistakes(name),
      tips: _tips(name, muscles.first),
      equipment: const ['Barbell', 'Rack'],
      difficulty: diff,
      mediaPath: ExerciseMediaResolver.assetPathForSlug(slug, mediaType),
      mediaType: mediaType,
      targetSets: sets,
      targetReps: reps,
      restSeconds: rest,
      isCompound: true,
      vitalityBoost: true,
    );
  }

  static ExerciseDifficulty _difficulty(String raw) {
    return switch (raw) {
      'advanced' => ExerciseDifficulty.advanced,
      'moderate' || 'intermediate' => ExerciseDifficulty.intermediate,
      _ => ExerciseDifficulty.beginner,
    };
  }

  static String _normalizeMuscle(String muscle) {
    return switch (muscle) {
      'posterior_chain' => 'hamstrings',
      'legs' => 'quads',
      'full_body' => 'core',
      _ => muscle,
    };
  }

  static List<String> _secondaryFor(String muscle, String name) {
    final lower = name.toLowerCase();
    if (lower.contains('squat') || muscle == 'legs') {
      return const ['glutes', 'core'];
    }
    if (lower.contains('press') && muscle == 'chest') {
      return const ['shoulders', 'triceps'];
    }
    if (lower.contains('row') || muscle == 'back') {
      return const ['biceps', 'core'];
    }
    if (lower.contains('curl')) return const ['forearms'];
    if (muscle == 'core') return const ['hip_flexors'];
    return const [];
  }

  static bool _isCompound(String name, String muscle) {
    const compounds = [
      'squat',
      'deadlift',
      'press',
      'row',
      'pull',
      'lunge',
      'burpee',
      'thrust',
      'swing',
    ];
    final n = name.toLowerCase();
    return compounds.any(n.contains) || muscle == 'full_body';
  }

  static List<String> _equipment(String name, Map<String, dynamic> row) {
    final envs = (row['environments'] as List?)?.cast<String>() ?? [];
    if (envs.contains('home_no_equipment')) return const ['Bodyweight'];
    if (envs.contains('home_light_equipment')) {
      return const ['Dumbbells'];
    }
    if (name.toLowerCase().contains('barbell')) {
      return const ['Barbell', 'Rack'];
    }
    return const ['Gym machine'];
  }

  static List<String> _instructions(String name, String muscle) {
    return [
      'Warm up 5 minutes and activate $muscle with light reps.',
      'Set a stable base — brace your core before each rep of $name.',
      'Move through full range with control; avoid bouncing at the bottom.',
      'Exhale on the effort phase; inhale on the return.',
      'Rest the prescribed time and maintain form on every set.',
    ];
  }

  static List<String> _mistakes(String name) {
    return [
      'Using momentum instead of muscle control during $name.',
      'Letting your lower back round or arch excessively.',
      'Holding your breath through the entire rep — breathe rhythmically.',
    ];
  }

  static List<String> _tips(String name, String muscle) {
    return [
      'Focus on mind-muscle connection in the $muscle.',
      'Increase load only when you can complete all reps with perfect form.',
      'Pair $name with adequate protein to support recovery.',
    ];
  }
}
