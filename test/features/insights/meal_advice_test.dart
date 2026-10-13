import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/insights/domain/meal_advice.dart';

void main() {
  group('MealAdviceEngine', () {
    test('detects over on calories and suggests light dinner', () {
      final res = MealAdviceEngine.computeAdvice(
        dailyGoalKcal: 2000,
        dailyGoalProteinG: 150,
        dailyGoalCarbsG: 200,
        dailyGoalFatG: 65,
        eatenKcalBefore: 1200,
        eatenProteinBefore: 80,
        eatenCarbsBefore: 120,
        eatenFatBefore: 40,
        mealKcal: 900, // Total 2100 -> 100 over
        mealProteinG: 40,
        mealCarbsG: 90,
        mealFatG: 30,
        currentSlot: MealType.lunch,
        confirmedSlots: {MealType.breakfast, MealType.lunch},
        isRamadan: false,
        availableFoods: [],
      );

      expect(res.remainingKcalAfter, equals(-100));
      expect(res.adviceText, contains('خدت زيادة 100 سعرة'));
      expect(res.adviceText, contains('سلطة خضراء + 150 جم فراخ مشوية'));
    });

    test('detects low protein and suggests protein rich next meal', () {
      final res = MealAdviceEngine.computeAdvice(
        dailyGoalKcal: 2200,
        dailyGoalProteinG: 160,
        dailyGoalCarbsG: 220,
        dailyGoalFatG: 70,
        eatenKcalBefore: 600,
        eatenProteinBefore: 30,
        eatenCarbsBefore: 70,
        eatenFatBefore: 20,
        mealKcal: 700, // Total 1300 / 2200 -> 900 remaining
        mealProteinG: 30, // Total 60 / 160 -> 100g needed
        mealCarbsG: 90,
        mealFatG: 20,
        currentSlot: MealType.lunch,
        confirmedSlots: {MealType.breakfast, MealType.lunch},
        isRamadan: false,
        availableFoods: [],
      );

      expect(res.remainingProteinAfter, equals(100.0));
      expect(res.adviceText, contains('محتاج 100 جم بروتين كمان'));
      expect(res.adviceText, contains('علبة تونة + 2 بيض مسلوق'));
    });

    test('detects on-track status with remaining calories for dinner', () {
      final res = MealAdviceEngine.computeAdvice(
        dailyGoalKcal: 2000,
        dailyGoalProteinG: 140,
        dailyGoalCarbsG: 200,
        dailyGoalFatG: 60,
        eatenKcalBefore: 600,
        eatenProteinBefore: 45,
        eatenCarbsBefore: 60,
        eatenFatBefore: 15,
        mealKcal: 850, // Total 1450 -> 550 remaining
        mealProteinG: 75, // Total 120 -> 20 remaining
        mealCarbsG: 90,
        mealFatG: 25,
        currentSlot: MealType.lunch,
        confirmedSlots: {MealType.breakfast, MealType.lunch},
        isRamadan: false,
        availableFoods: [],
      );

      expect(res.remainingKcalAfter, equals(550));
      expect(res.adviceText, contains('ماشي تمام 👌'));
      expect(res.adviceText, contains('فاضلك 550 سعرة لـ العشا'));
    });

    test('handles last meal of the day', () {
      final res = MealAdviceEngine.computeAdvice(
        dailyGoalKcal: 1900,
        dailyGoalProteinG: 130,
        dailyGoalCarbsG: 180,
        dailyGoalFatG: 55,
        eatenKcalBefore: 1300,
        eatenProteinBefore: 90,
        eatenCarbsBefore: 120,
        eatenFatBefore: 35,
        mealKcal: 550, // Total 1850 -> 50 left
        mealProteinG: 38, // Total 128 -> 2 left
        mealCarbsG: 55,
        mealFatG: 18,
        currentSlot: MealType.snack,
        confirmedSlots: {MealType.breakfast, MealType.lunch, MealType.dinner, MealType.snack},
        isRamadan: false,
        availableFoods: [],
      );

      expect(res.adviceText, contains('يومك ممتاز ومتوازن تماماً'));
    });
  });
}
