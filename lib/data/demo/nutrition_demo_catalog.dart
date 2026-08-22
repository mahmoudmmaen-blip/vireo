import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';

/// Full offline meal catalog (15 recipes) for demo mode.
abstract final class NutritionDemoCatalog {
  static const demoFridgeIngredients = ['بيض', 'طماطم', 'جبنة', 'خيار'];
  static const demoScanId = 'demo-fridge-scan';

  static Recipe _r({
    required String id,
    required String en,
    required String ar,
    required MealType type,
    required int cal,
    required int protein,
    required int carbs,
    required int fat,
    required int prep,
    required RecipeGoalTag tag,
  }) =>
      Recipe(
        id: id,
        titleEn: en,
        titleAr: ar,
        mealType: type,
        calories: cal,
        proteinG: protein,
        carbsG: carbs,
        fatG: fat,
        prepTimeMinutes: prep,
        goalTag: tag,
      );

  static final List<Recipe> recipes = [
    // Breakfast (4)
    _r(id: 'demo-b1', en: 'Egg & Cheese Omelette', ar: 'أومليت بيض وجبنة', type: MealType.breakfast, cal: 320, protein: 22, carbs: 4, fat: 24, prep: 10, tag: RecipeGoalTag.highProtein),
    _r(id: 'demo-b2', en: 'Oats with Banana & Nuts', ar: 'شوفان بالموز والمكسرات', type: MealType.breakfast, cal: 410, protein: 12, carbs: 58, fat: 14, prep: 5, tag: RecipeGoalTag.quickEasy),
    _r(id: 'demo-b3', en: 'Greek Yogurt & Berries', ar: 'زبادي يوناني + توت', type: MealType.breakfast, cal: 280, protein: 18, carbs: 32, fat: 8, prep: 3, tag: RecipeGoalTag.quickEasy),
    _r(id: 'demo-b4', en: 'Fava Beans with Oil', ar: 'فول مدمس بالزيت', type: MealType.breakfast, cal: 350, protein: 15, carbs: 42, fat: 12, prep: 5, tag: RecipeGoalTag.lightEnergy),
    // Lunch (4)
    _r(id: 'demo-l1', en: 'Grilled Chicken Breast', ar: 'صدر دجاج مشوي', type: MealType.lunch, cal: 520, protein: 45, carbs: 28, fat: 18, prep: 25, tag: RecipeGoalTag.highProtein),
    _r(id: 'demo-l2', en: 'Grilled Fish & Brown Rice', ar: 'سمك مشوي + أرز بني', type: MealType.lunch, cal: 480, protein: 38, carbs: 45, fat: 12, prep: 30, tag: RecipeGoalTag.highProtein),
    _r(id: 'demo-l3', en: 'Grilled Kofta & Salad', ar: 'كفتة مشوية + سلطة', type: MealType.lunch, cal: 550, protein: 35, carbs: 22, fat: 32, prep: 20, tag: RecipeGoalTag.highProtein),
    _r(id: 'demo-l4', en: 'Lentil Soup & Bread', ar: 'شوربة عدس + خبز', type: MealType.lunch, cal: 380, protein: 18, carbs: 52, fat: 8, prep: 35, tag: RecipeGoalTag.lightEnergy),
    // Dinner (3)
    _r(id: 'demo-d1', en: 'Tuna with Vegetables', ar: 'تونة بالخضار', type: MealType.dinner, cal: 380, protein: 30, carbs: 18, fat: 16, prep: 10, tag: RecipeGoalTag.highProtein),
    _r(id: 'demo-d2', en: 'Boiled Eggs & Avocado', ar: 'بيض مسلوق + أفوكادو', type: MealType.dinner, cal: 340, protein: 20, carbs: 12, fat: 24, prep: 5, tag: RecipeGoalTag.quickEasy),
    _r(id: 'demo-d3', en: 'Chicken Caesar Salad', ar: 'سلطة دجاج سيزر', type: MealType.dinner, cal: 420, protein: 32, carbs: 16, fat: 26, prep: 15, tag: RecipeGoalTag.highProtein),
    // Snack (4)
    _r(id: 'demo-s1', en: 'Apple & Peanut Butter', ar: 'تفاح + زبدة فول سوداني', type: MealType.snack, cal: 200, protein: 6, carbs: 24, fat: 10, prep: 2, tag: RecipeGoalTag.lightEnergy),
    _r(id: 'demo-s2', en: 'Mixed Nuts (30g)', ar: 'مكسرات مختلطة (30g)', type: MealType.snack, cal: 180, protein: 5, carbs: 6, fat: 16, prep: 1, tag: RecipeGoalTag.lightEnergy),
    _r(id: 'demo-s3', en: 'Protein Bar', ar: 'بروتين بار', type: MealType.snack, cal: 220, protein: 20, carbs: 22, fat: 8, prep: 1, tag: RecipeGoalTag.highProtein),
    _r(id: 'demo-s4', en: 'White Cheese & Cucumber', ar: 'جبنة بيضا + خيار', type: MealType.snack, cal: 150, protein: 12, carbs: 4, fat: 10, prep: 2, tag: RecipeGoalTag.quickEasy),
  ];

  static List<Recipe> fridgeQuickMeals = [
    recipes.firstWhere((r) => r.id == 'demo-b1'),
    recipes.firstWhere((r) => r.id == 'demo-l1'),
    recipes.firstWhere((r) => r.id == 'demo-d1'),
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
        .toList();
  }

  static List<Recipe> filterAlternatives(
    List<Recipe> items,
    String filterKey,
  ) {
    return switch (filterKey) {
      'quick' => items.where((r) => r.isQuick).toList(),
      'protein' => items.where((r) => r.isHighProtein).toList(),
      'low_cal' => items.where((r) => r.isLowCalorie).toList(),
      _ => items,
    };
  }
}
