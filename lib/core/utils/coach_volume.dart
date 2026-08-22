/// Mirrors `coach-program-generator.ts` volume rules (Section 3).
abstract final class CoachVolume {
  static double computeMultiplier({
    double? adherencePct,
    double? energyScore,
  }) {
    var multiplier = 1.0;

    if (adherencePct != null) {
      if (adherencePct >= 85) {
        multiplier += 0.1;
      } else if (adherencePct < 40) {
        multiplier -= 0.25;
      } else if (adherencePct < 60) {
        multiplier -= 0.15;
      }
    }

    if (energyScore != null) {
      if (energyScore >= 8) {
        multiplier += 0.05;
      } else if (energyScore <= 4) {
        multiplier -= 0.15;
      }
    }

    return multiplier.clamp(0.6, 1.15);
  }

  static int tunedSets({
    required int baseSets,
    required double volumeMultiplier,
    required bool medicalFlag,
  }) {
    var sets = (baseSets * volumeMultiplier).round();
    if (medicalFlag) {
      sets = (sets * 0.75).floor();
    }
    return sets < 1 ? 1 : sets;
  }
}
