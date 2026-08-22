/// Where the user trains — drives exercise filtering across the app.
enum TrainingEnvironment {
  homeNoEquipment('home_no_equipment'),
  homeLightEquipment('home_light_equipment'),
  gymFull('gym_full'),
  walkingOnly('walking_only');

  const TrainingEnvironment(this.value);

  final String value;

  static TrainingEnvironment fromValue(String value) {
    return TrainingEnvironment.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TrainingEnvironment.homeNoEquipment,
    );
  }
}
