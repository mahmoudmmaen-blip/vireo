import 'package:flutter/foundation.dart';
import 'package:vireo/features/nutrition/domain/household_measures.dart';

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
    this.householdUnits = const [],
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
  final List<HouseholdUnitPortion> householdUnits;

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
        householdUnits: (json['household_units'] as List? ?? [])
            .whereType<Map>()
            .map((e) => HouseholdUnitPortion.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

  String displayName(String locale) => locale == 'ar' ? nameAr : nameEn;
}

enum FoodDatabaseSource {
  egyptianDb,
  usda,
  estimated,
  personalCalibrated;

  String label(String locale) {
    final isAr = locale.startsWith('ar');
    return switch (this) {
      FoodDatabaseSource.egyptianDb => isAr ? 'قاعدة بيانات' : 'Verified DB',
      FoodDatabaseSource.usda => 'USDA',
      FoodDatabaseSource.estimated => isAr ? 'تقدير' : 'Estimate',
      FoodDatabaseSource.personalCalibrated => isAr ? 'معدّلة على أكلك' : 'Personalized',
    };
  }
}

enum CookingMethod {
  boiled,
  grilled,
  fried,
  baked,
  raw,
  steamed,
  sauteed,
  oven,
  mahshi,
  airFried,
  other;

  static CookingMethod fromString(String? v) {
    if (v == null) return CookingMethod.other;
    final normalized = v.toLowerCase().replaceAll('-', '_');
    return switch (normalized) {
      'boiled' || 'مسلوق' => CookingMethod.boiled,
      'grilled' || 'مشوي' => CookingMethod.grilled,
      'fried' || 'مقلي' => CookingMethod.fried,
      'baked' || 'مخبوز' => CookingMethod.baked,
      'raw' || 'نيء' => CookingMethod.raw,
      'steamed' || 'بخار' => CookingMethod.steamed,
      'sauteed' || 'sautéed' || 'سوتيه' => CookingMethod.sauteed,
      'oven' || 'بالفرن' => CookingMethod.oven,
      'mahshi' || 'محشي' || 'مسبك' => CookingMethod.mahshi,
      'air_fried' || 'airfried' || 'قلاية_هوائية' => CookingMethod.airFried,
      _ => CookingMethod.other,
    };
  }

  /// Estimated oil absorption grams per 100g of food cooked
  double get oilAbsorptionGramsPer100g => switch (this) {
        CookingMethod.fried => 14.0,
        CookingMethod.sauteed => 5.0,
        CookingMethod.mahshi => 8.0,
        CookingMethod.baked || CookingMethod.oven => 3.0,
        CookingMethod.grilled => 2.0,
        CookingMethod.airFried => 1.5,
        CookingMethod.boiled ||
        CookingMethod.steamed ||
        CookingMethod.raw ||
        CookingMethod.other =>
          0.0,
      };

  String displayName(String locale) {
    final isAr = locale.startsWith('ar');
    return switch (this) {
      CookingMethod.boiled => isAr ? 'مسلوق' : 'Boiled',
      CookingMethod.grilled => isAr ? 'مشوي' : 'Grilled',
      CookingMethod.fried => isAr ? 'مقلي' : 'Fried',
      CookingMethod.baked => isAr ? 'مخبوز' : 'Baked',
      CookingMethod.raw => isAr ? 'طازج نيء' : 'Raw',
      CookingMethod.steamed => isAr ? 'على البخار' : 'Steamed',
      CookingMethod.sauteed => isAr ? 'سوتيه' : 'Sautéed',
      CookingMethod.oven => isAr ? 'بالفرن' : 'Oven',
      CookingMethod.mahshi => isAr ? 'محشي' : 'Mahshi',
      CookingMethod.airFried => isAr ? 'قلاية هوائية' : 'Air-fried',
      CookingMethod.other => isAr ? 'أخرى' : 'Other',
    };
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
    this.gramsLow,
    this.gramsHigh,
    this.visibleOilOrSauce = false,
  });

  final String nameAr;
  final String nameEn;
  final String? foodIdGuess;
  final double estimatedGrams;
  final CookingMethod cookingMethod;
  final double confidence;
  final bool isUnsure;
  final double? gramsLow;
  final double? gramsHigh;
  final bool visibleOilOrSauce;

  factory ScannedFoodItem.fromJson(Map<String, dynamic> json, {bool isUnsure = false}) {
    final estGrams = (json['estimated_grams'] as num?)?.toDouble() ??
        (json['grams_estimate'] as num?)?.toDouble() ??
        100;
    final low = (json['grams_low'] as num?)?.toDouble() ?? (estGrams * 0.85);
    final high = (json['grams_high'] as num?)?.toDouble() ?? (estGrams * 1.15);
    final oilOrSauce = json['visible_oil_or_sauce'] == true;

    return ScannedFoodItem(
      nameAr: json['name_ar']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      foodIdGuess: json['food_id_guess']?.toString() ?? json['food_db_id']?.toString(),
      estimatedGrams: estGrams,
      cookingMethod: CookingMethod.fromString(
        json['cooking_method']?.toString(),
      ),
      confidence: (json['confidence'] as num?)?.toDouble() ?? (isUnsure ? 0.4 : 0.5),
      isUnsure: isUnsure,
      gramsLow: low,
      gramsHigh: high,
      visibleOilOrSauce: oilOrSauce,
    );
  }
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
    this.source = FoodDatabaseSource.egyptianDb,
    this.gramsLow,
    this.gramsHigh,
    this.kcalLow,
    this.kcalHigh,
    this.hasVisibleOilOrSauce = false,
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
  final FoodDatabaseSource source;
  final double? gramsLow;
  final double? gramsHigh;
  final double? kcalLow;
  final double? kcalHigh;
  final bool hasVisibleOilOrSauce;

  double get displayKcalLow => kcalLow ?? (kcal * 0.88).roundToDouble();
  double get displayKcalHigh => kcalHigh ?? (kcal * 1.12).roundToDouble();

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
    FoodDatabaseSource? source,
    double? gramsLow,
    double? gramsHigh,
    double? kcalLow,
    double? kcalHigh,
    bool? hasVisibleOilOrSauce,
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
        source: source ?? this.source,
        gramsLow: gramsLow ?? this.gramsLow,
        gramsHigh: gramsHigh ?? this.gramsHigh,
        kcalLow: kcalLow ?? this.kcalLow,
        kcalHigh: kcalHigh ?? this.kcalHigh,
        hasVisibleOilOrSauce: hasVisibleOilOrSauce ?? this.hasVisibleOilOrSauce,
      );
}
