import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/locale_provider.dart';

void main() {
  group('localeTextDirection — RTL for ar, ar_EG, ar_SA, ur; LTR for others', () {
    test('English resolves to LTR', () {
      expect(localeTextDirection(const Locale('en')), TextDirection.ltr);
    });

    test('Arabic Fusha resolves to RTL', () {
      expect(localeTextDirection(const Locale('ar')), TextDirection.rtl);
    });

    test('Egyptian Arabic resolves to RTL', () {
      expect(localeTextDirection(const Locale('ar', 'EG')), TextDirection.rtl);
    });

    test('Gulf Arabic resolves to RTL', () {
      expect(localeTextDirection(const Locale('ar', 'SA')), TextDirection.rtl);
    });

    test('Urdu resolves to RTL', () {
      expect(localeTextDirection(const Locale('ur')), TextDirection.rtl);
    });

    test('French resolves to LTR', () {
      expect(localeTextDirection(const Locale('fr')), TextDirection.ltr);
    });

    test('Spanish resolves to LTR', () {
      expect(localeTextDirection(const Locale('es')), TextDirection.ltr);
    });

    test('Turkish resolves to LTR', () {
      expect(localeTextDirection(const Locale('tr')), TextDirection.ltr);
    });

    test('Hindi resolves to LTR', () {
      expect(localeTextDirection(const Locale('hi')), TextDirection.ltr);
    });

    test('Indonesian resolves to LTR', () {
      expect(localeTextDirection(const Locale('id')), TextDirection.ltr);
    });
  });
}
