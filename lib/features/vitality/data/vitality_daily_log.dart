import 'package:flutter/foundation.dart';

@immutable
class VitalityDailyLog {
  const VitalityDailyLog({
    required this.dateKey,
    this.sleepHours,
    this.breathingSessions = 0,
    this.workoutCompleted = false,
    this.sunlightDone = false,
    this.zincVitDDone = false,
    this.readArticleIds = const {},
    this.educationPoints = 0,
  });

  final String dateKey;
  final double? sleepHours;
  final int breathingSessions;
  final bool workoutCompleted;
  final bool sunlightDone;
  final bool zincVitDDone;
  final Set<String> readArticleIds;
  final int educationPoints;

  bool get sleepGoalMet => sleepHours != null && sleepHours! >= 7.5;

  int checklistCompleted({
    required bool proteinGoalMet,
  }) {
    var count = 0;
    if (sleepGoalMet) count++;
    if (proteinGoalMet) count++;
    if (workoutCompleted) count++;
    if (sunlightDone) count++;
    if (zincVitDDone) count++;
    return count;
  }

  VitalityDailyLog copyWith({
    String? dateKey,
    double? sleepHours,
    int? breathingSessions,
    bool? workoutCompleted,
    bool? sunlightDone,
    bool? zincVitDDone,
    Set<String>? readArticleIds,
    int? educationPoints,
    bool clearSleep = false,
  }) {
    return VitalityDailyLog(
      dateKey: dateKey ?? this.dateKey,
      sleepHours: clearSleep ? null : (sleepHours ?? this.sleepHours),
      breathingSessions: breathingSessions ?? this.breathingSessions,
      workoutCompleted: workoutCompleted ?? this.workoutCompleted,
      sunlightDone: sunlightDone ?? this.sunlightDone,
      zincVitDDone: zincVitDDone ?? this.zincVitDDone,
      readArticleIds: readArticleIds ?? this.readArticleIds,
      educationPoints: educationPoints ?? this.educationPoints,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': dateKey,
        'sleep_hours': sleepHours,
        'breathing_sessions': breathingSessions,
        'workout_completed': workoutCompleted,
        'sunlight_done': sunlightDone,
        'zinc_vitd_done': zincVitDDone,
        'read_articles': readArticleIds.toList(),
        'education_points': educationPoints,
      };

  factory VitalityDailyLog.fromJson(Map<String, dynamic> json) {
    return VitalityDailyLog(
      dateKey: json['date'] as String? ?? '',
      sleepHours: (json['sleep_hours'] as num?)?.toDouble(),
      breathingSessions: (json['breathing_sessions'] as num?)?.toInt() ?? 0,
      workoutCompleted: json['workout_completed'] as bool? ?? false,
      sunlightDone: json['sunlight_done'] as bool? ?? false,
      zincVitDDone: json['zinc_vitd_done'] as bool? ?? false,
      readArticleIds: (json['read_articles'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet(),
      educationPoints: json['education_points'] as int? ?? 0,
    );
  }

  factory VitalityDailyLog.empty(String dateKey) =>
      VitalityDailyLog(dateKey: dateKey);
}

String vitalityTodayDateKey() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}
