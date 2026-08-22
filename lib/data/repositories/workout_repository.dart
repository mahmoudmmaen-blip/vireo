import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/models/user_profile.dart';
import 'package:vireo/data/models/workout_session.dart';

class ExerciseRepository {
  const ExerciseRepository();

  static const _alternativesCachePrefix = 'exercise_alternatives_';

  Future<List<Exercise>> fetchAlternatives({
    required String targetMuscle,
    required TrainingEnvironment environment,
    required String excludeId,
  }) async {
    try {
      if (SupabaseService.isInitialized) {
        final rows = await SupabaseService.client
            .from('exercises')
            .select()
            .eq('target_muscle', targetMuscle)
            .contains('environments', [environment.value])
            .neq('id', excludeId);

        final exercises = (rows as List<dynamic>)
            .map((row) => Exercise.fromJson(Map<String, dynamic>.from(row)))
            .toList();

        await HiveService.cacheBox.put(
          '$_alternativesCachePrefix$targetMuscle',
          rows,
        );
        return exercises;
      }
    } catch (_) {
      // Fall through to cached / demo data.
    }

    final cached = HiveService.cacheBox.get(
      '$_alternativesCachePrefix$targetMuscle',
    );
    if (cached is List) {
      return cached
          .map((row) => Exercise.fromJson(Map<String, dynamic>.from(row)))
          .where((e) => e.id != excludeId && e.matchesEnvironment(environment))
          .toList();
    }

    return WorkoutSession.demo.exercises
        .where(
          (e) =>
              e.targetMuscle == targetMuscle &&
              e.id != excludeId &&
              e.matchesEnvironment(environment),
        )
        .toList();
  }
}

class WorkoutRepository {
  const WorkoutRepository();

  Future<WorkoutSession> fetchTodaySession() async {
    try {
      if (SupabaseService.isInitialized) {
        final row = await SupabaseService.client
            .from('workout_sessions')
            .select('*, exercises(*)')
            .order('scheduled_date', ascending: false)
            .limit(1)
            .maybeSingle();

        if (row != null) {
          final main = (row['exercises'] as List<dynamic>? ?? [])
              .map((e) => Exercise.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          return WorkoutSession(
            id: row['id'] as String,
            warmUp: WorkoutSession.demo.warmUp,
            exercises: main,
            coolDown: WorkoutSession.demo.coolDown,
          );
        }
      }
    } catch (_) {
      rethrow;
    }
    return WorkoutSession.demo;
  }

  Future<void> saveWorkoutFeedback({
    required String sessionId,
    required WorkoutDifficultyFeedback feedback,
  }) async {
    try {
      if (!SupabaseService.isInitialized) {
        await HiveService.cacheBox.put('pending_feedback_$sessionId', {
          'session_id': sessionId,
          'feedback': feedback.value,
        });
        return;
      }

      final userId = SupabaseService.auth.currentUser?.id;
      await SupabaseService.client.from('workout_checkins').insert({
        'session_id': sessionId,
        'user_id': userId,
        'feedback': feedback.value,
      });
    } catch (_) {
      rethrow;
    }
  }
}

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => const ExerciseRepository(),
);

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => const WorkoutRepository(),
);

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  try {
    if (SupabaseService.isInitialized) {
      final userId = SupabaseService.auth.currentUser?.id;
      if (userId != null) {
        final row = await SupabaseService.client
            .from('users')
            .select('id, medical_flag, training_environment')
            .eq('id', userId)
            .maybeSingle();
        if (row != null) {
          return UserProfile.fromJson(Map<String, dynamic>.from(row));
        }
      }
    }
  } catch (_) {
    // Fall through to cached / guest profile.
  }

  final guestRow = HiveService.cacheBox.get('guest_profile');
  if (guestRow is Map) {
    return UserProfile.fromJson(Map<String, dynamic>.from(guestRow));
  }

  return UserProfile.demo;
});

final todayWorkoutProvider = FutureProvider<WorkoutSession>((ref) async {
  return ref.read(workoutRepositoryProvider).fetchTodaySession();
});
