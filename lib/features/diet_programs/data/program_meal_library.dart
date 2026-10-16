import 'package:flutter/foundation.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/diet_programs/data/program_meal_library_data.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

/// Meal slots shown in the program meal library.
enum MealSlot {
  breakfast,
  lunch,
  dinner,
  snack;

  MealType get mealType => switch (this) {
        MealSlot.breakfast => MealType.breakfast,
        MealSlot.lunch => MealType.lunch,
        MealSlot.dinner => MealType.dinner,
        MealSlot.snack => MealType.snack,
      };

  static MealSlot fromMealType(MealType t) => switch (t) {
        MealType.breakfast => MealSlot.breakfast,
        MealType.lunch => MealSlot.lunch,
        MealType.dinner => MealSlot.dinner,
        MealType.snack => MealSlot.snack,
      };
}

/// One ready-to-eat option in the program meal library.
///
/// Macros are SUMMED from `assets/food_db/foods.json` (per-100 g × grams of
/// each component) by `tool/meal_library/gen_program_meal_library.mjs`, so
/// they are never guessed. [foodDbIds] lists the DB foods the option is built
/// from; look them up with `FoodDbRepository.instance.byId`.
///
/// Notes on data:
/// * "جبنة بيضاء لايت" uses the regular white cheese entry at a small portion
///   (the DB has no light white cheese) – conservative on calories.
/// * "مربى قليل السكر" uses the regular jam entry at a small portion –
///   conservative on sugar.
@immutable
class ProgramMealOption {
  const ProgramMealOption({
    required this.id,
    required this.slot,
    required this.nameAr,
    required this.nameEn,
    required this.foodDbIds,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.prepMinutes,
    required this.householdMeasureAr,
    required this.swaps,
    this.noCook = false,
    this.highProtein = false,
    this.budget = false,
    this.ramadanSuhoor = false,
    this.fried = false,
    this.processed = false,
  });

  final String id;
  final MealSlot slot;
  final String nameAr;
  final String nameEn;
  final List<String> foodDbIds;
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int prepMinutes;

  /// Portion in household measures (spoons, cups, loaves).
  final String householdMeasureAr;

  /// Arabic names of other options in the same slot with similar calories.
  final List<String> swaps;

  // Filters.
  final bool noCook;
  final bool highProtein;
  final bool budget;
  final bool ramadanSuhoor;

  // Quality flags used by the "Egyptian clean" program.
  final bool fried;
  final bool processed;

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;

  /// Whether this option fits [program]'s per-meal rules (see [ProgramMealRules]).
  bool fitsProgram(DietProgramId program) =>
      ProgramMealRules.fits(this, program);
}

/// Per-meal rules that decide which options belong to which program.
///
/// Derived from each program's macro rule in `diet_programs_catalog.dart`:
/// * all programs: kcal cap per slot (deficit-friendly portions);
/// * high protein: protein floor per slot and ≥ 25 % of kcal from protein;
/// * low carb / fasting low carb: carb ceiling per slot (≈ 100–130 g/day);
/// * keto: ≤ 10 g carbs (≤ 7 g for snacks) and ≥ 45 % of kcal from fat;
/// * intermittent fasting: bigger meals (cap × 1.2, fewer meals/day) and
///   ≥ 20 % of kcal from protein to protect muscle;
/// * Egyptian clean: not deep-fried and not processed.
abstract final class ProgramMealRules {
  static const Map<MealSlot, int> kcalCap = {
    MealSlot.breakfast: 550,
    MealSlot.lunch: 700,
    MealSlot.dinner: 600,
    MealSlot.snack: 300,
  };
  static const Map<MealSlot, int> proteinMinG = {
    MealSlot.breakfast: 20,
    MealSlot.lunch: 30,
    MealSlot.dinner: 25,
    MealSlot.snack: 10,
  };
  static const Map<MealSlot, int> lowCarbMaxG = {
    MealSlot.breakfast: 30,
    MealSlot.lunch: 40,
    MealSlot.dinner: 30,
    MealSlot.snack: 12,
  };

  static bool fits(ProgramMealOption o, DietProgramId program) {
    final cap = kcalCap[o.slot]!;
    final proteinShare = o.proteinG * 4 / o.kcal;
    final fatShare = o.fatG * 9 / o.kcal;
    return switch (program) {
      DietProgramId.balancedDeficit => o.kcal <= cap,
      DietProgramId.highProtein => o.kcal <= cap &&
          o.proteinG >= proteinMinG[o.slot]! &&
          proteinShare >= 0.25,
      DietProgramId.intermittentFasting =>
        o.kcal <= cap * 1.2 && proteinShare >= 0.2,
      DietProgramId.lowCarb =>
        o.kcal <= cap && o.carbsG <= lowCarbMaxG[o.slot]!,
      DietProgramId.keto => o.kcal <= cap &&
          o.carbsG <= (o.slot == MealSlot.snack ? 7 : 10) &&
          fatShare >= 0.45,
      DietProgramId.fastingLowCarb => o.kcal <= cap * 1.2 &&
          o.carbsG <= lowCarbMaxG[o.slot]! &&
          proteinShare >= 0.2,
      DietProgramId.egyptianClean =>
        !o.fried && !o.processed && o.kcal <= cap,
    };
  }
}

/// Every option in the library (all programs, all slots).
List<ProgramMealOption> get allProgramMeals => kProgramMealOptions;

final Map<(DietProgramId, MealSlot), List<ProgramMealOption>> _cache = {};

/// Options for [id] in [slot] (≥ 15 for every combination).
List<ProgramMealOption> mealsFor(DietProgramId id, MealSlot slot) {
  return _cache.putIfAbsent(
    (id, slot),
    () => List.unmodifiable(
      kProgramMealOptions
          .where((o) => o.slot == slot && ProgramMealRules.fits(o, id)),
    ),
  );
}

/// Total number of options for [id] across all slots.
int mealCountFor(DietProgramId id) => [
      for (final s in MealSlot.values) mealsFor(id, s).length,
    ].fold(0, (a, b) => a + b);
