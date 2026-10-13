import 'package:flutter/foundation.dart';

@immutable
class MenVitalityHabits {
  const MenVitalityHabits({
    this.sleepHours = 0.0,
    this.resistanceWorkoutsThisWeek = 0,
    this.sunlightMinutes = 0,
    this.zincVitDLogged = false,
    this.proteinTargetMet = false,
    this.alcoholSmokeFree = true,
  });

  final double sleepHours;
  final int resistanceWorkoutsThisWeek;
  final int sunlightMinutes;
  final bool zincVitDLogged;
  final bool proteinTargetMet;
  final bool alcoholSmokeFree;

  bool get isSleepOptimal => sleepHours >= 7.0 && sleepHours <= 9.5;
  bool get isResistanceOptimal => resistanceWorkoutsThisWeek >= 3;
  bool get isSunlightOptimal => sunlightMinutes >= 15;

  /// Calculates a weekly vitality score (0 to 100) based on positive habits.
  int computeWeeklyScore() {
    var score = 0;
    if (isSleepOptimal) {
      score += 20;
    } else if (sleepHours >= 6.0) {
      score += 10;
    }

    if (isResistanceOptimal) {
      score += 25;
    } else if (resistanceWorkoutsThisWeek >= 1) {
      score += (resistanceWorkoutsThisWeek * 8);
    }

    if (isSunlightOptimal) {
      score += 15;
    } else if (sunlightMinutes > 0) {
      score += 8;
    }

    if (zincVitDLogged) {
      score += 15;
    }
    if (proteinTargetMet) {
      score += 15;
    }
    if (alcoholSmokeFree) {
      score += 10;
    }

    return score.clamp(0, 100);
  }
}
