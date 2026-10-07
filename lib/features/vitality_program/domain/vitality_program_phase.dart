enum VitalityProgramPhase {
  foundation,
  optimization,
  peak,
}

enum VitalityTaskCategory {
  nutrition,
  workout,
  sleep,
  supplement,
  mindset,
}

enum VitalityTrendDirection {
  improving,
  stable,
  declining,
}

VitalityProgramPhase phaseForWeek(int weekNumber) {
  if (weekNumber <= 4) return VitalityProgramPhase.foundation;
  if (weekNumber <= 8) return VitalityProgramPhase.optimization;
  return VitalityProgramPhase.peak;
}
