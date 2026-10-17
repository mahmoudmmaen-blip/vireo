import 'package:flutter/foundation.dart';
import 'package:vireo/features/activity/domain/acsm_net_energy.dart';
import 'package:vireo/features/progress/domain/adaptive_tdee_engine.dart';

enum MissedStepsChoice { makeUpGradually, balanceWithFood, startFresh, lowerGoal }

@immutable
class MissedStepsOffer {
  const MissedStepsOffer({
    required this.missedSteps,
    required this.missedNetKcal,
    required this.options,
    required this.suggestLowerGoal,
    required this.suggestedLowerGoal,
  });

  final int missedSteps;
  final int missedNetKcal;
  final List<MissedStepsOption> options;
  final bool suggestLowerGoal;
  final int? suggestedLowerGoal;
}

@immutable
class MissedStepsOption {
  const MissedStepsOption({
    required this.choice,
    required this.titleAr,
    required this.detailAr,
    required this.payload,
  });

  final MissedStepsChoice choice;
  final String titleAr;
  final String detailAr;
  final Map<String, num> payload;
}

/// End-of-day missed step goal → next-morning choice card (nothing automatic).
abstract final class MissedStepsEngine {
  static const int maxAddPerDay = 1500;
  static const int maxFoodBalanceKcal = 200;
  static const int endOfDayHour = 21;
  static const int endOfDayMinute = 30;

  static bool isEndOfDayWindow(DateTime now, {int? bedtimeHour}) {
    final h = bedtimeHour ?? endOfDayHour;
    final m = bedtimeHour != null ? 0 : endOfDayMinute;
    return now.hour > h || (now.hour == h && now.minute >= m);
  }

  static MissedStepsOffer? evaluate({
    required int stepGoal,
    required int stepsWalked,
    required double weightKg,
    required double strideMeters,
    required int comfortableSteps,
    required int peakCapacity,
    required int consecutiveMissedDays,
    required int calorieTarget,
    required bool isFemale,
    required bool isPregnancy,
    required bool isUnder18,
  }) {
    if (stepsWalked >= stepGoal) return null;
    final missed = stepGoal - stepsWalked;
    if (missed <= 0) return null;

    final missedKcal = AcsmNetEnergy.stepsNetKcal(
      steps: missed,
      weightKg: weightKg,
      strideMeters: strideMeters,
    ).round();

    final peakCap = (peakCapacity * 1.15).round();
    final spreadDays = missed > maxAddPerDay * 2 ? 3 : 2;
    final perDayRaw = (missed / spreadDays).ceil();
    final perDay = perDayRaw.clamp(0, maxAddPerDay);
    final dayTargets = <int>[];
    for (var i = 0; i < spreadDays; i++) {
      final next = (stepGoal + perDay).clamp(0, peakCap);
      dayTargets.add(next);
    }

    final floor = SafetyFloors.forSex(
      isFemale: isFemale,
      isPregnancy: isPregnancy,
      isUnder18: isUnder18,
    );
    final foodCut = missedKcal.clamp(0, maxFoodBalanceKcal);
    final foodTarget = (calorieTarget - foodCut).clamp(floor, calorieTarget);

    final suggestLower = consecutiveMissedDays >= 3;
    final lowerGoal = suggestLower
        ? comfortableSteps.clamp(1000, peakCapacity)
        : null;

    return MissedStepsOffer(
      missedSteps: missed,
      missedNetKcal: missedKcal,
      suggestLowerGoal: suggestLower,
      suggestedLowerGoal: lowerGoal,
      options: [
        MissedStepsOption(
          choice: MissedStepsChoice.makeUpGradually,
          titleAr: 'عوّضها تدريجي',
          detailAr: 'زود ≈ $perDay خطوة على $spreadDays أيام',
          payload: {
            'per_day': perDay,
            'days': spreadDays,
            for (var i = 0; i < dayTargets.length; i++) 'day_${i + 1}': dayTargets[i],
          },
        ),
        MissedStepsOption(
          choice: MissedStepsChoice.balanceWithFood,
          titleAr: 'وازِن بالأكل',
          detailAr: 'قلّل هدف اليوم $foodCut سعرة → $foodTarget',
          payload: {'kcal_cut': foodCut, 'new_target': foodTarget},
        ),
        MissedStepsOption(
          choice: MissedStepsChoice.startFresh,
          titleAr: 'يوم جديد',
          detailAr: 'يوم وعدى — النهارده يوم جديد',
          payload: const {},
        ),
        if (suggestLower && lowerGoal != null)
          MissedStepsOption(
            choice: MissedStepsChoice.lowerGoal,
            titleAr: 'خلّي الهدف واقعي',
            detailAr: 'هدف مريح من بصمتك: $lowerGoal خطوة',
            payload: {'new_step_goal': lowerGoal},
          ),
      ],
    );
  }
}
