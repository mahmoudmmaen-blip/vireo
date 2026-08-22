import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';

void main() {
  group('Arabic recipe titles', () {
    test('demo meal plan breakfast title has no Latin protein fragment', () async {
      const repo = MealPlanRepository();
      final meals = await repo.fetchTodayMeals();
      final breakfast = meals.firstWhere((m) => m.mealType == MealType.breakfast);

      expect(breakfast.recipe.titleAr, 'شوفان بالزبادي والموز');
      expect(breakfast.recipe.titleAr, isNot(contains('tein')));
      expect(breakfast.recipe.titleAr, isNot(contains('Protein')));
    });

    test('demo recipe suggestions use fully Arabic titles', () async {
      const repo = NutritionRepository();
      final recipes = await repo.suggestRecipes(ingredients: ['chicken']);

      for (final recipe in recipes) {
        expect(recipe.titleAr, isNot(contains('tein')));
        expect(recipe.titleAr, isNot(contains('Protein')));
      }
    });
  });
}
