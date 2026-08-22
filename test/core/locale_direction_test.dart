import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/locale_provider.dart';

void main() {
  group('localeTextDirection §2.1 — no hardcoded RTL', () {
    test('English resolves to LTR', () {
      expect(
        localeTextDirection(const Locale('en')),
        TextDirection.ltr,
      );
    });

    test('Arabic resolves to RTL', () {
      expect(
        localeTextDirection(const Locale('ar')),
        TextDirection.rtl,
      );
    });
  });
}
