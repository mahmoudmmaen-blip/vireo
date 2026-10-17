import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/notifications/services/nurture_scheduler.dart';

/// True when the user hit a goal (steps, protein, water, workout) — gates share entry.
final weeklyShareEligibleProvider = Provider<bool>((ref) {
  if (!HiveService.isInitialized) return false;
  return HiveService.settingsBox.get(nurtureGoalHitKey) == true;
});
