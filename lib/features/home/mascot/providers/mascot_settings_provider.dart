import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/home/mascot/domain/mascot_companion.dart';

class MascotSettings {
  const MascotSettings({
    this.useClassicRing = false,
    this.showMacroLayers = false,
    this.companion = MascotCompanion.panda,
  });

  /// When true, Home shows the classic calorie ring instead of the wave mascot.
  final bool useClassicRing;

  /// Stack protein / carbs / fat as liquid bands inside the body.
  final bool showMacroLayers;

  final MascotCompanion companion;

  MascotSettings copyWith({
    bool? useClassicRing,
    bool? showMacroLayers,
    MascotCompanion? companion,
  }) {
    return MascotSettings(
      useClassicRing: useClassicRing ?? this.useClassicRing,
      showMacroLayers: showMacroLayers ?? this.showMacroLayers,
      companion: companion ?? this.companion,
    );
  }
}

class MascotSettingsNotifier extends StateNotifier<MascotSettings> {
  MascotSettingsNotifier() : super(_read());

  static const _ringKey = 'mascot_use_classic_ring';
  static const _macroKey = 'mascot_show_macro_layers';
  static const _companionKey = 'mascot_companion';

  static MascotSettings _read() {
    if (!HiveService.isInitialized) return const MascotSettings();
    final box = HiveService.settingsBox;
    return MascotSettings(
      useClassicRing: box.get(_ringKey) as bool? ?? false,
      showMacroLayers: box.get(_macroKey) as bool? ?? false,
      companion: MascotCompanionX.fromId(box.get(_companionKey) as String?),
    );
  }

  Future<void> setUseClassicRing(bool value) async {
    state = state.copyWith(useClassicRing: value);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_ringKey, value);
    }
  }

  Future<void> setShowMacroLayers(bool value) async {
    state = state.copyWith(showMacroLayers: value);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_macroKey, value);
    }
  }

  Future<void> setCompanion(MascotCompanion companion) async {
    state = state.copyWith(companion: companion);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_companionKey, companion.id);
    }
  }
}

final mascotSettingsProvider =
    StateNotifierProvider<MascotSettingsNotifier, MascotSettings>(
  (ref) => MascotSettingsNotifier(),
);
