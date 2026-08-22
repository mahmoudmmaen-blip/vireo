enum UnitPreference {
  metric('metric'),
  imperial('imperial');

  const UnitPreference(this.value);
  final String value;

  static UnitPreference fromValue(String value) {
    return UnitPreference.values.firstWhere(
      (e) => e.value.trim() == value,
      orElse: () => UnitPreference.metric,
    );
  }

  /// US, Liberia, Myanmar commonly use imperial for body metrics.
  static UnitPreference fromLocale(String? countryCode) {
    const imperial = {'US', 'LR', 'MM'};
    if (countryCode != null &&
        imperial.contains(countryCode.toUpperCase())) {
      return UnitPreference.imperial;
    }
    return UnitPreference.metric;
  }
}
