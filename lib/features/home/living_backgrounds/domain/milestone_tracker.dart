import 'package:flutter/services.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';

class MilestoneResult {
  const MilestoneResult({
    required this.percentage,
    required this.message,
  });

  final int percentage;
  final String message;
}

class MilestoneTracker {
  static const _prefix = 'steps_milestone_';

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Checks if a milestone has already been fired today.
  static bool hasMilestoneFiredToday(int percentage, [DateTime? now]) {
    if (!HiveService.isInitialized) return false;
    final date = now ?? DateTime.now();
    final key = '$_prefix${_dateKey(date)}_$percentage';
    return HiveService.settingsBox.get(key) as bool? ?? false;
  }

  /// Marks a milestone as fired for today.
  static Future<void> markMilestoneFiredToday(int percentage, [DateTime? now]) async {
    if (!HiveService.isInitialized) return;
    final date = now ?? DateTime.now();
    final key = '$_prefix${_dateKey(date)}_$percentage';
    await HiveService.settingsBox.put(key, true);
  }

  /// Checks the current step progress against goal. If a milestone (25, 50, 75, 100%)
  /// was crossed and hasn't fired today, fires light haptics, marks Hive, and returns the result.
  static Future<MilestoneResult?> checkAndTriggerMilestone({
    required int stepsCurrent,
    required int stepsGoal,
    required AppLocalizations l10n,
    DateTime? now,
    bool isFemale = false,
  }) async {
    final effectiveGoal = stepsGoal > 0 ? stepsGoal : 7000;
    final ratio = stepsCurrent / effectiveGoal;
    final gender = isFemale ? 'female' : 'male';

    int? milestoneHit;
    if (ratio >= 1.0) {
      milestoneHit = 100;
    } else if (ratio >= 0.75) {
      milestoneHit = 75;
    } else if (ratio >= 0.50) {
      milestoneHit = 50;
    } else if (ratio >= 0.25) {
      milestoneHit = 25;
    }

    if (milestoneHit == null) return null;

    final date = now ?? DateTime.now();
    if (hasMilestoneFiredToday(milestoneHit, date)) {
      return null;
    }

    // Fire haptic non-blocking
    try {
      HapticFeedback.lightImpact().ignore();
    } catch (_) {}

    // Persist to Hive so it fires at most once per day
    await markMilestoneFiredToday(milestoneHit, date);

    final message = switch (milestoneHit) {
      25 => l10n.stepMilestoneToast25(gender),
      50 => l10n.stepMilestoneToast50(gender),
      75 => l10n.stepMilestoneToast75(gender),
      _ => l10n.stepMilestoneToast100(gender),
    };

    return MilestoneResult(percentage: milestoneHit, message: message);
  }
}
