import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/domain/household_measures.dart';

/// A single meal suggestion item with portion and computed macros.
@immutable
class SuggestedMealComponent {
  const SuggestedMealComponent({
    required this.food,
    required this.grams,
    required this.householdDescription,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final FoodItem food;
  final double grams;
  final String householdDescription;
  final int kcal;
  final double protein;
  final double carbs;
  final double fat;
}

/// A complete meal combination suggestion for the next meal slot.
@immutable
class MealSuggestion {
  const MealSuggestion({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.components,
    required this.totalKcal,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.isLightSnackOnly,
    required this.targetSlot,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final List<SuggestedMealComponent> components;
  final int totalKcal;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final bool isLightSnackOnly;
  final MealType targetSlot;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  /// Line items description formatted with household measures
  String componentsDescription(bool isArabic) {
    return components.map((c) => c.householdDescription).join(' + ');
  }
}

/// Deterministic local meal suggester ("اقترح وجبة") using bundled food DB.
abstract final class MealSuggester {
  /// Simple preferred home staples with their target portions and food match keys.
  static const List<({
    String key,
    String idGuess,
    String nameAr,
    String nameEn,
    double defaultGrams,
    double pPer100g,
    double cPer100g,
    double fPer100g,
    double kcalPer100g,
    bool isProtein,
    bool isCarb,
    bool isVeggie,
    bool isSnack,
  })> _staples = [
    // Proteins
    (
      key: 'grilled_chicken',
      idGuess: 'chicken_breast_grilled',
      nameAr: 'صدر فراخ مشوي',
      nameEn: 'Grilled chicken breast',
      defaultGrams: 110,
      pPer100g: 31.0,
      cPer100g: 0.0,
      fPer100g: 3.6,
      kcalPer100g: 165.0,
      isProtein: true,
      isCarb: false,
      isVeggie: false,
      isSnack: false,
    ),
    (
      key: 'canned_tuna',
      idGuess: 'tuna_canned',
      nameAr: 'تونا مصفاة',
      nameEn: 'Canned tuna in water',
      defaultGrams: 140,
      pPer100g: 26.0,
      cPer100g: 0.0,
      fPer100g: 1.0,
      kcalPer100g: 116.0,
      isProtein: true,
      isCarb: false,
      isVeggie: false,
      isSnack: false,
    ),
    (
      key: 'boiled_eggs',
      idGuess: 'egg_boiled',
      nameAr: 'بيض مسلوق',
      nameEn: 'Boiled eggs',
      defaultGrams: 100, // 2 eggs
      pPer100g: 12.6,
      cPer100g: 1.1,
      fPer100g: 10.6,
      kcalPer100g: 155.0,
      isProtein: true,
      isCarb: false,
      isVeggie: false,
      isSnack: true,
    ),
    (
      key: 'greek_yogurt',
      idGuess: 'greek_yogurt',
      nameAr: 'زبادي يوناني',
      nameEn: 'Greek yogurt',
      defaultGrams: 170,
      pPer100g: 10.0,
      cPer100g: 3.6,
      fPer100g: 0.4,
      kcalPer100g: 59.0,
      isProtein: true,
      isCarb: false,
      isVeggie: false,
      isSnack: true,
    ),
    (
      key: 'cottage_cheese',
      idGuess: 'cottage_cheese',
      nameAr: 'جبنة قريش',
      nameEn: 'Cottage cheese',
      defaultGrams: 150,
      pPer100g: 11.1,
      cPer100g: 3.4,
      fPer100g: 4.3,
      kcalPer100g: 98.0,
      isProtein: true,
      isCarb: false,
      isVeggie: false,
      isSnack: true,
    ),
    (
      key: 'lentils',
      idGuess: 'lentils_cooked',
      nameAr: 'شوربة عدس أصفر',
      nameEn: 'Lentil soup',
      defaultGrams: 200,
      pPer100g: 9.0,
      cPer100g: 20.0,
      fPer100g: 1.5,
      kcalPer100g: 130.0,
      isProtein: true,
      isCarb: true,
      isVeggie: false,
      isSnack: false,
    ),
    (
      key: 'ful_medames',
      idGuess: 'ful_medames_plain',
      nameAr: 'فول مدمس بزيت خفيف',
      nameEn: 'Ful medames',
      defaultGrams: 200,
      pPer100g: 7.5,
      cPer100g: 17.0,
      fPer100g: 2.5,
      kcalPer100g: 120.0,
      isProtein: true,
      isCarb: true,
      isVeggie: false,
      isSnack: false,
    ),

    // Carbs
    (
      key: 'white_rice',
      idGuess: 'white_rice_cooked',
      nameAr: 'أرز مطبوخ',
      nameEn: 'Cooked rice',
      defaultGrams: 160, // 1 cup
      pPer100g: 2.7,
      cPer100g: 28.0,
      fPer100g: 0.3,
      kcalPer100g: 130.0,
      isProtein: false,
      isCarb: true,
      isVeggie: false,
      isSnack: false,
    ),
    (
      key: 'baladi_bread',
      idGuess: 'baladi_bread',
      nameAr: 'عيش بلدي',
      nameEn: 'Baladi bread',
      defaultGrams: 90, // 1 loaf
      pPer100g: 8.9,
      cPer100g: 52.0,
      fPer100g: 3.0,
      kcalPer100g: 266.0,
      isProtein: false,
      isCarb: true,
      isVeggie: false,
      isSnack: false,
    ),

    // Veggies
    (
      key: 'green_salad',
      idGuess: 'salad_green',
      nameAr: 'سلطة خضراء بلدي',
      nameEn: 'Green salad',
      defaultGrams: 150,
      pPer100g: 1.2,
      cPer100g: 4.5,
      fPer100g: 0.2,
      kcalPer100g: 25.0,
      isProtein: false,
      isCarb: false,
      isVeggie: true,
      isSnack: false,
    ),
  ];

  /// Generate 2–3 deterministic meal suggestions fitting the remaining kcal and macros.
  static List<MealSuggestion> suggestNextMeal({
    required int remainingKcal,
    required double remainingProtein,
    required double remainingCarbs,
    required double remainingFat,
    required MealType currentSlot,
    required List<FoodItem> catalogFoods,
    bool isRamadan = false,
    FitnessGoal goal = FitnessGoal.generalVitality,
    bool isPregnancyMode = false,
    int userAge = 30,
    int cupSizeMl = HouseholdMeasures.standardCupMl,
    bool isArabic = true,
  }) {
    // Edge case 1: Pregnancy mode or under 18 => never enforce a strict deficit
    final effectiveRemainingKcal = (isPregnancyMode || userAge < 18)
        ? math.max(remainingKcal, 450)
        : remainingKcal;

    // Edge case 2: Over target (remaining < 0) => "خلّي الوجبة الجاية خفيفة" with <= 300 kcal options
    if (remainingKcal < 0) {
      return _buildOverTargetLightSuggestions(
        catalogFoods: catalogFoods,
        cupSizeMl: cupSizeMl,
        isArabic: isArabic,
        targetSlot: currentSlot,
      );
    }

    // Edge case 3: Remaining calories < 150 => light snack only
    if (effectiveRemainingKcal < 150) {
      return _buildLightSnackSuggestions(
        catalogFoods: catalogFoods,
        remainingProtein: remainingProtein,
        cupSizeMl: cupSizeMl,
        isArabic: isArabic,
        targetSlot: currentSlot,
      );
    }

    // Normal case: Build balanced combinations fitting remaining budget
    // Target per-meal budget: prioritize biggest gap (usually protein)
    final targetKcal = effectiveRemainingKcal.clamp(250, 900);
    final targetProtein = math.max(15.0, remainingProtein);

    final suggestions = <MealSuggestion>[];

    // Combination A: Grilled chicken + Rice + Salad
    final chicken = _findStaple('grilled_chicken');
    final rice = _findStaple('white_rice');
    final salad = _findStaple('green_salad');
    if (chicken != null && rice != null && salad != null) {
      // Scale chicken to hit protein target (within 100g - 250g)
      final chickenGrams = (targetProtein / (chicken.pPer100g / 100.0)).clamp(100.0, 220.0);
      final chickenKcal = (chicken.kcalPer100g * chickenGrams / 100.0).round();
      final remainingForCarb = math.max(100, targetKcal - chickenKcal - 40);
      final riceGrams = ((remainingForCarb / rice.kcalPer100g) * 100.0).clamp(80.0, 240.0);

      final components = [
        _createComponent(chicken, chickenGrams, catalogFoods, cupSizeMl, isArabic),
        _createComponent(rice, riceGrams, catalogFoods, cupSizeMl, isArabic),
        _createComponent(salad, 150.0, catalogFoods, cupSizeMl, isArabic),
      ];
      suggestions.add(_aggregateSuggestion(
        id: 'sugg_chicken_rice',
        nameAr: 'وجبة متوازنة: فراخ مشوية وأرز وسلطة',
        nameEn: 'Balanced: Grilled chicken, rice & salad',
        components: components,
        targetSlot: currentSlot,
      ));
    }

    // Combination B: Canned Tuna + Baladi Bread + Green Salad
    final tuna = _findStaple('canned_tuna');
    final bread = _findStaple('baladi_bread');
    if (tuna != null && bread != null && salad != null) {
      final tunaGrams = 140.0; // 1 standard can
      final breadGrams = targetKcal > 400 ? 90.0 : 45.0; // 1 loaf or 1/2 loaf

      final components = [
        _createComponent(tuna, tunaGrams, catalogFoods, cupSizeMl, isArabic),
        _createComponent(bread, breadGrams, catalogFoods, cupSizeMl, isArabic),
        _createComponent(salad, 150.0, catalogFoods, cupSizeMl, isArabic),
      ];
      suggestions.add(_aggregateSuggestion(
        id: 'sugg_tuna_bread',
        nameAr: 'وجبة سريعة: تونة بالعيش البلدي وسلطة',
        nameEn: 'Quick meal: Tuna, baladi bread & salad',
        components: components,
        targetSlot: currentSlot,
      ));
    }

    // Combination C: Cottage cheese or Eggs + Baladi Bread
    final eggs = _findStaple('boiled_eggs');
    final cottage = _findStaple('cottage_cheese');
    if (eggs != null && cottage != null && bread != null) {
      final eggGrams = 100.0; // 2 eggs
      final cottageGrams = 100.0;
      final breadGrams = 45.0; // half loaf

      final components = [
        _createComponent(cottage, cottageGrams, catalogFoods, cupSizeMl, isArabic),
        _createComponent(eggs, eggGrams, catalogFoods, cupSizeMl, isArabic),
        _createComponent(bread, breadGrams, catalogFoods, cupSizeMl, isArabic),
      ];
      suggestions.add(_aggregateSuggestion(
        id: 'sugg_cottage_eggs',
        nameAr: 'وجبة خفيفة غنية بالبروتين: جبنة قريش وبيض',
        nameEn: 'Protein rich: Cottage cheese & boiled eggs',
        components: components,
        targetSlot: currentSlot,
      ));
    }

    return suggestions;
  }

  static List<MealSuggestion> _buildLightSnackSuggestions({
    required List<FoodItem> catalogFoods,
    required double remainingProtein,
    required int cupSizeMl,
    required bool isArabic,
    required MealType targetSlot,
  }) {
    final suggestions = <MealSuggestion>[];

    final yogurt = _findStaple('greek_yogurt');
    if (yogurt != null) {
      final comp = _createComponent(yogurt, 170.0, catalogFoods, cupSizeMl, isArabic);
      suggestions.add(_aggregateSuggestion(
        id: 'snack_yogurt',
        nameAr: 'سناك خفيف: زبادي يوناني',
        nameEn: 'Light snack: Greek yogurt',
        components: [comp],
        isLightSnackOnly: true,
        targetSlot: targetSlot,
      ));
    }

    final eggs = _findStaple('boiled_eggs');
    if (eggs != null) {
      final comp = _createComponent(eggs, 50.0, catalogFoods, cupSizeMl, isArabic); // 1 egg
      suggestions.add(_aggregateSuggestion(
        id: 'snack_one_egg',
        nameAr: 'سناك بروتين: بيضة مسلوقة',
        nameEn: 'Protein snack: 1 boiled egg',
        components: [comp],
        isLightSnackOnly: true,
        targetSlot: targetSlot,
      ));
    }

    return suggestions;
  }

  static List<MealSuggestion> _buildOverTargetLightSuggestions({
    required List<FoodItem> catalogFoods,
    required int cupSizeMl,
    required bool isArabic,
    required MealType targetSlot,
  }) {
    final suggestions = <MealSuggestion>[];

    final salad = _findStaple('green_salad');
    final chicken = _findStaple('grilled_chicken');
    if (salad != null && chicken != null) {
      final compSalad = _createComponent(salad, 200.0, catalogFoods, cupSizeMl, isArabic);
      final compChicken = _createComponent(chicken, 100.0, catalogFoods, cupSizeMl, isArabic);
      suggestions.add(_aggregateSuggestion(
        id: 'over_light_salad_chicken',
        nameAr: 'خلّي الوجبة خفيفة: سلطة خضراء مع فراخ مشوية',
        nameEn: 'Keep it light: Green salad with grilled chicken',
        components: [compChicken, compSalad],
        isLightSnackOnly: true,
        targetSlot: targetSlot,
      ));
    }

    final tuna = _findStaple('canned_tuna');
    if (salad != null && tuna != null) {
      final compTuna = _createComponent(tuna, 100.0, catalogFoods, cupSizeMl, isArabic);
      final compSalad = _createComponent(salad, 200.0, catalogFoods, cupSizeMl, isArabic);
      suggestions.add(_aggregateSuggestion(
        id: 'over_light_salad_tuna',
        nameAr: 'خلّي الوجبة خفيفة: سلطة تونة خضراء خفيفة',
        nameEn: 'Keep it light: Tuna green salad',
        components: [compTuna, compSalad],
        isLightSnackOnly: true,
        targetSlot: targetSlot,
      ));
    }

    return suggestions;
  }

  static ({
    String key,
    String idGuess,
    String nameAr,
    String nameEn,
    double defaultGrams,
    double pPer100g,
    double cPer100g,
    double fPer100g,
    double kcalPer100g,
    bool isProtein,
    bool isCarb,
    bool isVeggie,
    bool isSnack,
  })? _findStaple(String key) {
    for (final s in _staples) {
      if (s.key == key) return s;
    }
    return null;
  }

  static SuggestedMealComponent _createComponent(
    dynamic staple,
    double grams,
    List<FoodItem> catalogFoods,
    int cupSizeMl,
    bool isArabic,
  ) {
    // Match against real FoodItem in catalog if possible
    FoodItem? matched;
    for (final f in catalogFoods) {
      if (f.id == staple.idGuess) {
        matched = f;
        break;
      }
    }

    matched ??= FoodItem(
      id: staple.idGuess as String,
      nameAr: staple.nameAr as String,
      nameEn: staple.nameEn as String,
      aliases: const [],
      per100g: FoodMacros100g(
        kcal: staple.kcalPer100g as double,
        protein: staple.pPer100g as double,
        carbs: staple.cPer100g as double,
        fat: staple.fPer100g as double,
        fiber: 1.0,
      ),
      state: 'cooked',
      commonPortions: const [],
      source: const FoodSource(name: 'Catalog', fdcId: 0),
    );

    final ratio = grams / 100.0;
    final kcal = (matched.per100g.kcal * ratio).round();
    final p = (matched.per100g.protein * ratio);
    final c = (matched.per100g.carbs * ratio);
    final f = (matched.per100g.fat * ratio);

    final householdDesc = HouseholdMeasures.describeItem(
      nameAr: matched.nameAr,
      nameEn: matched.nameEn,
      grams: grams,
      isArabic: isArabic,
      cupSizeMl: cupSizeMl,
    );

    return SuggestedMealComponent(
      food: matched,
      grams: grams,
      householdDescription: householdDesc,
      kcal: kcal,
      protein: p,
      carbs: c,
      fat: f,
    );
  }

  static MealSuggestion _aggregateSuggestion({
    required String id,
    required String nameAr,
    required String nameEn,
    required List<SuggestedMealComponent> components,
    required MealType targetSlot,
    bool isLightSnackOnly = false,
  }) {
    int totalKcal = 0;
    double totalP = 0;
    double totalC = 0;
    double totalF = 0;

    for (final c in components) {
      totalKcal += c.kcal;
      totalP += c.protein;
      totalC += c.carbs;
      totalF += c.fat;
    }

    return MealSuggestion(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      components: components,
      totalKcal: totalKcal,
      totalProtein: totalP,
      totalCarbs: totalC,
      totalFat: totalF,
      isLightSnackOnly: isLightSnackOnly,
      targetSlot: targetSlot,
    );
  }
}
