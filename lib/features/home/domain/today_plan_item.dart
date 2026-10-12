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

enum TodayPlanSectionKind {
  morning,
  afternoon,
  evening,
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
    this.section = TodayPlanSectionKind.morning,
    this.progress,
    this.progressLabel,
    this.quickActionLabel,
  });

  final String id;
  final TodayPlanKind kind;
  final int minutesOfDay;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isPro;
  final MealType? mealType;

  /// When true, item completion is synchronized with underlying app state.
  final bool autoComplete;

  /// Section group: Morning (صباحاً), Afternoon (الظهر), Evening (المساء).
  final TodayPlanSectionKind section;

  /// Optional progress ratio 0.0 - 1.0 (e.g. for water ring).
  final double? progress;

  /// Optional text label e.g. "0.5 / 3.3 L".
  final String? progressLabel;

  /// Optional quick button label e.g. "+250 ml".
  final String? quickActionLabel;

  DateTime get sortTime {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(Duration(minutes: minutesOfDay));
  }
}
