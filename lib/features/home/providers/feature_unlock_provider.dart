import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const String _appInstallDateKey = 'app_install_date';
const String _forceUnlockAllFeaturesKey = 'force_unlock_all_features';

/// Returns how many days since the user first installed/opened Vireo (1-indexed: Day 1, Day 2, etc.).
final userJourneyDayProvider = Provider<int>((ref) {
  if (!HiveService.isInitialized) return 1;
  final stored = HiveService.settingsBox.get(_appInstallDateKey) as String?;
  if (stored == null) {
    final nowIso = DateTime.now().toIso8601String();
    HiveService.settingsBox.put(_appInstallDateKey, nowIso);
    return 1;
  }
  try {
    final installDate = DateTime.parse(stored);
    final diffDays = DateTime.now().difference(installDate).inDays;
    return diffDays + 1;
  } catch (_) {
    return 1;
  }
});

/// Whether advanced features (Social, body composition, Vitality Protocol, advanced diet programs)
/// are unlocked. Day 1 & 2 users only see the core essentials; Day 3+ or manual override unlocks all.
final isAdvancedFeaturesUnlockedProvider = StateNotifierProvider<FeatureUnlockNotifier, bool>((ref) {
  final day = ref.watch(userJourneyDayProvider);
  return FeatureUnlockNotifier(day >= 3);
});

class FeatureUnlockNotifier extends StateNotifier<bool> {
  FeatureUnlockNotifier(bool isDay3Plus) : super(_readInitial(isDay3Plus));

  static bool _readInitial(bool isDay3Plus) {
    if (!HiveService.isInitialized) return isDay3Plus;
    final forced = HiveService.settingsBox.get(_forceUnlockAllFeaturesKey) as bool? ?? false;
    return isDay3Plus || forced;
  }

  Future<void> unlockAllManually() async {
    state = true;
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_forceUnlockAllFeaturesKey, true);
    }
  }

  Future<void> resetToProgressive() async {
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.delete(_forceUnlockAllFeaturesKey);
    }
    state = false;
  }
}
