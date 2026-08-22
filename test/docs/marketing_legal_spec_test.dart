import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('docs/README index', () {
    test('indexes §6, §9, and §13 final documentation', () {
      final readme = File('docs/README.md').readAsStringSync();
      expect(readme, contains('§6'));
      expect(readme, contains('§9'));
      expect(readme, contains('§13'));
      expect(readme, contains('marketing/app_store_aso_en.md'));
      expect(readme, contains('legal/README.md'));
      expect(readme, contains('faq/faq_en_ar.md'));
    });
  });

  group('§6 App Store ASO copy', () {
    const asoFiles = [
      'docs/marketing/app_store_aso_en.md',
      'docs/marketing/app_store_aso_ar.md',
    ];

    test('English and Arabic ASO files exist', () {
      for (final path in asoFiles) {
        expect(File(path).existsSync(), isTrue, reason: 'missing $path');
      }
    });

    test('English ASO includes target keywords without hormone language', () {
      final en = File('docs/marketing/app_store_aso_en.md').readAsStringSync();
      final descStart = en.indexOf('## Full description');
      expect(descStart, greaterThanOrEqualTo(0));
      final storeCopy = en.substring(descStart).toLowerCase();

      expect(storeCopy, contains("men's fitness app"));
      expect(storeCopy, contains('home workout planner'));
      expect(storeCopy, contains('vitality and energy app'));
      expect(storeCopy, isNot(contains('testosterone')));
    });

    test('Arabic ASO includes target keywords without hormone language', () {
      final ar = File('docs/marketing/app_store_aso_ar.md').readAsStringSync();
      final descStart = ar.indexOf('## الوصف الكامل');
      expect(descStart, greaterThanOrEqualTo(0));
      final storeCopy = ar.substring(descStart);

      expect(storeCopy, contains('لياقة رجالية'));
      expect(storeCopy, contains('تمارين منزلية'));
      expect(storeCopy, contains('نظام غذائي صحي'));
      expect(storeCopy, isNot(contains('تستosterone')));
    });

    test('full descriptions stay under 4000 characters', () {
      for (final path in asoFiles) {
        final body = File(path).readAsStringSync();
        final start = body.indexOf('## Full description');
        final altStart = body.indexOf('## الوصف الكامل');
        final sectionStart = start >= 0 ? start : altStart;
        expect(sectionStart, greaterThanOrEqualTo(0), reason: '$path missing description section');

        final section = body.substring(sectionStart);
        expect(section.length, lessThan(4000), reason: '$path description too long');
      }
    });
  });

  group('§9 Legal documents (Terms + Privacy)', () {
    const legalFiles = [
      'docs/legal/terms_of_service_en.md',
      'docs/legal/terms_of_service_ar.md',
      'docs/legal/privacy_policy_en.md',
      'docs/legal/privacy_policy_ar.md',
    ];

    test('bilingual Terms and Privacy files exist', () {
      for (final path in legalFiles) {
        expect(File(path).existsSync(), isTrue, reason: 'missing $path');
      }
    });

    test('Terms include medical disclaimer and subscription clauses', () {
      final terms = File('docs/legal/terms_of_service_en.md').readAsStringSync().toLowerCase();
      expect(terms, contains('not a medical'));
      expect(terms, contains('auto-renewal'));
      expect(terms, contains('delete your account'));
      expect(terms, contains('[jurisdiction]'));
    });

    test('Privacy Policy covers health-adjacent data and deletion', () {
      final privacy = File('docs/legal/privacy_policy_en.md').readAsStringSync().toLowerCase();
      expect(privacy, contains('health screening'));
      expect(privacy, contains('progress photos'));
      expect(privacy, contains('delete'));
      expect(privacy, contains('supabase'));
    });

    test('legal README indexes all four documents', () {
      final readme = File('docs/legal/README.md').readAsStringSync();
      for (final doc in legalFiles) {
        expect(readme, contains(doc.split('/').last));
      }
    });
  });

  group('§13 FAQ', () {
    test('FAQ has bilingual Q/A pairs and swap-meal entry', () {
      final faq = File('docs/faq/faq_en_ar.md').readAsStringSync();
      expect(faq, contains('Section 13'));
      expect(faq, contains('**EN — Q:**'));
      expect(faq, contains('**AR — Q:**'));
      expect(faq, contains('Swap meal'));
      expect(faq, contains('بدّل الوجبة'));
    });

    test('FAQ covers at least 15 topics', () {
      final faq = File('docs/faq/faq_en_ar.md').readAsStringSync();
      final headings = RegExp(r'^## \d+\.', multiLine: true).allMatches(faq);
      expect(headings.length, greaterThanOrEqualTo(16));
    });
  });
}
