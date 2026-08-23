enum BmiCategory {
  underweight,
  healthy,
  overweight,
  obese,
}

abstract final class BmiCalculator {
  static double compute({required double weightKg, required double heightCm}) {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  static BmiCategory categoryFor(double bmi) {
    if (bmi <= 0) return BmiCategory.healthy;
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25) return BmiCategory.healthy;
    if (bmi < 30) return BmiCategory.overweight;
    return BmiCategory.obese;
  }
}
