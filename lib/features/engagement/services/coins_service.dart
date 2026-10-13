import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/engagement/domain/daily_coin_task.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

class CoinsService {
  static const _balanceKey = 'user_coins_balance';
  static const _awardedPrefix = 'coins_awarded_tasks_';

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Gets the current accumulated coin balance.
  static int getBalance() {
    if (!HiveService.isInitialized) return 0;
    return HiveService.settingsBox.get(_balanceKey) as int? ?? 0;
  }

  /// Checks if a task has already awarded coins today.
  static bool isTaskAwardedToday(DailyCoinTask task) {
    if (!HiveService.isInitialized) return false;
    final today = _todayKey();
    final awardedList = HiveService.settingsBox.get('$_awardedPrefix$today');
    if (awardedList is List) {
      return awardedList.contains(task.name);
    }
    return false;
  }

  /// Awards coins for [task] once per day. Returns points awarded (0 if already awarded today).
  static Future<int> awardTask(DailyCoinTask task) async {
    if (!HiveService.isInitialized) return 0;
    if (isTaskAwardedToday(task)) return 0;

    final today = _todayKey();
    final currentList = (HiveService.settingsBox.get('$_awardedPrefix$today') as List?)?.cast<String>() ?? [];
    final updatedList = [...currentList, task.name];
    await HiveService.settingsBox.put('$_awardedPrefix$today', updatedList);

    final currentBalance = getBalance();
    final newBalance = currentBalance + task.points;
    await HiveService.settingsBox.put(_balanceKey, newBalance);

    return task.points;
  }

  /// Spends 500 coins to unlock 1 day of Vireo Pro. Returns true if successful.
  static Future<bool> spendForPro() async {
    if (!HiveService.isInitialized) return false;
    final currentBalance = getBalance();
    if (currentBalance < 500) return false;

    await HiveService.settingsBox.put(_balanceKey, currentBalance - 500);
    await FeatureGates.grantCoinsProDay();
    return true;
  }
}
