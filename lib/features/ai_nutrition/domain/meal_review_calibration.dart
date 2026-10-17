/// P40 meal-result calibration: portion presets and cooking-oil levels (grams).
enum MealPortionPreset {
  half(0.5),
  one(1.0),
  oneHalf(1.5),
  two(2.0);

  const MealPortionPreset(this.multiplier);

  final double multiplier;

  /// UI label (same in all locales — universal kitchen fractions).
  String get label => switch (this) {
        MealPortionPreset.half => '½',
        MealPortionPreset.one => '1',
        MealPortionPreset.oneHalf => '1½',
        MealPortionPreset.two => '2',
      };

  static MealPortionPreset? fromMultiplier(double value, {double tolerance = 0.01}) {
    for (final p in MealPortionPreset.values) {
      if ((p.multiplier - value).abs() <= tolerance) return p;
    }
    return null;
  }
}

/// Three-state oil chip: خفيف / عادي / مسبّك (same grams as legacy review chips).
enum CookingOilCalibrationLevel {
  light(5),
  normal(10),
  heavy(20);

  const CookingOilCalibrationLevel(this.grams);

  final int grams;

  static CookingOilCalibrationLevel? fromGrams(int grams) {
    if (grams <= 0) return null;
    if (grams <= 7) return CookingOilCalibrationLevel.light;
    if (grams <= 15) return CookingOilCalibrationLevel.normal;
    return CookingOilCalibrationLevel.heavy;
  }
}
