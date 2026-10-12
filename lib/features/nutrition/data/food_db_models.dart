import 'package:flutter/foundation.dart';

@immutable
class FoodPortion {
  const FoodPortion({
    required this.nameAr,
    required this.nameEn,
    required this.grams,
  });

  final String nameAr;
  final String nameEn;
  final double grams;

  factory FoodPortion.fromJson(Map<String, dynamic> json) => FoodPortion(
        nameAr: json['name_ar']?.toString() ?? '',
        nameEn: json['name_en']?.toString() ?? '',
        grams: (json['grams'] as num?)?.toDouble() ?? 0,
      );

  String label(String locale) => locale == 'ar' ? nameAr : nameEn;
}

@immutable
class FoodMacros100g {
  const FoodMacros100g({
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  factory FoodMacros100g.fromJson(Map<String, dynamic> json) => FoodMacros100g(
        kcal: (json['kcal'] as num?)?.toDouble() ?? 0,
        protein: (json['protein'] as num?)?.toDouble() ?? 0,
        carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
        fat: (json['fat'] as num?)?.toDouble() ?? 0,
        fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
      );
}

@immutable
class FoodSource {
  const FoodSource({required this.name, required this.fdcId});
  final String name;
  final int fdcId;

  factory FoodSource.fromJson(Map<String, dynamic> json) => FoodSource(
        name: json['name']?.toString() ?? '',
        fdcId: (json['fdc_id'] as num?)?.toInt() ?? 0,
      );
}

@immutable
class FoodItem {
  const FoodItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.aliases,
    required this.per100g,
    required this.state,
    required this.commonPortions,
    required this.source,
    this.barcodes = const [],
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final List<String> aliases;
  final FoodMacros100g per100g;
  final String state;
  final List<FoodPortion> commonPortions;
  final FoodSource source;
  final List<String> barcodes;

  bool get isAlreadyFried => state == 'fried';

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id']?.toString() ?? '',
        nameAr: json['name_ar']?.toString() ?? '',
        nameEn: json['name_en']?.toString() ?? '',
        aliases: (json['aliases'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        per100g: FoodMacros100g.fromJson(
          Map<String, dynamic>.from(json['per_100g'] as Map? ?? {}),
        ),
        state: json['state']?.toString() ?? 'raw',
        commonPortions: (json['common_portions'] as List? ?? [])
            .whereType<Map>()
            .map((e) => FoodPortion.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        source: FoodSource.fromJson(
          Map<String, dynamic>.from(json['source'] as Map? ?? {}),
        ),
        barcodes: (json['barcodes'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
      );

  String displayName(String locale) => locale == 'ar' ? nameAr : nameEn;
}

enum CookingMethod {
  boiled,
  grilled,
  fried,
  baked,
  raw,
  steamed,
  other;

  static CookingMethod fromString(String? v) {
    return CookingMethod.values.firstWhere(
      (e) => e.name == v,
      orElse: () => CookingMethod.other,
    );
  }
}

@immutable
class ScannedFoodItem {
  const ScannedFoodItem({
    required this.nameAr,
    required this.nameEn,
    this.foodIdGuess,
    required this.estimatedGrams,
    required this.cookingMethod,
    required this.confidence,
    this.isUnsure = false,
  });

  final String nameAr;
  final String nameEn;
  final String? foodIdGuess;
  final double estimatedGrams;
  final CookingMethod cookingMethod;
  final double confidence;
  final bool isUnsure;

  factory ScannedFoodItem.fromJson(Map<String, dynamic> json, {bool isUnsure = false}) =>
      ScannedFoodItem(
        nameAr: json['name_ar']?.toString() ?? '',
        nameEn: json['name_en']?.toString() ?? '',
        foodIdGuess: json['food_id_guess']?.toString(),
        estimatedGrams: (json['estimated_grams'] as num?)?.toDouble() ?? 100,
        cookingMethod: CookingMethod.fromString(
          json['cooking_method']?.toString(),
        ),
        confidence: (json['confidence'] as num?)?.toDouble() ?? (isUnsure ? 0.4 : 0.5),
        isUnsure: isUnsure,
      );
}

@immutable
class ResolvedMealLine {
  const ResolvedMealLine({
    required this.nameAr,
    required this.nameEn,
    required this.grams,
    required this.cookingMethod,
    required this.confidence,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.food,
    this.isEstimated = false,
    this.portions = const [],
    this.isUnsure = false,
  });

  final String nameAr;
  final String nameEn;
  final double grams;
  final CookingMethod cookingMethod;
  final double confidence;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final FoodItem? food;
  final bool isEstimated;
  final List<FoodPortion> portions;
  final bool isUnsure;

  ResolvedMealLine copyWith({
    String? nameAr,
    String? nameEn,
    double? grams,
    CookingMethod? cookingMethod,
    double? confidence,
    double? kcal,
    double? protein,
    double? carbs,
    double? fat,
    FoodItem? food,
    bool? isEstimated,
    List<FoodPortion>? portions,
    bool? isUnsure,
  }) =>
      ResolvedMealLine(
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        grams: grams ?? this.grams,
        cookingMethod: cookingMethod ?? this.cookingMethod,
        confidence: confidence ?? this.confidence,
        kcal: kcal ?? this.kcal,
        protein: protein ?? this.protein,
        carbs: carbs ?? this.carbs,
        fat: fat ?? this.fat,
        food: food ?? this.food,
        isEstimated: isEstimated ?? this.isEstimated,
        portions: portions ?? this.portions,
        isUnsure: isUnsure ?? this.isUnsure,
      );
}
