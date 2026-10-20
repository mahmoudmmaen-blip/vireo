import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/demo/nutrition_demo_catalog.dart';

/// One-shot Hive cleanup for seed/demo meal logs that should never count as
/// real eaten food (P56 phantom meal trust fix).
abstract final class PhantomMealCleanup {
  static const settingsFlagKey = 'p56_phantom_meal_cleanup_v1';
  static const _aiMealLogKey = 'ai_meal_logs';

  /// Known demo recipe titles (EN + AR) from [NutritionDemoCatalog].
  static final Set<String> _demoTitles = {
    for (final r in NutritionDemoCatalog.recipes) ...{
      r.titleEn.trim().toLowerCase(),
      r.titleAr.trim().toLowerCase(),
    },
  };

  /// Run once per install. Safe to call repeatedly.
  static Future<void> runIfNeeded() async {
    if (!HiveService.isInitialized) return;

    final settings = HiveService.settingsBox;
    if (settings.get(settingsFlagKey) == true) return;

    final removed = _scrubAiMealLogs();
    await settings.put(settingsFlagKey, true);

    // ignore: avoid_print — intentional console tag for QA/testers
    debugPrint('[P56] meal cleanup done; removed_demo_or_seed=$removed');
  }

  /// Returns how many seed/demo entries were removed from `ai_meal_logs`.
  static int _scrubAiMealLogs() {
    final raw = HiveService.cacheBox.get(_aiMealLogKey);
    if (raw is! List) return 0;

    final kept = <Map<String, dynamic>>[];
    var removed = 0;

    for (final item in raw) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      if (_isSeedOrDemoEntry(map)) {
        removed++;
        continue;
      }
      kept.add(map);
    }

    if (removed > 0) {
      HiveService.cacheBox.put(_aiMealLogKey, kept);
    }
    return removed;
  }

  @visibleForTesting
  static bool isSeedOrDemoEntry(Map<String, dynamic> map) =>
      _isSeedOrDemoEntry(map);

  static bool _isSeedOrDemoEntry(Map<String, dynamic> map) {
    final id = (map['id'] as String?)?.toLowerCase() ?? '';
    if (id.startsWith('demo-') ||
        id.startsWith('demo_') ||
        id.startsWith('seed_') ||
        id.contains('demo_meal') ||
        id.contains('seed_meal')) {
      return true;
    }

    final result = map['result'];
    if (result is! Map) return false;
    final resultMap = Map<String, dynamic>.from(result);
    final name = (resultMap['food_name'] as String?)?.trim().toLowerCase() ??
        (resultMap['foodName'] as String?)?.trim().toLowerCase() ??
        '';
    if (name.isEmpty) return false;

    // Only strip exact demo catalog titles — never wipe real user logs.
    return _demoTitles.contains(name);
  }
}
