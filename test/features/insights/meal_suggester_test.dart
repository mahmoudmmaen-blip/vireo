import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/insights/domain/meal_suggester.dart';
import 'package:vireo/features/nutrition/domain/household_measures.dart';

void main() {
  group('MealSuggester Unit Tests', () {
    test('protein-gap: generates suggestions prioritizing protein when gap is large', () {
      final suggestions = MealSuggester.suggestNextMeal(
        remainingKcal: 800,
        remainingProtein: 60.0,
        remainingCarbs: 80.0,
        remainingFat: 25.0,
        currentSlot: MealType.lunch,
        catalogFoods: [],
      );

      expect(suggestions, isNotEmpty);
      final first = suggestions.first;
      // Chicken suggestion scales up to hit significant protein
      expect(first.totalProtein, greaterThanOrEqualTo(30.0));
      expect(first.totalKcal, lessThanOrEqualTo(900));
      expect(first.isLightSnackOnly, isFalse);
    });

    test('low-remaining: suggests light snack only when remaining kcal < 150', () {
      final suggestions = MealSuggester.suggestNextMeal(
        remainingKcal: 120,
        remainingProtein: 15.0,
        remainingCarbs: 10.0,
        remainingFat: 4.0,
        currentSlot: MealType.dinner,
        catalogFoods: [],
      );

      expect(suggestions, isNotEmpty);
      for (final s in suggestions) {
        expect(s.isLightSnackOnly, isTrue);
        expect(s.totalKcal, lessThanOrEqualTo(160));
      }
    });

    test('over-target: suggests light options <= 300 kcal when user is over target', () {
      final suggestions = MealSuggester.suggestNextMeal(
        remainingKcal: -150, // Over target
        remainingProtein: 0.0,
        remainingCarbs: 0.0,
        remainingFat: 0.0,
        currentSlot: MealType.dinner,
        catalogFoods: [],
      );

      expect(suggestions, isNotEmpty);
      for (final s in suggestions) {
        expect(s.isLightSnackOnly, isTrue);
        expect(s.totalKcal, lessThanOrEqualTo(300));
        expect(s.nameAr, contains('خلّي الوجبة خفيفة'));
      }
    });

    test('pregnancy mode or under-18 never enforces deficit', () {
      final suggestionsPregnancy = MealSuggester.suggestNextMeal(
        remainingKcal: 100, // Normally a tiny snack
        remainingProtein: 30.0,
        remainingCarbs: 40.0,
        remainingFat: 15.0,
        currentSlot: MealType.lunch,
        catalogFoods: [],
        isPregnancyMode: true,
      );

      expect(suggestionsPregnancy, isNotEmpty);
      // In pregnancy mode, it provides a full balanced meal instead of forcing a low deficit snack
      expect(suggestionsPregnancy.first.isLightSnackOnly, isFalse);
      expect(suggestionsPregnancy.first.totalKcal, greaterThanOrEqualTo(300));
    });

    test('determinism: repeated calls with same inputs yield identical results', () {
      final call1 = MealSuggester.suggestNextMeal(
        remainingKcal: 650,
        remainingProtein: 45.0,
        remainingCarbs: 70.0,
        remainingFat: 20.0,
        currentSlot: MealType.lunch,
        catalogFoods: [],
      );

      final call2 = MealSuggester.suggestNextMeal(
        remainingKcal: 650,
        remainingProtein: 45.0,
        remainingCarbs: 70.0,
        remainingFat: 20.0,
        currentSlot: MealType.lunch,
        catalogFoods: [],
      );

      expect(call1.length, equals(call2.length));
      for (int i = 0; i < call1.length; i++) {
        expect(call1[i].id, equals(call2[i].id));
        expect(call1[i].totalKcal, equals(call2[i].totalKcal));
        expect(call1[i].totalProtein, equals(call2[i].totalProtein));
        expect(call1[i].componentsDescription(true), equals(call2[i].componentsDescription(true)));
      }
    });
  });

  group('HouseholdMeasures Unit Tests', () {
    test('conversions per food category', () {
      final riceUnits = HouseholdMeasures.getUnitsForFood(nameAr: 'أرز أبيض', nameEn: 'White rice');
      expect(riceUnits.any((u) => u.unitId == HouseholdUnitId.cup && u.baseGrams == 160), isTrue);

      final oilUnits = HouseholdMeasures.getUnitsForFood(nameAr: 'زيت زيتون', nameEn: 'Olive oil');
      expect(oilUnits.any((u) => u.unitId == HouseholdUnitId.tablespoon && u.baseGrams == 13.5), isTrue);
      expect(oilUnits.any((u) => u.unitId == HouseholdUnitId.teaspoon && u.baseGrams == 4.5), isTrue);

      final chickenUnits = HouseholdMeasures.getUnitsForFood(nameAr: 'دجاج مشوي', nameEn: 'Grilled chicken');
      expect(chickenUnits.any((u) => u.unitId == HouseholdUnitId.palm && u.baseGrams == 110), isTrue);

      final breadUnits = HouseholdMeasures.getUnitsForFood(nameAr: 'عيش بلدي', nameEn: 'Baladi bread');
      expect(breadUnits.any((u) => u.unitId == HouseholdUnitId.baladiLoaf && u.baseGrams == 90), isTrue);
    });

    test('custom cup size scaling', () {
      const ricePortion = HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 160);

      // Standard cup (240ml) -> 160g
      final standardG = HouseholdMeasures.computeGrams(
        portion: ricePortion,
        quantity: 1.0,
        cupSizeMl: 240,
      );
      expect(standardG, equals(160.0));

      // Small cup (200ml) -> 160 * (200 / 240) = 133.3 -> 133g
      final smallG = HouseholdMeasures.computeGrams(
        portion: ricePortion,
        quantity: 1.0,
        cupSizeMl: 200,
      );
      expect(smallG, equals(133.0));

      // Large mug (300ml) -> 160 * (300 / 240) = 200g
      final largeG = HouseholdMeasures.computeGrams(
        portion: ricePortion,
        quantity: 1.0,
        cupSizeMl: 300,
      );
      expect(largeG, equals(200.0));
    });

    test('fraction steps formatting', () {
      expect(HouseholdMeasures.formatQuantity(0.25, true), equals('¼'));
      expect(HouseholdMeasures.formatQuantity(0.5, true), equals('½'));
      expect(HouseholdMeasures.formatQuantity(1.0, true), equals('1'));
      expect(HouseholdMeasures.formatQuantity(1.5, true), equals('1 ½'));
      expect(HouseholdMeasures.formatQuantity(2.0, true), equals('2'));
    });
  });
}
