import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/utils/program_generator.dart';
import 'package:vireo/data/demo/exercise_demo_catalog.dart';
import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/models/user_profile.dart';
import 'package:vireo/data/models/workout_session.dart';

class ExerciseRepository {
  const ExerciseRepository();

  static const _alternativesCachePrefix = 'exercise_alternatives_';
  static const _exercisesCacheKey = 'exercises_catalog';

  Future<List<Exercise>> fetchAllExercises() async {
    try {
      if (SupabaseService.isInitialized) {
        final rows = await SupabaseService.client.from('exercises').select();
        final exercises = (rows as List<dynamic>)
            .map((row) => Exercise.fromJson(Map<String, dynamic>.from(row)))
            .toList();
        if (exercises.isNotEmpty) {
          await HiveService.cacheBox.put(_exercisesCacheKey, rows);
          return exercises;
        }
      }
    } catch (_) {
      // Fall through to cached / demo data.
    }

    final cached = HiveService.cacheBox.get(_exercisesCacheKey);
    if (cached is List && cached.isNotEmpty) {
      return cached
          .map((row) => Exercise.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    }

    return ExerciseDemoCatalog.asExercises();
  }

  Future<List<Exercise>> fetchAlternatives({
    required String targetMuscle,
    required TrainingEnvironment environment,
    required String excludeId,
  }) async {
    try {
      if (SupabaseService.isInitialized) {
        List<dynamic> rows;
        try {
          rows = await SupabaseService.client
              .from('exercises')
              .select()
              .eq('target_muscle', targetMuscle)
              .contains('environment_tags', [environment.value])
              .neq('id', excludeId);
        } catch (_) {
          rows = await SupabaseService.client
              .from('exercises')
              .select()
              .eq('target_muscle', targetMuscle)
              .contains('environments', [environment.value])
              .neq('id', excludeId);
        }

        final exercises = rows
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

    return ExerciseDemoCatalog.asExercises()
        .where(
          (e) =>
              e.id != excludeId &&
              e.matchesEnvironment(environment) &&
              (e.targetMuscle == targetMuscle ||
                  e.type == ExerciseType.mobility ||
                  e.type == ExerciseType.cardio),
        )
        .take(12)
        .toList();
  }

  /// Alternatives for warm-up / mobility phase.
  Future<List<Exercise>> fetchWarmUpAlternatives({
    required TrainingEnvironment environment,
    required String excludeId,
  }) async {
    final all = await fetchAllExercises();
    return all
        .where(
          (e) =>
              e.id != excludeId &&
              e.matchesEnvironment(environment) &&
              (e.type == ExerciseType.mobility || e.type == ExerciseType.cardio),
        )
        .take(10)
        .toList();
  }
}

class WorkoutRepository {
  const WorkoutRepository();

  static const _programStartKey = 'program_start_date';

  Future<WorkoutSession> fetchTodaySession({
    required FitnessGoal goal,
    required TrainingEnvironment environment,
    DateTime? programStart,
  }) async {
    try {
      final pool = await const ExerciseRepository().fetchAllExercises();
      final dayIndex = ProgramGenerator.programDayFromStart(programStart) - 1;

      final main = ProgramGenerator.buildTodayExercises(
        goal: goal,
        environment: environment,
        pool: pool,
        dayIndex: dayIndex,
      );

      if (main.isNotEmpty) {
        return WorkoutSession(
          id: 'generated-${DateTime.now().toIso8601String()}',
          warmUp: WorkoutSession.demo.warmUp,
          exercises: main,
          coolDown: WorkoutSession.demo.coolDown,
        );
      }

      if (SupabaseService.isInitialized) {
        final row = await SupabaseService.client
            .from('workout_sessions')
            .select('*, exercises(*)')
            .order('scheduled_date', ascending: false)
            .limit(1)
            .maybeSingle();

        if (row != null) {
          final fromDb = (row['exercises'] as List<dynamic>? ?? [])
              .map((e) => Exercise.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          if (fromDb.isNotEmpty) {
            return WorkoutSession(
              id: row['id'] as String,
              warmUp: WorkoutSession.demo.warmUp,
              exercises: fromDb,
              coolDown: WorkoutSession.demo.coolDown,
            );
          }
        }
      }
    } catch (_) {
      // Fall through to demo session.
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

  static DateTime? programStartFromHive() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(_programStartKey);
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  static Future<void> saveProgramStart(DateTime date) async {
    await HiveService.settingsBox.put(
      _programStartKey,
      date.toUtc().toIso8601String(),
    );
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

/// Reads onboarding goal/environment from local guest profile or defaults.
final workoutProfileProvider = Provider<({FitnessGoal goal, TrainingEnvironment env})>((ref) {
  final guestRow = HiveService.cacheBox.get('guest_profile');
  if (guestRow is Map) {
    final map = Map<String, dynamic>.from(guestRow);
    return (
      goal: FitnessGoal.fromValue(map['goal'] as String? ?? 'general_vitality'),
      env: TrainingEnvironment.fromValue(
        map['training_environment'] as String? ?? 'home_no_equipment',
      ),
    );
  }
  return (
    goal: FitnessGoal.generalVitality,
    env: TrainingEnvironment.homeNoEquipment,
  );
});

final todayWorkoutProvider = FutureProvider<WorkoutSession>((ref) async {
  final profile = ref.watch(workoutProfileProvider);
  final start = WorkoutRepository.programStartFromHive();
  return ref.read(workoutRepositoryProvider).fetchTodaySession(
        goal: profile.goal,
        environment: profile.env,
        programStart: start,
      );
});

final allExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  return ref.read(exerciseRepositoryProvider).fetchAllExercises();
});
