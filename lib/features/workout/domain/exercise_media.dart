enum ExerciseMediaType { gif, lottie, video, placeholder }

enum ExerciseDifficulty { beginner, intermediate, advanced }

/// Maps exercise identifiers to offline Lottie media assets.
abstract final class ExerciseMediaResolver {
  static const lottieDir = 'assets/exercises/lottie/';

  static const _slugById = <String, String>{
    '33333333-3333-3333-3333-333333333102': 'squat',
    '33333333-3333-3333-3333-333333333208': 'deadlift',
    '33333333-3333-3333-3333-333333333701': 'bench_press',
    '33333333-3333-3333-3333-333333333206': 'overhead_press',
    '33333333-3333-3333-3333-333333333501': 'pullup',
    '33333333-3333-3333-3333-333333333205': 'row',
    '33333333-3333-3333-3333-333333333204': 'lunge',
    '33333333-3333-3333-3333-333333333101': 'pushup',
    '33333333-3333-3333-3333-333333333201': 'curl',
    '33333333-3333-3333-3333-333333333104': 'plank',
  };

  /// All compound / demo slugs resolve to Lottie JSON (web-friendly).
  static const _lottieSlugs = {
    'squat',
    'deadlift',
    'bench_press',
    'overhead_press',
    'pullup',
    'row',
    'lunge',
    'pushup',
    'push_up',
    'curl',
    'plank',
    'hip_thrust',
    'walking_lunge',
    'chin_up',
    'front_squat',
    'sumo_deadlift',
    'romanian_deadlift',
    'incline_bench',
    't_bar_row',
    'leg_press',
    'push_press',
    'farmer_walk',
  };

  static String slugForExerciseId(String exerciseId) {
    if (_slugById.containsKey(exerciseId)) {
      return _slugById[exerciseId]!;
    }
    return slugFromName(exerciseId);
  }

  static String slugFromName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '')
        .replaceAll('push_up', 'pushup');
  }

  static String normalizeSlug(String slug) {
    if (slug == 'push_up') return 'pushup';
    return slug;
  }

  static ExerciseMediaType mediaTypeForSlug(String slug) {
    final normalized = normalizeSlug(slug);
    if (_lottieSlugs.contains(normalized)) {
      return ExerciseMediaType.lottie;
    }
    return ExerciseMediaType.lottie;
  }

  static String assetPathForSlug(String slug, ExerciseMediaType type) {
    final normalized = normalizeSlug(slug);
    switch (type) {
      case ExerciseMediaType.lottie:
        return '$lottieDir$normalized.json';
      case ExerciseMediaType.video:
        return '$lottieDir$normalized.json';
      case ExerciseMediaType.gif:
      case ExerciseMediaType.placeholder:
        return '$lottieDir$normalized.json';
    }
  }

  static ({ExerciseMediaType type, String path}) resolve(String exerciseId) {
    final slug = normalizeSlug(slugForExerciseId(exerciseId));
    final type = mediaTypeForSlug(slug);
    return (type: type, path: assetPathForSlug(slug, type));
  }
}
