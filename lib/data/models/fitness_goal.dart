enum FitnessGoal {
  weightLoss('weight_loss'),
  muscleGain('muscle_gain'),
  generalVitality('general_vitality'),
  allOfAbove('all_of_above');

  const FitnessGoal(this.value);
  final String value;

  static FitnessGoal fromValue(String value) {
    return FitnessGoal.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FitnessGoal.generalVitality,
    );
  }
}
