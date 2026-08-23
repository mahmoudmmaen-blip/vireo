import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Full app color skins beyond light/dark brightness.
enum AppSkin {
  standard,
  amoled,
  navy;

  String get storageKey => name;

  static AppSkin fromStorage(String? value) {
    return AppSkin.values.firstWhere(
      (s) => s.storageKey == value,
      orElse: () => AppSkin.standard,
    );
  }

  /// Base palette for this skin (dark skins ignore system light).
  VireoColors get colors => switch (this) {
        AppSkin.standard => VireoColors.dark,
        AppSkin.amoled => VireoColors.amoled,
        AppSkin.navy => VireoColors.navy,
      };

  bool get isSpecialDark => this == AppSkin.amoled || this == AppSkin.navy;
}

const _skinKey = 'app_skin';

class AppSkinNotifier extends Notifier<AppSkin> {
  @override
  AppSkin build() {
    if (!HiveService.isInitialized) return AppSkin.standard;
    final stored = HiveService.settingsBox.get(_skinKey) as String?;
    return AppSkin.fromStorage(stored);
  }

  Future<void> setSkin(AppSkin skin) async {
    state = skin;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_skinKey, skin.storageKey);
  }
}

final appSkinProvider = NotifierProvider<AppSkinNotifier, AppSkin>(
  AppSkinNotifier.new,
);
