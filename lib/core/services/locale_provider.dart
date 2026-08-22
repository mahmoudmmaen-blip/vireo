import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show Bidi;
import 'package:vireo/core/services/hive_service.dart';

const _localeKey = 'locale';

/// Persists and exposes the active app locale.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    if (HiveService.isInitialized) {
      final code = HiveService.settingsBox.get(_localeKey) as String?;
      if (code == 'en') return const Locale('en');
    }
    return const Locale('ar');
  }

  Future<void> setLocale(Locale locale) async {
    try {
      await HiveService.settingsBox.put(_localeKey, locale.languageCode);
      state = locale;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> toggleLocale() async {
    final next = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(next);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Resolves text direction from the active locale — never hardcoded.
TextDirection localeTextDirection(Locale locale) {
  return Bidi.isRtlLanguage(locale.languageCode)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

final textDirectionProvider = Provider<TextDirection>((ref) {
  return localeTextDirection(ref.watch(localeProvider));
});
