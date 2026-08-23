import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/meal_type.dart';

enum FatSource { butter, ghee, oliveOil, oilSpray }

enum MealAddOn { cheese, vegetables, wholeGrainBread, rice, yogurt }

/// Per-meal ingredient builder with live macro recalculation.
class MealBuilderState {
  const MealBuilderState({
    required this.mealType,
    this.proteinCount = 2,
    this.fatSource = FatSource.oliveOil,
    this.addOns = const {},
  });

  final MealType mealType;
  final int proteinCount;
  final FatSource fatSource;
  final Set<MealAddOn> addOns;

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
  }) {
    return MealBuilderState(
      mealType: mealType,
      proteinCount: proteinCount ?? this.proteinCount,
      fatSource: fatSource ?? this.fatSource,
      addOns: addOns ?? this.addOns,
    );
  }

  List<int> get proteinOptions => switch (mealType) {
        MealType.breakfast => const [2, 3, 4],
        MealType.lunch || MealType.dinner => const [1, 2, 3],
        MealType.snack => const [1, 2],
      };

  List<MealAddOn> get availableAddOns => switch (mealType) {
        MealType.breakfast => const [
            MealAddOn.cheese,
            MealAddOn.vegetables,
            MealAddOn.wholeGrainBread,
          ],
        MealType.lunch => const [
            MealAddOn.rice,
            MealAddOn.vegetables,
            MealAddOn.cheese,
          ],
        MealType.dinner => const [
            MealAddOn.rice,
            MealAddOn.vegetables,
            MealAddOn.wholeGrainBread,
          ],
        MealType.snack => const [
            MealAddOn.yogurt,
            MealAddOn.cheese,
            MealAddOn.wholeGrainBread,
          ],
      };

  CalorieTarget get macros {
    var cal = 0;
    var protein = 0;
    var carbs = 0;
    var fat = 0;

    switch (mealType) {
      case MealType.breakfast:
        // Eggs
        cal += proteinCount * 70;
        protein += proteinCount * 6;
        carbs += 1;
        fat += proteinCount * 5;
      case MealType.lunch:
        // Chicken / lean protein portion (~150g each)
        cal += proteinCount * 250;
        protein += proteinCount * 35;
        fat += proteinCount * 8;
      case MealType.dinner:
        // Fish / lean dinner portion
        cal += proteinCount * 220;
        protein += proteinCount * 32;
        fat += proteinCount * 7;
      case MealType.snack:
        // Protein snack base
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

    if (addOns.contains(MealAddOn.cheese)) {
      cal += 80;
      protein += 5;
      fat += 6;
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

    return CalorieTarget(
      calories: cal,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
    );
  }
}
