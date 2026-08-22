import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/fridge_scan_repository.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';

void main() {
  group('MealType §2.6 four meal tabs', () {
    test('defines breakfast, lunch, dinner, snack', () {
      expect(MealType.values.length, 4);
      expect(MealType.values.map((m) => m.value), containsAll([
        'breakfast',
        'lunch',
        'dinner',
        'snack',
      ]));
    });

    test('fromValue round-trips spec values', () {
      expect(MealType.fromValue('dinner'), MealType.dinner);
      expect(MealType.fromValue('snack'), MealType.snack);
    });
  });

  group('RecipeGoalTag §2.6 goal-aware suggestions', () {
    test('serializes tags used by suggest-recipes edge function', () {
      expect(RecipeGoalTag.highProtein.value, 'high_protein');
      expect(RecipeGoalTag.quickEasy.value, 'quick_easy');
      expect(RecipeGoalTag.lightEnergy.value, 'light_energy');
    });
  });

  group('Fridge scan §2.6 edge function config', () {
    test('scanFridgeVisionFunctionName matches Supabase function', () {
      expect(AppConfig.scanFridgeVisionFunctionName, 'scan-fridge-vision');
    });

    test('suggestRecipesFunctionName matches Supabase function', () {
      expect(AppConfig.suggestRecipesFunctionName, 'suggest-recipes');
    });
  });

  group('Rate limiting §2.6 basic tier', () {
    test('client and repository share monthly scan limit of 5', () {
      expect(FridgeScanRepository.basicMonthlyLimit, 5);
      expect(NutritionRepository.basicMonthlyLimit, 5);
    });

    test('FridgeScanLimitException identifies quota exhaustion', () {
      const ex = FridgeScanLimitException();
      expect(ex, isA<FridgeScanException>());
      expect(ex.message, contains('limit'));
    });
  });
}
