import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';

part 'notification_settings.freezed.dart';

Map<NotificationType, bool> defaultEnabledMap({required bool hasWorkoutToday}) {
  return {
    for (final type in NotificationType.values)
      type: type != NotificationType.preWorkoutReminder || hasWorkoutToday,
  };
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default({}) Map<NotificationType, bool> enabledMap,
    int? workoutHour,
    int? workoutMinute,
    @Default(2) int waterIntervalHours,
  }) = _NotificationSettings;

  const NotificationSettings._();

  bool isEnabled(NotificationType type) => enabledMap[type] ?? false;

  bool get hasAnyEnabled => enabledMap.values.any((enabled) => enabled);

  TimeOfDay? get workoutTime {
    if (workoutHour == null || workoutMinute == null) return null;
    return TimeOfDay(hour: workoutHour!, minute: workoutMinute!);
  }

  NotificationSettings withWorkoutTime(TimeOfDay? time) {
    if (time == null) {
      return copyWith(workoutHour: null, workoutMinute: null);
    }
    return copyWith(workoutHour: time.hour, workoutMinute: time.minute);
  }

  Map<String, dynamic> toStorageMap() => {
        'enabled': {
          for (final entry in enabledMap.entries) entry.key.name: entry.value,
        },
        'workout_hour': workoutHour,
        'workout_minute': workoutMinute,
        'water_interval_hours': waterIntervalHours,
      };

  factory NotificationSettings.fromStorageMap(
    Map<String, dynamic> json, {
    required bool hasWorkoutToday,
  }) {
    final enabledRaw = json['enabled'];
    final enabled = <NotificationType, bool>{};
    if (enabledRaw is Map) {
      for (final type in NotificationType.values) {
        final value = enabledRaw[type.name];
        if (value is bool) {
          enabled[type] = value;
        }
      }
    }

    if (enabled.isEmpty) {
      enabled.addAll(defaultEnabledMap(hasWorkoutToday: hasWorkoutToday));
    }

    return NotificationSettings(
      enabledMap: enabled,
      workoutHour: json['workout_hour'] as int?,
      workoutMinute: json['workout_minute'] as int?,
      waterIntervalHours: (json['water_interval_hours'] as num?)?.toInt() ?? 2,
    );
  }
}
