import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/engagement/services/coins_service.dart';
import 'package:vireo/features/home/living_backgrounds/domain/scene_pack.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';

class LivingBackgroundSettings {
  const LivingBackgroundSettings({
    this.isEnabled = true,
    this.fixedPack,
    this.unlockedPacks = const {},
  });

  final bool isEnabled;
  final ScenePackId? fixedPack;
  final Set<ScenePackId> unlockedPacks;

  LivingBackgroundSettings copyWith({
    bool? isEnabled,
    ScenePackId? fixedPack,
    bool clearFixedPack = false,
    Set<ScenePackId>? unlockedPacks,
  }) {
    return LivingBackgroundSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      fixedPack: clearFixedPack ? null : (fixedPack ?? this.fixedPack),
      unlockedPacks: unlockedPacks ?? this.unlockedPacks,
    );
  }
}

class LivingBackgroundSettingsNotifier extends StateNotifier<LivingBackgroundSettings> {
  LivingBackgroundSettingsNotifier() : super(_readInitial());

  static const _enabledKey = 'living_backgrounds_enabled';
  static const _fixedPackKey = 'living_backgrounds_fixed_pack';
  static const _unlockedKey = 'living_backgrounds_unlocked_packs';

  static LivingBackgroundSettings _readInitial() {
    if (!HiveService.isInitialized) {
      return const LivingBackgroundSettings();
    }

    final enabled = HiveService.settingsBox.get(_enabledKey) as bool? ?? true;
    final fixedName = HiveService.settingsBox.get(_fixedPackKey) as String?;
    final fixedPack = fixedName != null
        ? ScenePackId.values.where((p) => p.name == fixedName).firstOrNull
        : null;

    final unlockedList = (HiveService.settingsBox.get(_unlockedKey) as List?)?.cast<String>() ?? [];
    final unlockedPacks = unlockedList
        .map((name) => ScenePackId.values.where((p) => p.name == name).firstOrNull)
        .whereType<ScenePackId>()
        .toSet();

    return LivingBackgroundSettings(
      isEnabled: enabled,
      fixedPack: fixedPack,
      unlockedPacks: unlockedPacks,
    );
  }

  Future<void> toggleEnabled(bool enabled) async {
    state = state.copyWith(isEnabled: enabled);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_enabledKey, enabled);
    }
  }

  Future<void> setFixedPack(ScenePackId? pack) async {
    state = state.copyWith(fixedPack: pack, clearFixedPack: pack == null);
    if (HiveService.isInitialized) {
      if (pack == null) {
        await HiveService.settingsBox.delete(_fixedPackKey);
      } else {
        await HiveService.settingsBox.put(_fixedPackKey, pack.name);
      }
    }
  }

  /// Attempts to unlock a premium pack for 300 coins.
  Future<bool> unlockPackWithCoins(ScenePackId pack) async {
    if (!pack.isPremium) return true;
    if (state.unlockedPacks.contains(pack)) return true;

    final balance = CoinsService.getBalance();
    if (balance < 300) return false;

    // Deduct coins
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put('user_coins_balance', balance - 300);
      final updated = {...state.unlockedPacks, pack};
      await HiveService.settingsBox.put(
        _unlockedKey,
        updated.map((p) => p.name).toList(),
      );
      state = state.copyWith(unlockedPacks: updated);
      return true;
    }
    return false;
  }
}

final livingBackgroundSettingsProvider =
    StateNotifierProvider<LivingBackgroundSettingsNotifier, LivingBackgroundSettings>((ref) {
  return LivingBackgroundSettingsNotifier();
});

final activeScenePackProvider = Provider<ScenePack>((ref) {
  final settings = ref.watch(livingBackgroundSettingsProvider);
  final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
  final isPro = ref.watch(hasPremiumAccessProvider);

  // Streak detection (>= 7 days gives streak reward pack override)
  final workoutDays = StepCounterService.readWorkoutDays();
  final streak = workoutDays.length;

  final resolvedId = ScenePack.resolveActive(
    date: DateTime.now(),
    isEnabled: settings.isEnabled,
    fixedPack: settings.fixedPack,
    isRamadan: isRamadan,
    streakDays: streak,
    isPro: isPro,
    unlockedCoinPacks: settings.unlockedPacks,
  );

  return ScenePack(id: resolvedId);
});
