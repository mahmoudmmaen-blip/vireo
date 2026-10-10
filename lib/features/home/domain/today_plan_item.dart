import 'package:flutter/material.dart';
import 'package:vireo/data/models/meal_type.dart';

enum TodayPlanKind {
  waterReminder,
  meal,
  fastingOpen,
  fastingClose,
  workout,
  steps,
  vitalitySleep,
  vitalityProtein,
  vitalitySun,
  vitalityBreathing,
  vitalityZinc,
  sleepBedtime,
  protocolPro,
  aiSuggestionPro,
}

@immutable
class TodayPlanItem {
  const TodayPlanItem({
    required this.id,
    required this.kind,
    required this.minutesOfDay,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isPro,
    this.mealType,
    this.autoComplete = false,
  });

  final String id;
  final TodayPlanKind kind;
  final int minutesOfDay;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isPro;
  final MealType? mealType;

  /// When true, checking is driven by other app state (workout, meals, etc.).
  final bool autoComplete;

  DateTime get sortTime {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(Duration(minutes: minutesOfDay));
  }
}
