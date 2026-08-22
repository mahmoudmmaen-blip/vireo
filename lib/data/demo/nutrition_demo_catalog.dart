import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';

/// Offline demo meals, swap alternatives, and fridge-scan suggestions.
abstract final class NutritionDemoCatalog {
  static const demoFridgeIngredients = [
    'بيض',
    'طماطم',
    'جبنة',
    'خيار',
  ];

  static const demoScanId = 'demo-fridge-scan';

  static final List<Recipe> recipes = [
    Recipe(
      id: 'demo-b1',
      titleEn: 'Protein Oats Bowl',
      titleAr: 'شوفان بالبروتين',
      prepTimeMinutes: 10,
      goalTag: RecipeGoalTag.highProtein,
      mealType: MealType.breakfast,
    ),
    Recipe(
      id: 'demo-b2',
      titleEn: 'Yogurt & Fruit',
      titleAr: 'زبادي بالفاكهة',
      prepTimeMinutes: 5,
      goalTag: RecipeGoalTag.quickEasy,
      mealType: MealType.breakfast,
    ),
    Recipe(
      id: 'demo-b3',
      titleEn: 'Veggie Omelette',
      titleAr: 'أومлет خضار سريع',
      prepTimeMinutes: 12,
      goalTag: RecipeGoalTag.quickEasy,
      mealType: MealType.breakfast,
    ),
    Recipe(
      id: 'demo-l1',
      titleEn: 'Grilled Chicken Plate',
      titleAr: 'طبق دجاج مشوي',
      prepTimeMinutes: 25,
      goalTag: RecipeGoalTag.highProtein,
      mealType: MealType.lunch,
    ),
    Recipe(
      id: 'demo-l2',
      titleEn: 'Chickpea Salad Bowl',
      titleAr: 'سلطة حمص',
      prepTimeMinutes: 15,
      goalTag: RecipeGoalTag.quickEasy,
      mealType: MealType.lunch,
    ),
    Recipe(
      id: 'demo-l3',
      titleEn: 'Tuna Rice Bowl',
      titleAr: 'طبق تونة بالأرز',
      prepTimeMinutes: 18,
      goalTag: RecipeGoalTag.highProtein,
      mealType: MealType.lunch,
    ),
    Recipe(
      id: 'demo-d1',
      titleEn: 'Chickpea Salad',
      titleAr: 'سلطة حمص',
      prepTimeMinutes: 15,
      goalTag: RecipeGoalTag.quickEasy,
      mealType: MealType.dinner,
    ),
    Recipe(
      id: 'demo-d2',
      titleEn: 'Light Lentil Soup',
      titleAr: 'شوربة عدس خفيفة',
      prepTimeMinutes: 25,
      goalTag: RecipeGoalTag.lightEnergy,
      mealType: MealType.dinner,
    ),
    Recipe(
      id: 'demo-d3',
      titleEn: 'Grilled Fish & Greens',
      titleAr: 'سمك مشوي مع خضار',
      prepTimeMinutes: 22,
      goalTag: RecipeGoalTag.highProtein,
      mealType: MealType.dinner,
    ),
    Recipe(
      id: 'demo-s1',
      titleEn: 'Greek Yogurt & Fruit',
      titleAr: 'زبادي وفاكهة',
      prepTimeMinutes: 5,
      goalTag: RecipeGoalTag.quickEasy,
      mealType: MealType.snack,
    ),
    Recipe(
      id: 'demo-s2',
      titleEn: 'Mixed Nuts',
      titleAr: 'مكسرات مشكلة',
      prepTimeMinutes: 2,
      goalTag: RecipeGoalTag.lightEnergy,
      mealType: MealType.snack,
    ),
    Recipe(
      id: 'demo-s3',
      titleEn: 'Hummus & Veggies',
      titleAr: 'حمص مع خضار',
      prepTimeMinutes: 8,
      goalTag: RecipeGoalTag.quickEasy,
      mealType: MealType.snack,
    ),
  ];

  static List<Recipe> fridgeQuickMeals = [
    recipes.firstWhere((r) => r.id == 'demo-b3'),
    recipes.firstWhere((r) => r.id == 'demo-l3'),
    recipes.firstWhere((r) => r.id == 'demo-d2'),
  ];

  static Recipe primaryFor(MealType type) {
    return recipes.firstWhere((r) => r.mealType == type && r.id.endsWith('1'));
  }

  static List<Recipe> alternativesFor(
    MealType type, {
    required String excludeRecipeId,
  }) {
    return recipes
        .where((r) => r.mealType == type && r.id != excludeRecipeId)
        .take(3)
        .toList();
  }
}
