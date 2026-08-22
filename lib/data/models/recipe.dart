import 'package:vireo/data/models/meal_type.dart';

class Recipe {
  const Recipe({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.prepTimeMinutes,
    required this.goalTag,
    required this.mealType,
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.cuisineTag,
    this.dietaryTags = const [],
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final int prepTimeMinutes;
  final RecipeGoalTag goalTag;
  final MealType mealType;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final String? cuisineTag;
  final List<String> dietaryTags;

  bool get isQuick => prepTimeMinutes <= 10;
  bool get isHighProtein => proteinG >= 20 || goalTag == RecipeGoalTag.highProtein;
  bool get isLowCalorie => calories > 0 && calories < 350;

  String localizedTitle(String languageCode) {
    if (languageCode == 'ar') {
      return titleAr
          .replaceAll('بروtein', 'بروتين')
          .replaceAll('Protein', 'بروتين')
          .replaceAll('protein', 'بروتين');
    }
    return titleEn;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      prepTimeMinutes: json['prep_time_minutes'] as int? ?? 15,
      goalTag: RecipeGoalTag.fromValue(json['goal_tag'] as String? ?? 'quick_easy'),
      mealType: MealType.fromValue(json['meal_type'] as String? ?? 'breakfast'),
      calories: json['calories'] as int? ?? 0,
      proteinG: json['protein_g'] as int? ?? 0,
      carbsG: json['carbs_g'] as int? ?? 0,
      fatG: json['fat_g'] as int? ?? 0,
      cuisineTag: json['cuisine_tag'] as String?,
      dietaryTags: List<String>.from(json['dietary_tags'] as List? ?? []),
    );
  }
}

class MealPlanEntry {
  const MealPlanEntry({
    required this.id,
    required this.mealType,
    required this.recipe,
    required this.dayIndex,
    required this.weekNumber,
  });

  final String id;
  final MealType mealType;
  final Recipe recipe;
  final int dayIndex;
  final int weekNumber;

  factory MealPlanEntry.fromJson(Map<String, dynamic> json) {
    final recipeJson = json['recipes'] ?? json['recipe'];
    return MealPlanEntry(
      id: json['id'] as String? ?? '',
      mealType: MealType.fromValue(json['meal_type'] as String),
      recipe: Recipe.fromJson(Map<String, dynamic>.from(recipeJson as Map)),
      dayIndex: json['day_index'] as int,
      weekNumber: json['week_number'] as int,
    );
  }
}
