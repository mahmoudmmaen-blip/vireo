import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_health_score.dart';

void main() {
  group('MealHealthScorer', () {
    test('excellent meal clamps to 10', () {
      final r = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 400,
        proteinG: 50, // 12.5 g/100kcal → +2
        carbsG: 30,
        fatG: 10,
        fiberG: 9, // +2
        sugarG: 2,
        sodiumMg: 300,
        oilGrams: 0,
        vegGrams: 250, // 0.5 share → +2
        totalFoodGrams: 500,
        isFried: false,
      ));
      expect(r.score, 10);
      expect(r.reasonAr, isNotEmpty);
      expect(r.reasonEn, isNotEmpty);
    });

    test('worst meal clamps to 1 and blames the first most negative factor', () {
      final r = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 900,
        proteinG: 15, // 1.7 g/100kcal → -1
        carbsG: 100,
        fatG: 60,
        fiberG: 1, // -1
        sugarG: 40, // -2
        sodiumMg: 2000, // -2
        oilGrams: 60, // 0.2 share → -2
        vegGrams: 0,
        totalFoodGrams: 300,
        isFried: true,
      ));
      expect(r.score, 1);
      expect(r.reasonAr, contains('السكر'));
      expect(r.reasonEn.toLowerCase(), contains('sugar'));
    });

    test('mid meal stays at the base score 7', () {
      final r = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 500,
        proteinG: 30, // 6 g/100kcal → 0
        carbsG: 50,
        fatG: 20,
        fiberG: 3,
        sugarG: 5,
        sodiumMg: 500,
        oilGrams: 15, // 0.05 share
        vegGrams: 50, // 0.1 share
        totalFoodGrams: 300,
        isFried: false,
      ));
      expect(r.score, 7);
      expect(r.reasonEn, contains('balanced'));
    });

    test('fried alone costs 1 point and is the stated reason', () {
      final r = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 500,
        proteinG: 30,
        carbsG: 50,
        fatG: 20,
        fiberG: 3,
        sugarG: 5,
        sodiumMg: 500,
        oilGrams: 10,
        vegGrams: 0,
        totalFoodGrams: 300,
        isFried: true,
      ));
      expect(r.score, 6);
      expect(r.reasonAr, contains('تحمير'));
    });

    test('unknown fiber, sugar and sodium are neither rewarded nor penalised', () {
      final r = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 500,
        proteinG: 30,
        carbsG: 50,
        fatG: 20,
        oilGrams: 0,
        vegGrams: 0,
        totalFoodGrams: 300,
      ));
      expect(r.score, 7);
    });

    test('thresholds: protein 8 g/100kcal gives +1, low fiber with kcal>300 gives -1', () {
      final plus = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 500,
        proteinG: 40, // exactly 8
        carbsG: 50,
        fatG: 10,
        totalFoodGrams: 300,
      ));
      expect(plus.score, 8);

      final minus = MealHealthScorer.score(const MealNutrientSnapshot(
        kcal: 500,
        proteinG: 30,
        carbsG: 50,
        fatG: 10,
        fiberG: 1,
        totalFoodGrams: 300,
      ));
      expect(minus.score, 6);
    });

    test('is deterministic', () {
      const snap = MealNutrientSnapshot(
        kcal: 650,
        proteinG: 35,
        carbsG: 70,
        fatG: 25,
        fiberG: 6,
        sugarG: 18,
        sodiumMg: 900,
        oilGrams: 20,
        vegGrams: 100,
        totalFoodGrams: 350,
      );
      final a = MealHealthScorer.score(snap);
      final b = MealHealthScorer.score(snap);
      expect(a.score, b.score);
      expect(a.reasonAr, b.reasonAr);
      // protein 5.4 → 0, fiber +1, sugar -1, sodium -1, oil 0.057 → 0,
      // veg 0.286 → +1  → 7 + 1 - 1 - 1 + 1 = 7
      expect(a.score, 7);
    });
  });
}
