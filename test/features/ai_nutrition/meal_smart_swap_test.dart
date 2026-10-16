import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_smart_swap.dart';

SwapCandidateLine _line(
  String ar,
  String en, {
  required double grams,
  required double kcal,
  double p = 0,
  double c = 0,
  double f = 0,
}) =>
    SwapCandidateLine(
      nameAr: ar,
      nameEn: en,
      grams: grams,
      kcal: kcal,
      proteinG: p,
      carbsG: c,
      fatG: f,
    );

void main() {
  group('MealSmartSwap', () {
    test('chicken with skin: 150 g saves ~100 kcal and 8 g fat', () {
      final tip = MealSmartSwap.pick([
        _line('فراخ بالجلد', 'Roasted chicken with skin',
            grams: 150, kcal: 330, p: 35, f: 20),
      ]);
      expect(tip, isNotNull);
      expect(tip!.savedKcal, 100);
      expect(tip.savedFatG, 8.0);
      expect(tip.tipAr, contains('جلد'));
    });

    test('skinless chicken does not trigger the skin rule', () {
      final tip = MealSmartSwap.pick([
        _line('صدور فراخ بدون جلد', 'Skinless chicken breast',
            grams: 150, kcal: 240, p: 45, f: 5),
      ]);
      expect(tip, isNull);
    });

    test('rice >= 200 g: halve saves half of the line kcal', () {
      final tip = MealSmartSwap.pick([
        _line('رز أبيض', 'White rice', grams: 250, kcal: 320, c: 70, f: 4),
      ]);
      expect(tip, isNotNull);
      expect(tip!.savedKcal, 160);
      expect(tip.savedFatG, 2.0);
      expect(tip.tipAr, contains('125'));
    });

    test('rice under 200 g has no tip', () {
      final tip = MealSmartSwap.pick([
        _line('رز', 'Rice', grams: 150, kcal: 200, c: 44, f: 2),
      ]);
      expect(tip, isNull);
    });

    test('fried: saves 30% of fat calories', () {
      final tip = MealSmartSwap.pick([
        _line('بطاطس مقلية', 'Fried potatoes', grams: 150, kcal: 400, c: 50, f: 20),
      ]);
      expect(tip, isNotNull);
      expect(tip!.savedKcal, 54); // 20 g * 9 * 0.3
      expect(tip.savedFatG, 6.0);
    });

    test('soda: replaced by water saves the full kcal', () {
      final tip = MealSmartSwap.pick([
        _line('بيبسي', 'Soda (Pepsi)', grams: 330, kcal: 140, c: 37),
      ]);
      expect(tip, isNotNull);
      expect(tip!.savedKcal, 140);
    });

    test('white bread gives a fiber tip with no kcal claim', () {
      final tip = MealSmartSwap.pick([
        _line('عيش أبيض', 'White bread', grams: 60, kcal: 160, c: 30, f: 2),
      ]);
      expect(tip, isNotNull);
      expect(tip!.savedKcal, 0);
      expect(tip.tipAr, contains('البلدي'));
    });

    test('picks the rule with the highest saving across lines', () {
      final tip = MealSmartSwap.pick([
        _line('عصير مانجو', 'Mango juice', grams: 250, kcal: 130, c: 32),
        _line('رز أبيض', 'White rice', grams: 300, kcal: 390, c: 85, f: 4),
      ]);
      expect(tip!.savedKcal, 195);
    });

    test('returns null when nothing matches', () {
      final tip = MealSmartSwap.pick([
        _line('سلطة خضراء', 'Green salad', grams: 150, kcal: 40, c: 6),
      ]);
      expect(tip, isNull);
    });
  });
}
