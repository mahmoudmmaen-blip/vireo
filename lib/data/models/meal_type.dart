enum MealType {
  breakfast('breakfast'),
  lunch('lunch'),
  dinner('dinner'),
  snack('snack');

  const MealType(this.value);
  final String value;

  static MealType fromValue(String value) {
    return MealType.values.firstWhere(
      (m) => m.value == value,
      orElse: () => MealType.breakfast,
    );
  }
}

enum RecipeGoalTag {
  highProtein('high_protein'),
  quickEasy('quick_easy'),
  lightEnergy('light_energy');

  const RecipeGoalTag(this.value);
  final String value;

  static RecipeGoalTag fromValue(String value) {
    return RecipeGoalTag.values.firstWhere(
      (t) => t.value == value,
      orElse: () => RecipeGoalTag.quickEasy,
    );
  }
}
