import 'package:flutter/foundation.dart';

@immutable
class WeeklyProgressReportData {
  const WeeklyProgressReportData({
    required this.weekStartDate,
    required this.weekEndDate,
    required this.avgCalories,
    required this.targetCalories,
    required this.avgProteinG,
    required this.targetProteinG,
    required this.daysFoodLogged,
    required this.totalWorkoutsCompleted,
    required this.avgDailySteps,
    required this.avgDailyWaterMl,
    required this.avgSleepHours,
    required this.trendWeightChangeKg,
    required this.bestDayTitle,
    required this.aiCoachTip,
    this.totalWeeklySteps = 0,
    this.streakDays = 1,
    this.proteinGoalDays = 0,
  });

  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final int avgCalories;
  final int targetCalories;
  final int avgProteinG;
  final int targetProteinG;
  final int daysFoodLogged;
  final int totalWorkoutsCompleted;
  final int avgDailySteps;
  final int avgDailyWaterMl;
  final double avgSleepHours;
  final double trendWeightChangeKg;
  final String bestDayTitle;
  final String aiCoachTip;
  final int totalWeeklySteps;
  final int streakDays;
  final int proteinGoalDays;

  double get calorieAdherenceRatio => targetCalories > 0 ? avgCalories / targetCalories : 0.0;
  double get proteinAdherenceRatio => targetProteinG > 0 ? avgProteinG / targetProteinG : 0.0;
}
