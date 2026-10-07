import 'package:flutter/foundation.dart';

@immutable
class VitalityScoreBreakdown {
  const VitalityScoreBreakdown({
    required this.sleepPoints,
    required this.workoutPoints,
    required this.proteinPoints,
    required this.stressPoints,
    required this.educationPoints,
  });

  final int sleepPoints;
  final int workoutPoints;
  final int proteinPoints;
  final int stressPoints;
  final int educationPoints;

  int get totalScore => (sleepPoints +
          workoutPoints +
          proteinPoints +
          stressPoints +
          educationPoints)
      .clamp(0, 100);

  double get progress => totalScore / 100.0;
}

abstract final class VitalityScoreCalculator {
  static const maxSleep = 28;
  static const maxWorkout = 28;
  static const maxProtein = 18;
  static const maxStress = 18;
  static const maxEducation = 8;

  static VitalityScoreBreakdown compute({
    required double? sleepHours,
    required bool workoutCompleted,
    required int proteinConsumed,
    required int proteinTarget,
    required int breathingSessions,
    required int educationPoints,
  }) {
    return VitalityScoreBreakdown(
      sleepPoints: _sleepPoints(sleepHours),
      workoutPoints: workoutCompleted ? maxWorkout : 0,
      proteinPoints: _proteinPoints(proteinConsumed, proteinTarget),
      stressPoints: _stressPoints(breathingSessions),
      educationPoints: educationPoints.clamp(0, maxEducation),
    );
  }

  static int _sleepPoints(double? hours) {
    if (hours == null || hours <= 0) return 0;
    if (hours >= 7 && hours <= 9) return maxSleep;
    if (hours >= 6 && hours < 7) return 20;
    if (hours > 9 && hours <= 10) return 20;
    if (hours >= 5 && hours < 6) return 10;
    if (hours > 10) return 8;
    return (hours / 7 * maxSleep).round().clamp(0, maxSleep);
  }

  static int _proteinPoints(int consumed, int target) {
    if (target <= 0) return 0;
    if (consumed >= target) return maxProtein;
    return ((consumed / target) * maxProtein).round().clamp(0, maxProtein);
  }

  static int _stressPoints(int sessions) {
    if (sessions <= 0) return 0;
    if (sessions >= 2) return maxStress;
    return 9;
  }
}
