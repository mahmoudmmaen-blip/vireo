import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Locale resolution & multi-language defaults', () {
    test('default locale is device language if supported, else English', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final current = container.read(localeProvider);
      // In flutter_test environment, default device locale is en_US -> 'en'
      expect(current.languageCode, 'en');
    });

    test('supports all 10 languages and dialects', () {
      expect(AppLanguage.values.length, 10);

      expect(AppLanguage.fromCode('en'), AppLanguage.en);
      expect(AppLanguage.fromCode('ar'), AppLanguage.ar);
      expect(AppLanguage.fromCode('ar_EG'), AppLanguage.arEG);
      expect(AppLanguage.fromCode('ar-EG'), AppLanguage.arEG);
      expect(AppLanguage.fromCode('ar_SA'), AppLanguage.arSA);
      expect(AppLanguage.fromCode('ar-SA'), AppLanguage.arSA);
      expect(AppLanguage.fromCode('fr'), AppLanguage.fr);
      expect(AppLanguage.fromCode('es'), AppLanguage.es);
      expect(AppLanguage.fromCode('tr'), AppLanguage.tr);
      expect(AppLanguage.fromCode('ur'), AppLanguage.ur);
      expect(AppLanguage.fromCode('hi'), AppLanguage.hi);
      expect(AppLanguage.fromCode('id'), AppLanguage.id);
    });

    test('AppLanguage maps from Locale correctly', () {
      expect(AppLanguage.fromLocale(const Locale('ar')), AppLanguage.ar);
      expect(AppLanguage.fromLocale(const Locale('ar', 'EG')), AppLanguage.arEG);
      expect(AppLanguage.fromLocale(const Locale('ar', 'SA')), AppLanguage.arSA);
      expect(AppLanguage.fromLocale(const Locale('fr')), AppLanguage.fr);
      expect(AppLanguage.fromLocale(const Locale('es')), AppLanguage.es);
      expect(AppLanguage.fromLocale(const Locale('tr')), AppLanguage.tr);
      expect(AppLanguage.fromLocale(const Locale('ur')), AppLanguage.ur);
      expect(AppLanguage.fromLocale(const Locale('hi')), AppLanguage.hi);
      expect(AppLanguage.fromLocale(const Locale('id')), AppLanguage.id);
      expect(AppLanguage.fromLocale(const Locale('en')), AppLanguage.en);
    });

    test('AppLanguage code property formats country code', () {
      expect(AppLanguage.arEG.code, 'ar_EG');
      expect(AppLanguage.arSA.code, 'ar_SA');
      expect(AppLanguage.en.code, 'en');
      expect(AppLanguage.ur.code, 'ur');
    });
  });
}
