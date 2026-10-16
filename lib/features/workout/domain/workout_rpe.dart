import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/workout_session.dart';

/// Hive settings key holding the RPE (1–10) of the most recent workout.
/// Read it before the next session to suggest a lighter/heavier load.
const String lastWorkoutRpeKey = 'last_workout_rpe';

/// Post-workout feelings the user can multi-select.
enum WorkoutFeeling { tired, jointPain, happy, energized }

/// Which smart comment to show after the RPE is saved.
enum WorkoutRpeInsight { joint, hard, better, easy, partial, steady }

/// Pure helpers for the RPE (rate of perceived exertion) flow.
abstract final class WorkoutRpe {
  static const int min = 1;
  static const int max = 10;

  /// 1–3 easy, 4–7 just right, 8–10 hard.
  static WorkoutDifficultyFeedback toDifficulty(int rpe) {
    if (rpe <= 3) return WorkoutDifficultyFeedback.easy;
    if (rpe <= 7) return WorkoutDifficultyFeedback.justRight;
    return WorkoutDifficultyFeedback.hard;
  }

  /// Picks the comment. Priority: joint pain > very hard > better than last
  /// time > very easy > low completion > steady.
  ///
  /// [completion] is the fraction (0..1) of planned sets that were completed.
  /// [previousRpe] is the RPE saved after the previous session, if any.
  static WorkoutRpeInsight insightFor({
    required int rpe,
    required Set<WorkoutFeeling> feelings,
    required double completion,
    int? previousRpe,
  }) {
    if (feelings.contains(WorkoutFeeling.jointPain)) {
      return WorkoutRpeInsight.joint;
    }
    if (rpe >= 8) return WorkoutRpeInsight.hard;
    if (previousRpe != null && rpe < previousRpe) {
      return WorkoutRpeInsight.better;
    }
    if (rpe <= 3) return WorkoutRpeInsight.easy;
    if (completion < 0.6) return WorkoutRpeInsight.partial;
    return WorkoutRpeInsight.steady;
  }

  /// Last saved RPE, or null when none (or Hive is not ready).
  static int? lastRpe() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(lastWorkoutRpeKey);
    if (raw is int && raw >= min && raw <= max) return raw;
    return null;
  }

  /// Persists RPE + feelings + note locally. Never throws.
  static Future<void> persist({
    required int rpe,
    required Set<WorkoutFeeling> feelings,
    required String note,
    String? sessionId,
  }) async {
    if (!HiveService.isInitialized) return;
    try {
      final box = HiveService.settingsBox;
      await box.put(lastWorkoutRpeKey, rpe);
      await box.put('last_workout_rpe_at', DateTime.now().toIso8601String());
      if (sessionId != null) {
        await box.put('workout_rpe_$sessionId', <String, dynamic>{
          'rpe': rpe,
          'feelings': feelings.map((f) => f.name).toList(),
          'note': note,
        });
      }
    } catch (_) {
      // Local persistence is best-effort; the check-in itself is saved elsewhere.
    }
  }
}
