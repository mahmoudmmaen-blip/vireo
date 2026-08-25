import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/meal_type.dart';

enum FatSource { butter, ghee, oliveOil, oilSpray }

enum MealAddOn { vegetables, wholeGrainBread, rice, yogurt }

/// Cheese varieties with macros per 100g.
enum CheeseType {
  none(0, 0, 0, 0),
  cottage(98, 11, 3, 4),
  cheddar(403, 25, 1, 33),
  mozzarella(280, 28, 3, 17),
  feta(264, 14, 4, 21);

  const CheeseType(this.kcalPer100g, this.proteinPer100g, this.carbsPer100g, this.fatPer100g);

  final int kcalPer100g;
  final int proteinPer100g;
  final int carbsPer100g;
  final int fatPer100g;
}

/// Per-meal ingredient builder with live macro recalculation.
class MealBuilderState {
  const MealBuilderState({
    required this.mealType,
    this.proteinCount = 2,
    this.fatSource = FatSource.oliveOil,
    this.addOns = const {},
    this.cheeseType = CheeseType.none,
    this.cheeseGrams = 30,
  });

  final MealType mealType;
  final int proteinCount;
  final FatSource fatSource;
  final Set<MealAddOn> addOns;
  final CheeseType cheeseType;
  final int cheeseGrams;

  factory MealBuilderState.defaultsFor(MealType type) {
    return switch (type) {
      MealType.breakfast => MealBuilderState(
          mealType: type,
          proteinCount: 2,
          fatSource: FatSource.oliveOil,
          addOns: const {MealAddOn.vegetables},
        ),
      MealType.lunch => MealBuilderState(
          mealType: type,
          proteinCount: 1,
          fatSource: FatSource.oliveOil,
          addOns: const {MealAddOn.rice, MealAddOn.vegetables},
        ),
      MealType.dinner => MealBuilderState(
          mealType: type,
          proteinCount: 1,
          fatSource: FatSource.ghee,
          addOns: const {MealAddOn.vegetables},
        ),
      MealType.snack => MealBuilderState(
          mealType: type,
          proteinCount: 1,
          fatSource: FatSource.oilSpray,
          addOns: const {MealAddOn.yogurt},
        ),
    };
  }

  MealBuilderState copyWith({
    int? proteinCount,
    FatSource? fatSource,
    Set<MealAddOn>? addOns,
    CheeseType? cheeseType,
    int? cheeseGrams,
  }) {
    return MealBuilderState(
      mealType: mealType,
      proteinCount: proteinCount ?? this.proteinCount,
      fatSource: fatSource ?? this.fatSource,
      addOns: addOns ?? this.addOns,
      cheeseType: cheeseType ?? this.cheeseType,
      cheeseGrams: cheeseGrams ?? this.cheeseGrams,
    );
  }

  List<int> get proteinOptions => switch (mealType) {
        MealType.breakfast => const [2, 3, 4],
        MealType.lunch || MealType.dinner => const [1, 2, 3],
        MealType.snack => const [1, 2],
      };

  List<MealAddOn> get availableAddOns => switch (mealType) {
        MealType.breakfast => const [
            MealAddOn.vegetables,
            MealAddOn.wholeGrainBread,
          ],
        MealType.lunch => const [
            MealAddOn.rice,
            MealAddOn.vegetables,
          ],
        MealType.dinner => const [
            MealAddOn.rice,
            MealAddOn.vegetables,
            MealAddOn.wholeGrainBread,
          ],
        MealType.snack => const [
            MealAddOn.yogurt,
            MealAddOn.wholeGrainBread,
          ],
      };

  bool get supportsCheese => switch (mealType) {
        MealType.breakfast || MealType.lunch || MealType.snack => true,
        MealType.dinner => false,
      };

  CalorieTarget get macros {
    var cal = 0;
    var protein = 0;
    var carbs = 0;
    var fat = 0;

    switch (mealType) {
      case MealType.breakfast:
        cal += proteinCount * 70;
        protein += proteinCount * 6;
        carbs += 1;
        fat += proteinCount * 5;
      case MealType.lunch:
        cal += proteinCount * 250;
        protein += proteinCount * 35;
        fat += proteinCount * 8;
      case MealType.dinner:
        cal += proteinCount * 220;
        protein += proteinCount * 32;
        fat += proteinCount * 7;
      case MealType.snack:
        cal += proteinCount * 100;
        protein += proteinCount * 12;
        carbs += proteinCount * 4;
        fat += proteinCount * 3;
    }

    switch (fatSource) {
      case FatSource.butter:
        cal += 100;
        fat += 11;
      case FatSource.ghee:
        cal += 120;
        fat += 14;
      case FatSource.oliveOil:
        cal += 120;
        fat += 14;
      case FatSource.oilSpray:
        cal += 10;
        fat += 1;
    }

    if (addOns.contains(MealAddOn.vegetables)) {
      cal += 40;
      carbs += 8;
      protein += 2;
    }
    if (addOns.contains(MealAddOn.wholeGrainBread)) {
      cal += 140;
      carbs += 24;
      protein += 5;
      fat += 2;
    }
    if (addOns.contains(MealAddOn.rice)) {
      cal += 200;
      carbs += 45;
      protein += 4;
    }
    if (addOns.contains(MealAddOn.yogurt)) {
      cal += 120;
      protein += 10;
      carbs += 12;
      fat += 3;
    }

    if (supportsCheese && cheeseType != CheeseType.none && cheeseGrams > 0) {
      final factor = cheeseGrams / 100.0;
      cal += (cheeseType.kcalPer100g * factor).round();
      protein += (cheeseType.proteinPer100g * factor).round();
      carbs += (cheeseType.carbsPer100g * factor).round();
      fat += (cheeseType.fatPer100g * factor).round();
    }

    return CalorieTarget(
      calories: cal,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
    );
  }
}
