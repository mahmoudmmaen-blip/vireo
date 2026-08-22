enum ActivityLevel {
  sedentary('sedentary'),
  moderatelyActive('moderately_active'),
  veryActive('very_active');

  const ActivityLevel(this.value);
  final String value;

  static ActivityLevel fromValue(String value) {
    return ActivityLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ActivityLevel.moderatelyActive,
    );
  }
}
