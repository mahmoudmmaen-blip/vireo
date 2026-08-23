import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/training_environment.dart';

/// Builds goal-aware weekly workout selections from an exercise pool.
abstract final class ProgramGenerator {
  static const programLengthDays = 84;

  /// Picks today's main exercises based on onboarding goal and environment.
  static List<Exercise> buildTodayExercises({
    required FitnessGoal goal,
    required TrainingEnvironment environment,
    required List<Exercise> pool,
    required int dayIndex,
  }) {
    if (pool.isEmpty) return const [];

    final eligible = pool
        .where((e) => e.matchesEnvironment(environment))
        .where((e) => e.type != ExerciseType.mobility)
        .toList();
    if (eligible.isEmpty) return pool.take(3).toList();

    final sorted = switch (goal) {
      FitnessGoal.weightLoss => _sortForWeightLoss(eligible, dayIndex),
      FitnessGoal.muscleGain => _sortForMuscleGain(eligible, dayIndex),
      FitnessGoal.generalVitality => _sortBalanced(eligible, dayIndex),
      FitnessGoal.allOfAbove => _sortComprehensive(eligible, dayIndex),
    };

    final count = switch (goal) {
      FitnessGoal.weightLoss => 4,
      FitnessGoal.muscleGain => 3,
      FitnessGoal.generalVitality => 3,
      FitnessGoal.allOfAbove => 4,
    };

    return sorted.take(count).map((e) => _tuneForGoal(e, goal)).toList();
  }

  static List<Exercise> _sortForWeightLoss(List<Exercise> list, int day) {
    final hiit = list.where((e) => e.type == ExerciseType.cardio).toList();
    final strength = list.where((e) => e.type == ExerciseType.strength).toList();
    final rotated = [...hiit, ...strength]..sort((a, b) {
        final ai = (a.id.hashCode + day) % 100;
        final bi = (b.id.hashCode + day) % 100;
        return ai.compareTo(bi);
      });
    return rotated;
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

  static Exercise _tuneForGoal(Exercise e, FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.weightLoss => e.copyWith(
          reps: (e.reps * 1.2).round(),
          restSeconds: (e.restSeconds * 0.75).round().clamp(20, 90),
        ),
      FitnessGoal.muscleGain => e.copyWith(
          sets: e.sets + 1,
          restSeconds: (e.restSeconds * 1.25).round().clamp(45, 120),
        ),
      FitnessGoal.generalVitality => e,
      FitnessGoal.allOfAbove => e.copyWith(
          sets: e.sets,
          restSeconds: e.restSeconds,
        ),
    };
  }

  static int programDayFromStart(DateTime? startDate) {
    if (startDate == null) return 1;
    final days = DateTime.now().difference(startDate).inDays + 1;
    return days.clamp(1, programLengthDays);
  }
}
