import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_correction_text.dart';

void main() {
  group('MealCorrectionText.parse', () {
    test('salmon not chicken, 150 g (P36 example)', () {
      final c = MealCorrectionText.parse('ده سلمون مش فراخ، 150 جم');
      expect(c.textForParser, 'سلمون 150 جم');
      expect(c.negatedTerms, ['فراخ']);
      expect(c.statedGrams, 150);
    });

    test('Arabic-Indic digits and "جرام"', () {
      final c = MealCorrectionText.parse('سمك مش لحمة ١٢٠ جرام');
      expect(c.textForParser, 'سمك 120 جرام');
      expect(c.negatedTerms, ['لحمه']);
      expect(c.statedGrams, 120);
    });

    test('no negation keeps the whole text', () {
      final c = MealCorrectionText.parse('رز 200 جم');
      expect(c.textForParser, 'رز 200 جم');
      expect(c.negatedTerms, isEmpty);
      expect(c.statedGrams, 200);
    });

    test('negation clause first, then the right food', () {
      final c = MealCorrectionText.parse('مش فراخ، سلمون مشوي');
      expect(c.textForParser, 'سلمون مشوي');
      expect(c.negatedTerms, ['فراخ']);
      expect(c.statedGrams, isNull);
    });

    test('two amounts => no single stated grams', () {
      final c = MealCorrectionText.parse('سلمون 150 جم، رز 100 جم');
      expect(c.statedGrams, isNull);
      expect(c.textForParser, 'سلمون 150 جم، رز 100 جم');
    });

    test('empty input is empty', () {
      expect(MealCorrectionText.parse('   ').isEmpty, isTrue);
    });
  });

  group('MealCorrectionText.lineMatchesTerm', () {
    test('matches by synonym and by prefix', () {
      expect(
        MealCorrectionText.lineMatchesTerm(
          nameAr: 'صدر دجاج مشوي',
          nameEn: 'Grilled chicken breast',
          term: 'فراخ',
        ),
        isTrue,
      );
      expect(
        MealCorrectionText.lineMatchesTerm(
          nameAr: 'الأرز الأبيض',
          nameEn: 'white rice',
          term: 'رز',
        ),
        isTrue,
      );
    });

    test('does not match unrelated lines', () {
      expect(
        MealCorrectionText.lineMatchesTerm(
          nameAr: 'سلطة خضراء',
          nameEn: 'green salad',
          term: 'فراخ',
        ),
        isFalse,
      );
    });
  });
}
