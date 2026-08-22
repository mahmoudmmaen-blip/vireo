import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('§11–12 content + microcopy assets', () {
    const copyFiles = [
      'docs/copy/push_notifications.json',
      'docs/copy/empty_error_states.json',
      'docs/copy/faq_en_ar.md',
      'docs/copy/app_store_screenshot_captions.md',
    ];

    test('required copy files exist', () {
      for (final path in copyFiles) {
        expect(File(path).existsSync(), isTrue, reason: 'missing $path');
      }
    });

    test('push notifications JSON includes bilingual copy fields', () {
      final raw = File('docs/copy/push_notifications.json').readAsStringSync();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      expect(decoded, isNotEmpty);

      final firstEvent = decoded.values.first as Map<String, dynamic>;
      final variants = firstEvent['variants'] as List;
      expect(variants, isNotEmpty);

      final variant = variants.first as Map<String, dynamic>;
      expect(variant.keys, contains('title_en'));
      expect(variant.keys, contains('title_ar'));
    });

    test('empty/error states avoid blame-oriented tone markers', () {
      final raw =
          File('docs/copy/empty_error_states.json').readAsStringSync();
      final lower = raw.toLowerCase();
      for (final phrase in ['your fault', 'failed user', 'lazy']) {
        expect(lower, isNot(contains(phrase)));
      }
    });

    test('FAQ includes Arabic and English headings', () {
      final faq = File('docs/copy/faq_en_ar.md').readAsStringSync();
      expect(faq, contains('English'));
      expect(faq, contains('Egyptian Arabic'));
    });
  });

  group('§14 analytics plan doc', () {
    test('event tracking plan documents meal_swapped and fridge_scan_used', () {
      final plan =
          File('docs/analytics/event_tracking_plan.md').readAsStringSync();
      expect(plan, contains('meal_swapped'));
      expect(plan, contains('fridge_scan_used'));
    });
  });
}
