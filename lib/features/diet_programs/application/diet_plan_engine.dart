import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

/// Inputs the engine needs. Pull them from the onboarding profile and
/// `calorieGoalProvider` (TDEE before any deficit).
@immutable
class DietPlanInput {
  const DietPlanInput({
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.maintenanceKcal,
    this.conditions = const {},
    this.preferences = const DietPreferences(),
  });

  final double weightKg;
  final double heightCm;
  final int age;

  /// Maintenance calories (TDEE), NOT the already-reduced goal.
  final int maintenanceKcal;
  final Set<HealthCondition> conditions;
  final DietPreferences preferences;
}

@immutable
class DietPlanTargets {
  const DietPlanTargets({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.deficitKcal,
    required this.weeklyLossKg,
    required this.floorApplied,
    this.carbsMaxG,
  });

  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int? carbsMaxG;
  final int deficitKcal;

  /// Expected average loss per week (kg) from the deficit alone.
  final double weeklyLossKg;

  /// True when the safety floor (1500 kcal) raised the target.
  final bool floorApplied;
}

enum EligibilityStatus {
  /// Free to start.
  allowed,

  /// Can start, but must read a warning first.
  caution,

  /// Locked until the user confirms "my doctor approved this program".
  doctorRequired,
}

@immutable
class ProgramEligibility {
  const ProgramEligibility(this.status, this.reasons, {this.isMinor = false});

  final EligibilityStatus status;
  final List<HealthCondition> reasons;
  final bool isMinor;
}

@immutable
class RankedProgram {
  const RankedProgram({
    required this.program,
    required this.score,
    required this.eligibility,
    required this.targets,
    required this.isRecommended,
  });

  final DietProgram program;
  final double score;
  final ProgramEligibility eligibility;
  final DietPlanTargets targets;
  final bool isRecommended;
}

/// Pure, testable rules. No Flutter UI, no Riverpod.
abstract final class DietPlanEngine {
  /// Minimum daily calories for adult men without medical supervision.
  static const int calorieFloorMen = 1500;

  /// Deficit bounds (kcal/day).
  static const int minDeficit = 300;
  static const int maxDeficit = 750;

  /// ~7700 kcal ≈ 1 kg of body fat (rule of thumb; real loss varies).
  static const double kcalPerKgFat = 7700;

  static double bmi(double weightKg, double heightCm) {
    final m = heightCm / 100;
    return m <= 0 ? 0 : weightKg / (m * m);
  }

  /// Body weight used for protein targets. For BMI > 27 we use an adjusted
  /// weight so protein isn't inflated by fat mass.
  static double referenceWeight(double weightKg, double heightCm) {
    final m = heightCm / 100;
    final b = bmi(weightKg, heightCm);
    if (b <= 27 || m <= 0) return weightKg;
    final weightAtBmi25 = 25 * m * m;
    return weightAtBmi25 + 0.4 * (weightKg - weightAtBmi25);
  }

  static DietPlanTargets targetsFor(DietProgram program, DietPlanInput input) {
    final tdee = input.maintenanceKcal;
    final rawDeficit = (tdee * 0.20).clamp(minDeficit.toDouble(), maxDeficit.toDouble());
    final deficit = (rawDeficit * program.deficitFactor).round();

    var calories = tdee - deficit;
    var floorApplied = false;
    if (calories < calorieFloorMen) {
      calories = calorieFloorMen;
      floorApplied = true;
    }
    calories = (calories / 10).round() * 10;
    final realDeficit = math.max(0, tdee - calories);

    final refW = referenceWeight(input.weightKg, input.heightCm);
    final rule = program.macroRule;
    final protein = (rule.proteinGPerKg * refW).round();
    final proteinKcal = protein * 4;

    int carbs;
    int fat;
    if (rule.carbsGrams != null) {
      carbs = rule.carbsGrams!;
      fat = ((calories - proteinKcal - carbs * 4) / 9).round();
      if (fat < 30) fat = 30;
    } else {
      fat = (calories * rule.fatPercent! / 9).round();
      carbs = ((calories - proteinKcal - fat * 9) / 4).round();
      if (carbs < 50) {
        carbs = 50;
        fat = math.max(30, ((calories - proteinKcal - carbs * 4) / 9).round());
      }
    }

    return DietPlanTargets(
      calories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      carbsMaxG: rule.carbsMaxGrams,
      deficitKcal: realDeficit,
      weeklyLossKg: double.parse((realDeficit * 7 / kcalPerKgFat).toStringAsFixed(2)),
      floorApplied: floorApplied,
    );
  }

  static ProgramEligibility eligibilityFor(DietProgram program, DietPlanInput input) {
    // Under 18: every weight-loss program needs a doctor / guardian.
    if (input.age < 18) {
      return const ProgramEligibility(
        EligibilityStatus.doctorRequired,
        [],
        isMinor: true,
      );
    }
    final hard = program.requiresDoctorIf.intersection(input.conditions).toList();
    if (hard.isNotEmpty) {
      return ProgramEligibility(EligibilityStatus.doctorRequired, hard);
    }
    final soft = program.cautionIf.intersection(input.conditions).toList();
    if (soft.isNotEmpty) {
      return ProgramEligibility(EligibilityStatus.caution, soft);
    }
    return const ProgramEligibility(EligibilityStatus.allowed, []);
  }

  /// Ranks programs: safe ones first, then by fit with the user's preferences.
  static List<RankedProgram> rank(List<DietProgram> programs, DietPlanInput input) {
    final p = input.preferences;
    final ranked = <RankedProgram>[];

    for (final program in programs) {
      final elig = eligibilityFor(program, input);
      var score = 50.0;

      switch (program.id) {
        case DietProgramId.balancedDeficit:
          score += 10; // strongest evidence, easiest to sustain
          if (p.wantsSimpleRules) score += 10;
          if (p.eatsOutOften) score += 8;
        case DietProgramId.highProtein:
          if (p.trainsWithWeights) score += 22;
          score += 6;
        case DietProgramId.intermittentFasting:
          if (p.canSkipBreakfast) score += 22;
          if (p.wantsSimpleRules) score += 6;
          if (!p.canSkipBreakfast) score -= 18;
        case DietProgramId.lowCarb:
          if (!p.lovesBreadAndRice) score += 18;
          if (p.lovesBreadAndRice) score -= 10;
        case DietProgramId.keto:
          if (!p.lovesBreadAndRice) score += 14;
          if (p.lovesBreadAndRice) score -= 25;
          if (p.eatsOutOften) score -= 10;
          score -= 6; // hardest to sustain
        case DietProgramId.fastingLowCarb:
          if (p.canSkipBreakfast && !p.lovesBreadAndRice) score += 24;
          if (p.lovesBreadAndRice) score -= 12;
          if (!p.canSkipBreakfast) score -= 15;
        case DietProgramId.egyptianClean:
          if (p.lovesBreadAndRice) score += 18;
          if (p.wantsSimpleRules) score += 6;
      }

      score -= (program.difficulty - 1) * 4;

      switch (elig.status) {
        case EligibilityStatus.allowed:
          break;
        case EligibilityStatus.caution:
          score -= 20;
        case EligibilityStatus.doctorRequired:
          score -= 100;
      }

      ranked.add(
        RankedProgram(
          program: program,
          score: score,
          eligibility: elig,
          targets: targetsFor(program, input),
          isRecommended: false,
        ),
      );
    }

    ranked.sort((a, b) => b.score.compareTo(a.score));
    if (ranked.isEmpty) return ranked;
    final top = ranked.first;
    ranked[0] = RankedProgram(
      program: top.program,
      score: top.score,
      eligibility: top.eligibility,
      targets: top.targets,
      isRecommended: top.eligibility.status != EligibilityStatus.doctorRequired,
    );
    return ranked;
  }
}
