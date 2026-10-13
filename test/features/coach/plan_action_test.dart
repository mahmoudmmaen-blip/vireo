import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_coach/domain/plan_action.dart';

void main() {
  group('PlanAction.extractFromMessage', () {
    test('returns clean text and null when no plan_action tag present', () {
      const msg = 'عاش يا بطل، كمل التزامك بالبروتين النهاردة!';
      final (cleanText, action) = PlanAction.extractFromMessage(msg);
      expect(cleanText, equals(msg));
      expect(action, isNull);
    });

    test('extracts plan_action block and leaves clean surrounding text', () {
      const msg = '''
تمام يا كوتش، بناءً على تقدمك هنزود السعرات شوية عشان البناء العضلي.
```plan_action
{
  "type": "change_targets",
  "title": "تعديل أهداف السعرات والبروتين",
  "description": "زيادة 150 سعرة لدعم الاستشفاء",
  "data": {
    "target_kcal": 2150,
    "target_protein_g": 160
  }
}
```
اضغط على الزرار تحت علشان تطبق التعديل مباشرة على خطتك.
''';

      final (cleanText, action) = PlanAction.extractFromMessage(msg);
      expect(cleanText, contains('تمام يا كوتش'));
      expect(cleanText, contains('اضغط على الزرار تحت'));
      expect(cleanText.contains('```plan_action'), isFalse);
      expect(action, isNotNull);
      expect(action!.type, equals(PlanActionType.changeTargets));
      expect(action.title, equals('تعديل أهداف السعرات والبروتين'));
      expect(action.description, equals('زيادة 150 سعرة لدعم الاستشفاء'));
      expect(action.data['target_kcal'], equals(2150));
      expect(action.data['target_protein_g'], equals(160));
    });

    test('handles malformed json gracefully', () {
      const msg = '''
كلام عادي
```plan_action
{ not json }
```
كلام تاني
''';
      final (cleanText, action) = PlanAction.extractFromMessage(msg);
      expect(cleanText.contains('not json'), isFalse);
      expect(action, isNull);
    });
  });

  group('PlanAction.clampTargets safety rails', () {
    test('enforces 1200 kcal floor for women', () {
      final (safeKcal, safeProtein) = PlanAction.clampTargets(
        requestedKcal: 1000,
        requestedProtein: 120,
        isFemale: true,
      );
      expect(safeKcal, equals(1200));
      expect(safeProtein, equals(120));
    });

    test('enforces 1500 kcal floor for men', () {
      final (safeKcal, safeProtein) = PlanAction.clampTargets(
        requestedKcal: 1300,
        requestedProtein: 140,
        isFemale: false,
      );
      expect(safeKcal, equals(1500));
      expect(safeProtein, equals(140));
    });

    test('enforces 1800 kcal floor for pregnancy or under 18', () {
      final (safeKcalPreg, _) = PlanAction.clampTargets(
        requestedKcal: 1400,
        requestedProtein: 100,
        isFemale: true,
        isPregnancy: true,
      );
      expect(safeKcalPreg, equals(1800));

      final (safeKcalYouth, _) = PlanAction.clampTargets(
        requestedKcal: 1200,
        requestedProtein: 100,
        isFemale: false,
        isUnder18: true,
      );
      expect(safeKcalYouth, equals(1800));
    });

    test('clamps protein within 80g to 280g range', () {
      final (_, lowProtein) = PlanAction.clampTargets(
        requestedKcal: 2000,
        requestedProtein: 50,
        isFemale: false,
      );
      expect(lowProtein, equals(80));

      final (_, highProtein) = PlanAction.clampTargets(
        requestedKcal: 2000,
        requestedProtein: 350,
        isFemale: false,
      );
      expect(highProtein, equals(280));
    });
  });
}
