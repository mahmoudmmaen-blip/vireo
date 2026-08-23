import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const _themeModeKey = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    if (!HiveService.isInitialized) return ThemeMode.dark;
    final stored = HiveService.settingsBox.get(_themeModeKey) as String?;
    return stored == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await HiveService.settingsBox.put(
      _themeModeKey,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
