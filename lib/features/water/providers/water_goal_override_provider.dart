import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const _overrideKey = 'water_goal_override_ml';

/// User-chosen daily water goal in ml (null = use weight-based formula).
class WaterGoalOverrideNotifier extends Notifier<int?> {
  @override
  int? build() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(_overrideKey);
    if (raw is num) {
      final ml = raw.toInt();
      if (ml >= 1000 && ml <= 5000) return ml;
    }
    return null;
  }

  Future<void> setMl(int ml) async {
    final clamped = ml.clamp(1000, 5000);
    state = clamped;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_overrideKey, clamped);
  }

  Future<void> clear() async {
    state = null;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.delete(_overrideKey);
  }
}

final waterGoalOverrideMlProvider =
    NotifierProvider<WaterGoalOverrideNotifier, int?>(
  WaterGoalOverrideNotifier.new,
);
