import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show Bidi;
import 'package:vireo/core/services/hive_service.dart';

const _localeKey = 'locale';
const _initialLanguageSelectedKey = 'initial_language_selected';

/// Metadata for all 10 supported app languages and regional dialects.
enum AppLanguage {
  en(Locale('en'), 'English', 'English', false, 'EN'),
  ar(Locale('ar'), 'العربية (فصحى)', 'Arabic (Fusha)', true, 'عر'),
  arEG(Locale('ar', 'EG'), 'العربية (لهجة مصرية)', 'Egyptian Arabic', true, 'مصر'),
  arSA(Locale('ar', 'SA'), 'العربية (لهجة خليجية)', 'Gulf Arabic', true, 'خل'),
  fr(Locale('fr'), 'Français', 'French', false, 'FR'),
  es(Locale('es'), 'Español', 'Spanish', false, 'ES'),
  tr(Locale('tr'), 'Türkçe', 'Turkish', false, 'TR'),
  ur(Locale('ur'), 'اردو', 'Urdu', true, 'اردو'),
  hi(Locale('hi'), 'हिन्दी', 'Hindi', false, 'हि'),
  id(Locale('id'), 'Bahasa Indonesia', 'Indonesian', false, 'ID');

  const AppLanguage(
    this.locale,
    this.nativeName,
    this.englishName,
    this.isRtl,
    this.symbol,
  );

  final Locale locale;
  final String nativeName;
  final String englishName;
  final bool isRtl;
  final String symbol;

  String get code => locale.countryCode != null
      ? '${locale.languageCode}_${locale.countryCode}'
      : locale.languageCode;

  String get languageLabel => switch (this) {
        AppLanguage.ar ||
        AppLanguage.arEG ||
        AppLanguage.arSA =>
          'اللغة',
        AppLanguage.fr => 'Langue',
        AppLanguage.es => 'Idioma',
        AppLanguage.tr => 'Dil',
        AppLanguage.ur => 'زبان',
        AppLanguage.hi => 'भाषा',
        AppLanguage.id => 'Bahasa',
        AppLanguage.en => 'Language',
      };

  static AppLanguage fromLocale(Locale locale) {
    if (locale.languageCode == 'ar') {
      if (locale.countryCode == 'EG') return AppLanguage.arEG;
      if (locale.countryCode == 'SA') return AppLanguage.arSA;
      return AppLanguage.ar;
    }
    for (final lang in AppLanguage.values) {
      if (lang.locale.languageCode == locale.languageCode) {
        return lang;
      }
    }
    return AppLanguage.en;
  }

  static AppLanguage fromCode(String? code) {
    if (code == null || code.isEmpty) return AppLanguage.en;
    final normalized = code.replaceAll('-', '_');
    if (normalized == 'ar_EG') return AppLanguage.arEG;
    if (normalized == 'ar_SA') return AppLanguage.arSA;
    for (final lang in AppLanguage.values) {
      if (lang.code == normalized || lang.locale.languageCode == normalized) {
        return lang;
      }
    }
    return AppLanguage.en;
  }
}

/// Resolves default locale: device language if supported, else English.
Locale resolveDefaultDeviceLocale() {
  try {
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    final langCode = device.languageCode.toLowerCase();
    final country = device.countryCode?.toUpperCase();

    if (langCode == 'ar') {
      if (country == 'EG') return const Locale('ar', 'EG');
      if (const {'SA', 'AE', 'KW', 'QA', 'BH', 'OM'}.contains(country)) {
        return const Locale('ar', 'SA');
      }
      return const Locale('ar');
    }

    for (final lang in AppLanguage.values) {
      if (lang.locale.languageCode == langCode) {
        return lang.locale;
      }
    }
  } catch (_) {}

  return const Locale('en');
}

/// Persists and exposes the active app locale.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    if (HiveService.isInitialized) {
      final code = HiveService.settingsBox.get(_localeKey) as String?;
      if (code != null && code.isNotEmpty) {
        return AppLanguage.fromCode(code).locale;
      }
    }
    return resolveDefaultDeviceLocale();
  }

  Future<void> setLocale(Locale locale) async {
    try {
      final lang = AppLanguage.fromLocale(locale);
      if (HiveService.isInitialized) {
        await HiveService.settingsBox.put(_localeKey, lang.code);
        await HiveService.settingsBox.put(_initialLanguageSelectedKey, true);
      }
      state = lang.locale;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    await setLocale(language.locale);
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

final activeAppLanguageProvider = Provider<AppLanguage>((ref) {
  return AppLanguage.fromLocale(ref.watch(localeProvider));
});

/// Tracks whether the user has confirmed language on initial app launch.
class InitialLanguageNotifier extends Notifier<bool> {
  @override
  bool build() {
    if (!HiveService.isInitialized) return false;
    final selected =
        HiveService.settingsBox.get(_initialLanguageSelectedKey) as bool?;
    if (selected != null) return selected;

    final hasLocale = HiveService.settingsBox.get(_localeKey) != null;
    final onboardingDone =
        HiveService.settingsBox.get('onboarding_complete') == true;
    return hasLocale || onboardingDone;
  }

  Future<void> confirmInitialSelection() async {
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_initialLanguageSelectedKey, true);
    }
    state = true;
  }
}

final hasSelectedInitialLanguageProvider =
    NotifierProvider<InitialLanguageNotifier, bool>(
  InitialLanguageNotifier.new,
);

/// Resolves text direction from the active locale — RTL for ar, ar_EG, ar_SA, ur.
TextDirection localeTextDirection(Locale locale) {
  if (locale.languageCode == 'ar' || locale.languageCode == 'ur') {
    return TextDirection.rtl;
  }
  return Bidi.isRtlLanguage(locale.languageCode)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

final textDirectionProvider = Provider<TextDirection>((ref) {
  return localeTextDirection(ref.watch(localeProvider));
});
