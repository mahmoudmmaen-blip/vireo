import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

/// Client-side mirror of the daily AI meal-scan quota (server is authoritative).
abstract final class MealScanQuota {
  static const _usedKeyPrefix = 'meal_scans_used_';

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static int getUsedToday() {
    if (!HiveService.isInitialized) return 0;
    final raw = HiveService.settingsBox.get('$_usedKeyPrefix${_todayKey()}');
    return raw is num ? raw.toInt() : 0;
  }

  /// Call after a successful AI vision analyze (items returned).
  static Future<void> recordScanConsumed() async {
    if (!HiveService.isInitialized) return;
    final key = '$_usedKeyPrefix${_todayKey()}';
    final current = getUsedToday();
    await HiveService.settingsBox.put(key, current + 1);
  }

  /// Remaining free scans today (allowance − used), clamped at 0.
  static int remainingFreeScansToday() {
    final allowed = FeatureGates.getDailyFreeMealScansAllowed();
    final used = getUsedToday();
    final left = allowed - used;
    return left < 0 ? 0 : left;
  }
}
