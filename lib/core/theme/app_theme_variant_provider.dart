import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';

const _themeVariantKey = 'app_theme_variant_choice';

class AppThemeVariantNotifier extends Notifier<AppThemeVariant> {
  @override
  AppThemeVariant build() {
    final isFemale = ref.watch(isFemaleUserProvider);
    if (!HiveService.isInitialized) {
      return isFemale ? AppThemeVariant.calmGold : AppThemeVariant.ember;
    }
    final stored = HiveService.settingsBox.get(_themeVariantKey) as String?;
    return AppThemeVariant.fromStorage(stored, isFemale: isFemale);
  }

  Future<void> setThemeVariant(AppThemeVariant variant) async {
    state = variant;
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_themeVariantKey, variant.storageKey);
    }
  }
}

final appThemeVariantProvider =
    NotifierProvider<AppThemeVariantNotifier, AppThemeVariant>(
  AppThemeVariantNotifier.new,
);
