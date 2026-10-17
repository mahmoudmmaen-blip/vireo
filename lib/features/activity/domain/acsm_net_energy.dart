import 'dart:math' as math;

/// Activity energy: NET kcal only (never re-add BMR / resting MET).
///
/// Sources:
/// - ACSM Guidelines for Exercise Testing and Prescription (walking / running VO2)
/// - Keytel et al. 2005 (HR-based kcal)
/// - 2024 Compendium of Physical Activities (MET − 1 for net)
abstract final class AcsmNetEnergy {
  static const double restingVo2 = 3.5; // ml/kg/min
  static const double kcalPerKgFat = 7700.0;

  /// Default walking stride from height (m). Men 0.415, women 0.413 of height m.
  static double defaultWalkingStrideMeters({
    required double heightCm,
    required bool isFemale,
  }) {
    final h = heightCm.clamp(100.0, 240.0) / 100.0;
    return h * (isFemale ? 0.413 : 0.415);
  }

  /// Running stride when cadence > 140 spm.
  static double defaultRunningStrideMeters({
    required double heightCm,
    required bool isFemale,
  }) {
    final h = heightCm.clamp(100.0, 240.0) / 100.0;
    return h * 0.65;
  }

  /// Resolve stride: running ratio if cadence > 140, else walking (or calibrated).
  static double resolveStrideMeters({
    required double heightCm,
    required bool isFemale,
    double? calibratedWalkingStrideM,
    double cadenceSpm = 0,
  }) {
    if (cadenceSpm > 140) {
      return defaultRunningStrideMeters(heightCm: heightCm, isFemale: isFemale)
          .clamp(0.5, 1.3);
    }
    final base = calibratedWalkingStrideM ??
        defaultWalkingStrideMeters(heightCm: heightCm, isFemale: isFemale);
    return base.clamp(0.5, 1.3);
  }

  /// ACSM walking VO2 (ml/kg/min).
  /// VO2 = 0.1·speed(m/min) + 1.8·speed·grade + 3.5
  static double walkingVo2({
    required double speedMPerMin,
    double grade = 0,
  }) {
    final s = speedMPerMin.clamp(0.0, 200.0);
    final g = grade.clamp(0.0, 0.30);
    return 0.1 * s + 1.8 * s * g + restingVo2;
  }

  /// ACSM running VO2 (ml/kg/min).
  /// VO2 = 0.2·speed + 0.9·speed·grade + 3.5
  static double runningVo2({
    required double speedMPerMin,
    double grade = 0,
  }) {
    final s = speedMPerMin.clamp(0.0, 400.0);
    final g = grade.clamp(0.0, 0.30);
    return 0.2 * s + 0.9 * s * g + restingVo2;
  }

  /// Net kcal for [minutes] from VO2: (VO2 − 3.5) × kg / 200 per minute.
  static double netKcalFromVo2({
    required double vo2MlPerKgMin,
    required double weightKg,
    required double minutes,
  }) {
    if (minutes <= 0 || weightKg <= 0) return 0;
    final netVo2 = math.max(0.0, vo2MlPerKgMin - restingVo2);
    final w = weightKg.clamp(30.0, 250.0);
    return (netVo2 * w / 200.0) * minutes;
  }

  /// Walking net kcal for a continuous segment.
  static double walkingNetKcal({
    required double weightKg,
    required double speedMPerMin,
    required double minutes,
    double grade = 0,
  }) {
    final vo2 = walkingVo2(speedMPerMin: speedMPerMin, grade: grade);
    return netKcalFromVo2(vo2MlPerKgMin: vo2, weightKg: weightKg, minutes: minutes);
  }

  /// Running net kcal for a continuous segment.
  static double runningNetKcal({
    required double weightKg,
    required double speedMPerMin,
    required double minutes,
    double grade = 0,
  }) {
    final vo2 = runningVo2(speedMPerMin: speedMPerMin, grade: grade);
    return netKcalFromVo2(vo2MlPerKgMin: vo2, weightKg: weightKg, minutes: minutes);
  }

  /// Steps without GPS: speed = cadence(spm) × stride(m) → m/min = cadence × stride.
  static double speedMPerMinFromCadence({
    required double cadenceSpm,
    required double strideMeters,
  }) {
    if (cadenceSpm <= 0 || strideMeters <= 0) return 0;
    return cadenceSpm * strideMeters;
  }

  /// Fallback net kcal/step when cadence unknown.
  /// ≈ 0.0005 × kg × stride_m, validated vs ACSM within ±10% at ~100 spm / ~0.75 m stride.
  static double netKcalPerStepFallback({
    required double weightKg,
    required double strideMeters,
  }) {
    final w = weightKg.clamp(30.0, 250.0);
    final s = strideMeters.clamp(0.5, 1.3);
    return 0.0005 * w * s;
  }

  static double stepsNetKcal({
    required int steps,
    required double weightKg,
    required double strideMeters,
    double? cadenceSpm,
    double grade = 0,
    bool isRunning = false,
  }) {
    if (steps <= 0) return 0;
    final stride = strideMeters.clamp(0.5, 1.3);
    if (cadenceSpm != null && cadenceSpm > 0) {
      final speed = speedMPerMinFromCadence(
        cadenceSpm: cadenceSpm,
        strideMeters: stride,
      );
      final minutes = steps / cadenceSpm;
      return isRunning || cadenceSpm > 140
          ? runningNetKcal(
              weightKg: weightKg,
              speedMPerMin: speed,
              minutes: minutes,
              grade: grade,
            )
          : walkingNetKcal(
              weightKg: weightKg,
              speedMPerMin: speed,
              minutes: minutes,
              grade: grade,
            );
    }
    return steps * netKcalPerStepFallback(weightKg: weightKg, strideMeters: stride);
  }

  /// Keytel 2005 HR equation (kcal/min), sex-specific.
  /// Men: (−55.0969 + 0.6309·HR + 0.1988·kg + 0.2017·age) / 4.184
  /// Women: (−20.4022 + 0.4472·HR − 0.1263·kg + 0.074·age) / 4.184
  static double keytelKcalPerMinute({
    required double heartRateBpm,
    required double weightKg,
    required int age,
    required bool isFemale,
  }) {
    final hr = heartRateBpm.clamp(60.0, 220.0);
    final w = weightKg.clamp(30.0, 250.0);
    final a = age.clamp(14, 100).toDouble();
    final kjPerMin = isFemale
        ? (-20.4022 + 0.4472 * hr - 0.1263 * w + 0.074 * a)
        : (-55.0969 + 0.6309 * hr + 0.1988 * w + 0.2017 * a);
    return math.max(0.0, kjPerMin / 4.184);
  }

  /// Blend 70% Keytel HR / 30% ACSM when HR present for the session.
  static ({double netKcal, String source}) blendHrAndAcsm({
    required double acsmNetKcal,
    required double heartRateBpm,
    required double weightKg,
    required int age,
    required bool isFemale,
    required double minutes,
  }) {
    if (minutes <= 0 || heartRateBpm < 60) {
      return (netKcal: acsmNetKcal, source: 'acsm');
    }
    final hrKcal = keytelKcalPerMinute(
          heartRateBpm: heartRateBpm,
          weightKg: weightKg,
          age: age,
          isFemale: isFemale,
        ) *
        minutes;
    // Keytel is closer to gross; approximate net by subtracting resting ~1 MET.
    final restingNetApprox = (restingVo2 * weightKg.clamp(30, 250) / 200.0) * minutes;
    final hrNet = math.max(0.0, hrKcal - restingNetApprox);
    final blended = 0.7 * hrNet + 0.3 * acsmNetKcal;
    return (netKcal: blended, source: 'hr_acsm_blend');
  }

  /// Compendium 2024-style net kcal: (MET − 1) × kg × hours.
  static double workoutNetKcal({
    required double met,
    required double weightKg,
    required double durationMinutes,
  }) {
    if (durationMinutes <= 0 || met <= 1) return 0;
    final hours = durationMinutes / 60.0;
    final netMet = math.max(0.0, met - 1.0);
    return netMet * weightKg.clamp(30.0, 250.0) * hours;
  }

  /// Compendium 2024 walking/running MET bands (gross); use with [workoutNetKcal].
  static double compendiumMetForSpeed({
    required bool isRunning,
    required double speedKmh,
  }) {
    final v = speedKmh.clamp(0.5, 45.0);
    if (isRunning) {
      if (v < 6) return 6.0;
      if (v < 8) return 8.3;
      if (v < 9.7) return 9.8;
      if (v < 11.3) return 11.0;
      return 12.5;
    }
    if (v < 3.2) return 2.0;
    if (v < 4.8) return 2.8;
    if (v < 5.6) return 3.5;
    if (v < 6.4) return 4.3;
    return 5.0;
  }

  /// Eat-back policy: fraction of net exercise kcal added to the day's budget.
  static double eatBackFraction({
    required String goal, // lose | maintain | gain
    double? userOverride, // 0, 0.5, or 1.0
  }) {
    if (userOverride != null) return userOverride.clamp(0.0, 1.0);
    final g = goal.toLowerCase();
    if (g.contains('maintain') || g.contains('gain') || g.contains('muscle')) {
      return 1.0;
    }
    return 0.5;
  }

  static int eatBackKcal({
    required int netExerciseKcal,
    required String goal,
    double? userOverride,
  }) {
    final f = eatBackFraction(goal: goal, userOverride: userOverride);
    return (netExerciseKcal * f).round().clamp(0, 5000);
  }

  /// Brisk walk minutes needed to burn [surplusKcal] net at ~5.0 km/h (≈83.3 m/min).
  static ({int minutes, int steps}) walkOffSurplus({
    required int surplusKcal,
    required double weightKg,
    required double strideMeters,
    double briskSpeedMPerMin = 83.3,
  }) {
    if (surplusKcal <= 0) return (minutes: 0, steps: 0);
    final kcalPerMin = walkingNetKcal(
      weightKg: weightKg,
      speedMPerMin: briskSpeedMPerMin,
      minutes: 1,
    );
    if (kcalPerMin <= 0) return (minutes: 0, steps: 0);
    final minutes = (surplusKcal / kcalPerMin).ceil().clamp(1, 180);
    final cadence = briskSpeedMPerMin / strideMeters.clamp(0.5, 1.3);
    final steps = (minutes * cadence).round().clamp(0, 30000);
    return (minutes: minutes, steps: steps);
  }
}

enum EatBackPolicy { none, half, full }

extension EatBackPolicyX on EatBackPolicy {
  double get fraction => switch (this) {
        EatBackPolicy.none => 0.0,
        EatBackPolicy.half => 0.5,
        EatBackPolicy.full => 1.0,
      };
}
