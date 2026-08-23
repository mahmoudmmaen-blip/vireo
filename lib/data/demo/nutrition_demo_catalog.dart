import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';

/// Full offline meal catalog (50 recipes) for demo mode.
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
    String? cuisine,
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
        cuisineTag: cuisine,
      );

  static final List<Recipe> recipes = [
    // Breakfast (12)
    _r(id: 'demo-b1', en: 'Egg & Cheese Omelette', ar: 'أومليت بيض وجبنة', type: MealType.breakfast, cal: 320, protein: 22, carbs: 4, fat: 24, prep: 10, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-b2', en: 'Oats with Banana & Nuts', ar: 'شوفان بالموز والمكسرات', type: MealType.breakfast, cal: 410, protein: 12, carbs: 58, fat: 14, prep: 5, tag: RecipeGoalTag.quickEasy, cuisine: 'international'),
    _r(id: 'demo-b3', en: 'Fava Beans with Oil', ar: 'فول مدمس بالزيت', type: MealType.breakfast, cal: 350, protein: 15, carbs: 42, fat: 12, prep: 5, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-b4', en: 'Falafel with Tahini', ar: 'فلافل بالطحينة', type: MealType.breakfast, cal: 380, protein: 14, carbs: 40, fat: 18, prep: 15, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-b5', en: 'Keto Waffle', ar: 'وافل كيتو', type: MealType.breakfast, cal: 290, protein: 18, carbs: 6, fat: 22, prep: 12, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-b6', en: 'Boiled Eggs (3)', ar: 'بيض مسلوق (3)', type: MealType.breakfast, cal: 210, protein: 18, carbs: 2, fat: 14, prep: 8, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-b7', en: 'Bread with Natural Butter', ar: 'خبز بزبدة طبيعية', type: MealType.breakfast, cal: 280, protein: 8, carbs: 32, fat: 14, prep: 3, tag: RecipeGoalTag.quickEasy, cuisine: 'arabic'),
    _r(id: 'demo-b8', en: 'Fruit & Nuts Bowl', ar: 'فاكهة ومكسرات', type: MealType.breakfast, cal: 320, protein: 8, carbs: 38, fat: 16, prep: 5, tag: RecipeGoalTag.lightEnergy, cuisine: 'mediterranean'),
    _r(id: 'demo-b9', en: 'Cottage Cheese Bowl', ar: 'جبنة قريش', type: MealType.breakfast, cal: 250, protein: 24, carbs: 10, fat: 10, prep: 3, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-b10', en: 'Protein Pancake', ar: 'بان كيك بروتين', type: MealType.breakfast, cal: 360, protein: 28, carbs: 30, fat: 12, prep: 15, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-b11', en: 'Muesli with Milk', ar: 'ميوسلي بالحليب', type: MealType.breakfast, cal: 390, protein: 12, carbs: 55, fat: 12, prep: 5, tag: RecipeGoalTag.quickEasy, cuisine: 'international'),
    _r(id: 'demo-b12', en: 'Dates with Milk', ar: 'تمر بالحليب', type: MealType.breakfast, cal: 300, protein: 8, carbs: 48, fat: 8, prep: 2, tag: RecipeGoalTag.quickEasy, cuisine: 'arabic'),

    // Lunch (15)
    _r(id: 'demo-l1', en: 'Grilled Chicken Breast', ar: 'صدر دجاج مشوي', type: MealType.lunch, cal: 520, protein: 45, carbs: 28, fat: 18, prep: 25, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-l2', en: 'Grilled Fish & Brown Rice', ar: 'سمك مشوي + أرز بني', type: MealType.lunch, cal: 480, protein: 38, carbs: 45, fat: 12, prep: 30, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),
    _r(id: 'demo-l3', en: 'Grilled Kofta & Salad', ar: 'كفتة مشوية + سلطة', type: MealType.lunch, cal: 550, protein: 35, carbs: 22, fat: 32, prep: 20, tag: RecipeGoalTag.highProtein, cuisine: 'arabic'),
    _r(id: 'demo-l4', en: 'Grilled Meat Platter', ar: 'لحم مشوي', type: MealType.lunch, cal: 620, protein: 42, carbs: 18, fat: 38, prep: 30, tag: RecipeGoalTag.highProtein, cuisine: 'arabic'),
    _r(id: 'demo-l5', en: 'Rice with Mixed Vegetables', ar: 'أرز بالخضار', type: MealType.lunch, cal: 420, protein: 10, carbs: 68, fat: 10, prep: 25, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-l6', en: 'Tuna Pasta', ar: 'مكرونة بالتونة', type: MealType.lunch, cal: 510, protein: 32, carbs: 55, fat: 16, prep: 20, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),
    _r(id: 'demo-l7', en: 'Chicken Soup', ar: 'شوربة دجاج', type: MealType.lunch, cal: 280, protein: 22, carbs: 18, fat: 12, prep: 35, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-l8', en: 'Lentil Soup & Bread', ar: 'شوربة عدس + خبز', type: MealType.lunch, cal: 380, protein: 18, carbs: 52, fat: 8, prep: 35, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-l9', en: 'Boiled Chicken & Veggies', ar: 'دجاج مسلوق بالخضار', type: MealType.lunch, cal: 400, protein: 40, carbs: 20, fat: 14, prep: 40, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-l10', en: 'Niçoise Salad', ar: 'سلطة نيواز', type: MealType.lunch, cal: 420, protein: 28, carbs: 22, fat: 24, prep: 20, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),
    _r(id: 'demo-l11', en: 'Beef Burger', ar: 'برجر لحم', type: MealType.lunch, cal: 580, protein: 32, carbs: 42, fat: 30, prep: 20, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-l12', en: 'Fattah', ar: 'فتة', type: MealType.lunch, cal: 560, protein: 28, carbs: 55, fat: 22, prep: 30, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-l13', en: 'Molokhia with Rice', ar: 'ملوخية بالأرز', type: MealType.lunch, cal: 480, protein: 26, carbs: 52, fat: 16, prep: 40, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-l14', en: 'Harissa (Wheat Stew)', ar: 'هريسة', type: MealType.lunch, cal: 450, protein: 16, carbs: 60, fat: 14, prep: 45, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-l15', en: 'Vegetable Maqluba', ar: 'مقلوبة خضار', type: MealType.lunch, cal: 440, protein: 12, carbs: 62, fat: 16, prep: 45, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),

    // Dinner (12)
    _r(id: 'demo-d1', en: 'Tuna with Vegetables', ar: 'تونة بالخضار', type: MealType.dinner, cal: 380, protein: 30, carbs: 18, fat: 16, prep: 10, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),
    _r(id: 'demo-d2', en: 'Boiled Eggs & Avocado', ar: 'بيض مسلوق + أفوكادو', type: MealType.dinner, cal: 340, protein: 20, carbs: 12, fat: 24, prep: 5, tag: RecipeGoalTag.quickEasy, cuisine: 'international'),
    _r(id: 'demo-d3', en: 'Grilled Salmon', ar: 'سلمون مشوي', type: MealType.dinner, cal: 450, protein: 36, carbs: 8, fat: 28, prep: 20, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-d4', en: 'Vegetable Soup', ar: 'شوربة خضار', type: MealType.dinner, cal: 180, protein: 6, carbs: 28, fat: 4, prep: 25, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-d5', en: 'Laban with Cucumber', ar: 'لبن بالخيار', type: MealType.dinner, cal: 160, protein: 10, carbs: 12, fat: 8, prep: 5, tag: RecipeGoalTag.quickEasy, cuisine: 'arabic'),
    _r(id: 'demo-d6', en: 'Green Salad', ar: 'سلطة خضراء', type: MealType.dinner, cal: 150, protein: 4, carbs: 14, fat: 10, prep: 8, tag: RecipeGoalTag.lightEnergy, cuisine: 'mediterranean'),
    _r(id: 'demo-d7', en: 'Chicken Fajita', ar: 'فاهيتا دجاج', type: MealType.dinner, cal: 480, protein: 38, carbs: 32, fat: 20, prep: 25, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-d8', en: 'Chicken Shawarma Plate', ar: 'شاورما دجاج', type: MealType.dinner, cal: 520, protein: 36, carbs: 40, fat: 22, prep: 20, tag: RecipeGoalTag.highProtein, cuisine: 'arabic'),
    _r(id: 'demo-d9', en: 'Paratha with Yogurt', ar: 'باراثا مع زبادي', type: MealType.dinner, cal: 400, protein: 12, carbs: 48, fat: 18, prep: 20, tag: RecipeGoalTag.lightEnergy, cuisine: 'international'),
    _r(id: 'demo-d10', en: 'Vegetable Tagine', ar: 'طاجين خضار', type: MealType.dinner, cal: 320, protein: 10, carbs: 42, fat: 12, prep: 40, tag: RecipeGoalTag.lightEnergy, cuisine: 'arabic'),
    _r(id: 'demo-d11', en: 'Cooked Fish Fillet', ar: 'سمك مطبوخ', type: MealType.dinner, cal: 410, protein: 34, carbs: 16, fat: 20, prep: 30, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),
    _r(id: 'demo-d12', en: 'Lemon Chicken Breast', ar: 'صدر دجاج بالليمون', type: MealType.dinner, cal: 360, protein: 40, carbs: 8, fat: 16, prep: 25, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),

    // Snack (11)
    _r(id: 'demo-s1', en: 'Fresh Fruit Bowl', ar: 'طبق فاكهة', type: MealType.snack, cal: 120, protein: 2, carbs: 28, fat: 0, prep: 2, tag: RecipeGoalTag.lightEnergy, cuisine: 'international'),
    _r(id: 'demo-s2', en: 'Mixed Nuts (30g)', ar: 'مكسرات مختلطة (30g)', type: MealType.snack, cal: 180, protein: 5, carbs: 6, fat: 16, prep: 1, tag: RecipeGoalTag.lightEnergy, cuisine: 'mediterranean'),
    _r(id: 'demo-s3', en: 'Protein Bar', ar: 'بروتين بار', type: MealType.snack, cal: 220, protein: 20, carbs: 22, fat: 8, prep: 1, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-s4', en: 'Greek Yogurt', ar: 'زبادي يوناني', type: MealType.snack, cal: 140, protein: 14, carbs: 10, fat: 4, prep: 1, tag: RecipeGoalTag.highProtein, cuisine: 'mediterranean'),
    _r(id: 'demo-s5', en: 'Hummus with Vegetables', ar: 'حمص مع خضار', type: MealType.snack, cal: 200, protein: 8, carbs: 18, fat: 12, prep: 5, tag: RecipeGoalTag.quickEasy, cuisine: 'arabic'),
    _r(id: 'demo-s6', en: 'Dates (4 pieces)', ar: 'تمر (4 حبات)', type: MealType.snack, cal: 110, protein: 1, carbs: 28, fat: 0, prep: 1, tag: RecipeGoalTag.quickEasy, cuisine: 'arabic'),
    _r(id: 'demo-s7', en: 'White Cheese & Cucumber', ar: 'جبنة بيضا + خيار', type: MealType.snack, cal: 150, protein: 12, carbs: 4, fat: 10, prep: 2, tag: RecipeGoalTag.quickEasy, cuisine: 'arabic'),
    _r(id: 'demo-s8', en: 'Rice Cake with Peanut Butter', ar: 'كعكة أرز بزبدة فول سوداني', type: MealType.snack, cal: 160, protein: 5, carbs: 18, fat: 8, prep: 2, tag: RecipeGoalTag.quickEasy, cuisine: 'international'),
    _r(id: 'demo-s9', en: 'Boiled Egg', ar: 'بيضة مسلوقة', type: MealType.snack, cal: 70, protein: 6, carbs: 1, fat: 5, prep: 8, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-s10', en: 'Edamame', ar: 'إدامامي', type: MealType.snack, cal: 130, protein: 12, carbs: 10, fat: 5, prep: 5, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
    _r(id: 'demo-s11', en: 'Protein Smoothie', ar: 'سموثي بروتين', type: MealType.snack, cal: 250, protein: 22, carbs: 28, fat: 6, prep: 5, tag: RecipeGoalTag.highProtein, cuisine: 'international'),
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
