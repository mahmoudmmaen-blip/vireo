import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/demo/nutrition_demo_catalog.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';

void main() {
  group('Nutrition demo catalog', () {
    test('breakfast primary title is fully Arabic', () {
      final recipe = NutritionDemoCatalog.primaryFor(MealType.breakfast);
      expect(recipe.titleAr, 'شوفان بالبروتين');
      expect(recipe.titleAr, isNot(contains('tein')));
    });

    test('swap alternatives return up to 3 meals per type', () {
      const repo = MealPlanRepository();
      final alts = repo.demoAlternativesFor(
        MealType.breakfast,
        excludeRecipeId: 'demo-b1',
      );
      expect(alts, isNotEmpty);
      expect(alts.length, lessThanOrEqualTo(3));
    });

    test('localizedTitle normalizes mixed protein fragments', () {
      const recipe = Recipe(
        id: 'x',
        titleEn: 'Oats',
        titleAr: 'شوفان بالبروtein',
        prepTimeMinutes: 10,
        goalTag: RecipeGoalTag.highProtein,
        mealType: MealType.breakfast,
      );
      expect(recipe.localizedTitle('ar'), 'شوفان بالبروتين');
    });
  });
}
