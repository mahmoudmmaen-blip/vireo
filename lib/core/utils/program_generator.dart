import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/training_environment.dart';

/// Weekly split templates keyed by [FitnessGoal], plus goal-aware selection.
abstract final class ProgramGenerator {
  static const programLengthDays = 84;

  /// Default / all-of-above: push–pull–legs + cardio + shoulders + full body.
  static const _splitAll = <int, List<String>>{
    DateTime.sunday: ['chest', 'triceps'],
    DateTime.monday: ['back', 'biceps'],
    DateTime.tuesday: ['legs', 'posterior_chain'],
    DateTime.wednesday: ['cardio'],
    DateTime.thursday: ['shoulders'],
    DateTime.friday: ['full_body', 'core'],
    DateTime.saturday: [],
  };

  /// Muscle building: higher volume strength days, lighter cardio midweek.
  static const _splitMuscle = <int, List<String>>{
    DateTime.sunday: ['chest', 'triceps'],
    DateTime.monday: ['back', 'biceps'],
    DateTime.tuesday: ['legs', 'posterior_chain'],
    DateTime.wednesday: ['shoulders', 'core'],
    DateTime.thursday: ['chest', 'back'],
    DateTime.friday: ['legs', 'full_body'],
    DateTime.saturday: [],
  };

  /// Weight loss: more cardio/HIIT days interleaved with full-body strength.
  static const _splitWeightLoss = <int, List<String>>{
    DateTime.sunday: ['full_body', 'core'],
    DateTime.monday: ['cardio'],
    DateTime.tuesday: ['legs', 'posterior_chain'],
    DateTime.wednesday: ['cardio'],
    DateTime.thursday: ['chest', 'back'],
    DateTime.friday: ['cardio', 'full_body'],
    DateTime.saturday: [],
  };

  /// General vitality: balanced mobility-friendly mix.
  static const _splitVitality = <int, List<String>>{
    DateTime.sunday: ['full_body'],
    DateTime.monday: ['cardio'],
    DateTime.tuesday: ['legs', 'core'],
    DateTime.wednesday: [],
    DateTime.thursday: ['back', 'shoulders'],
    DateTime.friday: ['cardio', 'core'],
    DateTime.saturday: [],
  };

  static Map<int, List<String>> splitForGoal(FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.weightLoss => _splitWeightLoss,
      FitnessGoal.muscleGain => _splitMuscle,
      FitnessGoal.generalVitality => _splitVitality,
      FitnessGoal.allOfAbove => _splitAll,
    };
  }

  static List<Exercise> buildTodayExercises({
    required FitnessGoal goal,
    required TrainingEnvironment environment,
    required List<Exercise> pool,
    required int dayIndex,
  }) {
    if (pool.isEmpty) return const [];

    final weekday = DateTime.now().weekday;
    final splitMuscles = splitForGoal(goal)[weekday] ?? const [];

    if (splitMuscles.isEmpty) {
      return const [];
    }

    final eligible = pool
        .where((e) => e.matchesEnvironment(environment))
        .where((e) => e.type != ExerciseType.mobility)
        .where((e) => _matchesSplit(e, splitMuscles))
        .toList();

    if (eligible.isEmpty) {
      return _fallbackForSplit(pool, environment, splitMuscles, goal, dayIndex);
    }

    final sorted = _sortForGoal(eligible, goal, dayIndex);
    final count = _exerciseCountForGoal(goal, weekday, splitMuscles);

    return sorted.take(count).map((e) => _tuneForGoal(e, goal, weekday)).toList();
  }

  static bool _matchesSplit(Exercise exercise, List<String> muscles) {
    final muscle = exercise.targetMuscle.toLowerCase();
    if (muscles.contains('cardio')) {
      return exercise.type == ExerciseType.cardio || muscle == 'cardio';
    }
    return muscles.any((m) => muscle.contains(m) || m.contains(muscle));
  }

  static List<Exercise> _fallbackForSplit(
    List<Exercise> pool,
    TrainingEnvironment environment,
    List<String> muscles,
    FitnessGoal goal,
    int dayIndex,
  ) {
    if (muscles.contains('cardio')) {
      final cardio = pool
          .where((e) => e.matchesEnvironment(environment))
          .where((e) => e.type == ExerciseType.cardio)
          .toList();
      return cardio
          .take(3)
          .map((e) => _tuneForGoal(e, goal, DateTime.now().weekday))
          .toList();
    }
    return pool
        .where((e) => e.matchesEnvironment(environment))
        .take(3)
        .map((e) => _tuneForGoal(e, goal, DateTime.now().weekday))
        .toList();
  }

  static List<Exercise> _sortForGoal(
    List<Exercise> list,
    FitnessGoal goal,
    int dayIndex,
  ) {
    return switch (goal) {
      FitnessGoal.weightLoss => _sortForWeightLoss(list, dayIndex),
      FitnessGoal.muscleGain => _sortForMuscleGain(list, dayIndex),
      FitnessGoal.generalVitality => _sortBalanced(list, dayIndex),
      FitnessGoal.allOfAbove => _sortComprehensive(list, dayIndex),
    };
  }

  static int _exerciseCountForGoal(
    FitnessGoal goal,
    int weekday,
    List<String> muscles,
  ) {
    final isCardioDay = muscles.length == 1 && muscles.contains('cardio');
    if (isCardioDay) {
      return switch (goal) {
        FitnessGoal.weightLoss => 4,
        FitnessGoal.allOfAbove => 3,
        _ => 2,
      };
    }
    return switch (goal) {
      FitnessGoal.weightLoss => 3,
      FitnessGoal.muscleGain => 5,
      FitnessGoal.generalVitality => 3,
      FitnessGoal.allOfAbove => 4,
    };
  }

  static List<Exercise> _sortForWeightLoss(List<Exercise> list, int day) {
    final hiit = list.where((e) => e.type == ExerciseType.cardio).toList();
    final strength = list.where((e) => e.type == ExerciseType.strength).toList();
    return [...hiit, ...strength]..sort((a, b) {
        final ai = (a.id.hashCode + day) % 100;
        final bi = (b.id.hashCode + day) % 100;
        return ai.compareTo(bi);
      });
  }

  static List<Exercise> _sortForMuscleGain(List<Exercise> list, int day) {
    return [...list]
      ..sort((a, b) {
        if (a.type != b.type) {
          return a.type == ExerciseType.strength ? -1 : 1;
        }
        return b.sets.compareTo(a.sets);
      });
  }

  static List<Exercise> _sortBalanced(List<Exercise> list, int day) {
    final cardio = list.where((e) => e.type == ExerciseType.cardio).take(1).toList();
    final strength = list.where((e) => e.type == ExerciseType.strength).take(2).toList();
    final seen = {...cardio.map((e) => e.id), ...strength.map((e) => e.id)};
    final rest = list.where((e) => !seen.contains(e.id));
    return [...cardio, ...strength, ...rest];
  }

  static List<Exercise> _sortComprehensive(List<Exercise> list, int day) {
    final groups = <String, List<Exercise>>{};
    for (final e in list) {
      groups.putIfAbsent(e.targetMuscle, () => []).add(e);
    }
    final result = <Exercise>[];
    for (final entry in groups.entries) {
      result.add(entry.value[day % entry.value.length]);
    }
    return result.isEmpty ? list : result;
  }

  static Exercise _tuneForGoal(Exercise e, FitnessGoal goal, int weekday) {
    final base = switch (goal) {
      FitnessGoal.weightLoss => e.copyWith(
          reps: (e.reps * 1.25).round(),
          restSeconds: (e.restSeconds * 0.7).round().clamp(20, 60),
        ),
      FitnessGoal.muscleGain => e.copyWith(
          sets: e.sets + 1,
          restSeconds: (e.restSeconds * 1.3).round().clamp(60, 120),
        ),
      FitnessGoal.generalVitality => e,
      FitnessGoal.allOfAbove => e.copyWith(
          sets: e.sets,
          restSeconds: (e.restSeconds * 1.1).round(),
        ),
    };

    final muscles = splitForGoal(goal)[weekday] ?? const [];
    if (muscles.contains('cardio') && goal == FitnessGoal.weightLoss) {
      return base.copyWith(
        reps: (base.reps * 1.1).round(),
        restSeconds: (base.restSeconds * 0.85).round().clamp(15, 45),
      );
    }
    return base;
  }

  static String splitLabelKeyForToday({FitnessGoal? goal}) {
    final g = goal ?? FitnessGoal.allOfAbove;
    final muscles = splitForGoal(g)[DateTime.now().weekday] ?? const [];
    if (muscles.isEmpty) return 'workoutSplitRest';
    if (muscles.contains('cardio') && muscles.length == 1) {
      return 'workoutSplitCardio';
    }
    if (muscles.contains('chest') && muscles.contains('triceps')) {
      return 'workoutSplitChestTriceps';
    }
    if (muscles.contains('back') && muscles.contains('biceps')) {
      return 'workoutSplitBackBiceps';
    }
    if (muscles.contains('legs')) return 'workoutSplitLegs';
    if (muscles.contains('shoulders')) return 'workoutSplitShoulders';
    if (muscles.contains('full_body')) return 'workoutSplitFullBody';
    return 'workoutSplitFullBody';
  }

  static int programDayFromStart(DateTime? startDate) {
    if (startDate == null) return 1;
    final days = DateTime.now().difference(startDate).inDays + 1;
    return days.clamp(1, programLengthDays);
  }
}
