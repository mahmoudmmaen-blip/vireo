import 'package:vireo/core/utils/calorie_calculator.dart';

enum FatSource { butter, ghee, oliveOil, oilSpray }

enum MealAddOn { cheese, vegetables, wholeGrainBread }

/// Customizable breakfast-style meal builder with live macro recalculation.
class MealBuilderState {
  const MealBuilderState({
    this.eggCount = 2,
    this.fatSource = FatSource.oliveOil,
    this.addOns = const {},
  });

  final int eggCount;
  final FatSource fatSource;
  final Set<MealAddOn> addOns;

  MealBuilderState copyWith({
    int? eggCount,
    FatSource? fatSource,
    Set<MealAddOn>? addOns,
  }) {
    return MealBuilderState(
      eggCount: eggCount ?? this.eggCount,
      fatSource: fatSource ?? this.fatSource,
      addOns: addOns ?? this.addOns,
    );
  }

  CalorieTarget get macros {
    // Base: eggs
    var cal = eggCount * 70;
    var protein = eggCount * 6;
    var carbs = 1;
    var fat = eggCount * 5;

    // Fat source (~1 tbsp cooking fat)
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

    return CalorieTarget(
      calories: cal,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
    );
  }
}
