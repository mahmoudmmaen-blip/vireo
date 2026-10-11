import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/demo/exercise_demo_catalog.dart';
import 'package:vireo/data/models/exercise.dart';

/// Read-only loader for the shared exercise catalog.
/// Clients must never write to global catalog tables; when the remote table is
/// empty or unreachable, the app falls back to the bundled local exercises.
abstract final class CatalogSeedService {
  static const exercisesCacheKey = 'exercises_catalog';

  static Future<void> seedIfNeeded() async {
    await loadExercises();
  }

  static Future<List<Exercise>> loadExercises() async {
    if (SupabaseService.isInitialized) {
      try {
        final rows = await SupabaseService.client.from('exercises').select();
        final exercises = (rows as List<dynamic>)
            .map(
              (row) => Exercise.fromJson(
                Map<String, dynamic>.from(row as Map),
              ),
            )
            .toList();
        if (exercises.isNotEmpty) {
          if (HiveService.isInitialized) {
            await HiveService.cacheBox.put(exercisesCacheKey, rows);
          }
          return exercises;
        }
        return ExerciseDemoCatalog.asExercises();
      } catch (_) {
        // Silent fallback when Supabase is unreachable.
      }
    }

    if (HiveService.isInitialized) {
      final cached = HiveService.cacheBox.get(exercisesCacheKey);
      if (cached is List && cached.isNotEmpty) {
        return cached
            .map(
              (row) => Exercise.fromJson(
                Map<String, dynamic>.from(row as Map),
              ),
            )
            .toList();
      }
    }

    return ExerciseDemoCatalog.asExercises();
  }
}
