import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

/// User-selectable primary accent palette.
enum AccentPalette {
  vireoOrange,
  emeraldHealth,
  oceanicBlue,
  deepViolet;

  String get storageKey => name;

  Color get color => switch (this) {
        AccentPalette.vireoOrange => const Color(0xFFE8763C),
        AccentPalette.emeraldHealth => const Color(0xFF2E7D32),
        AccentPalette.oceanicBlue => const Color(0xFF1976D2),
        AccentPalette.deepViolet => const Color(0xFF7B1FA2),
      };

  static AccentPalette fromStorage(String? value) {
    return AccentPalette.values.firstWhere(
      (p) => p.storageKey == value,
      orElse: () => AccentPalette.vireoOrange,
    );
  }
}

const _accentKey = 'accent_palette';

class AccentPaletteNotifier extends Notifier<AccentPalette> {
  @override
  AccentPalette build() {
    if (!HiveService.isInitialized) return AccentPalette.vireoOrange;
    final stored = HiveService.settingsBox.get(_accentKey) as String?;
    return AccentPalette.fromStorage(stored);
  }

  Future<void> setPalette(AccentPalette palette) async {
    state = palette;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_accentKey, palette.storageKey);
  }
}

final accentPaletteProvider =
    NotifierProvider<AccentPaletteNotifier, AccentPalette>(
  AccentPaletteNotifier.new,
);
