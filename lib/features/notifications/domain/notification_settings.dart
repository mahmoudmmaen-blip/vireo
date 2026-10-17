import 'package:flutter/material.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';

Map<NotificationType, bool> defaultEnabledMap({required bool hasWorkoutToday}) {
  return {
    NotificationType.waterReminder: true,
    NotificationType.mealBreakfastReminder: true,
    NotificationType.mealLunchReminder: true,
    NotificationType.mealDinnerReminder: true,
    NotificationType.fastingWindowOpenReminder: false,
    NotificationType.fastingWindowCloseReminder: false,
    NotificationType.workoutReminder: hasWorkoutToday,
    NotificationType.stepsNudgeReminder: true,
    NotificationType.bedtimeReminder: true,
    NotificationType.weeklyCheckInReminder: true,
    NotificationType.weeklyWrappedReminder: true,
    NotificationType.streakProtectionReminder: true,
  };
}

@immutable
class NotificationSettings {
  const NotificationSettings({
    this.enabledMap = const {},
    this.customTimes = const {},
    this.workoutHour,
    this.workoutMinute,
    this.waterIntervalHours = 2,
    this.quietHoursStartHour = 23,
    this.quietHoursStartMinute = 0,
    this.quietHoursEndHour = 7,
    this.quietHoursEndMinute = 0,
    this.maxDailyNotifications = defaultMaxDailyNotifications,
  });

  /// P40: max 2 notifications per day by default.
  static const int defaultMaxDailyNotifications = 2;

  final Map<NotificationType, bool> enabledMap;
  final Map<NotificationType, TimeOfDay> customTimes;
  final int? workoutHour;
  final int? workoutMinute;
  final int waterIntervalHours;
  final int quietHoursStartHour;
  final int quietHoursStartMinute;
  final int quietHoursEndHour;
  final int quietHoursEndMinute;
  final int maxDailyNotifications;

  bool isEnabled(NotificationType type) => enabledMap[type] ?? false;

  bool get hasAnyEnabled => enabledMap.values.any((enabled) => enabled);

  TimeOfDay? get workoutTime {
    if (workoutHour == null || workoutMinute == null) return null;
    return TimeOfDay(hour: workoutHour!, minute: workoutMinute!);
  }

  TimeOfDay timeFor(NotificationType type) {
    if (customTimes.containsKey(type)) {
      return customTimes[type]!;
    }
    if (type == NotificationType.workoutReminder && workoutTime != null) {
      return workoutTime!;
    }
    final def = type.defaultTime;
    return TimeOfDay(hour: def.$1, minute: def.$2);
  }

  NotificationSettings withWorkoutTime(TimeOfDay? time) {
    if (time == null) {
      return copyWith(
        workoutHour: null,
        workoutMinute: null,
        customTimes: {
          ...customTimes,
          NotificationType.workoutReminder: const TimeOfDay(hour: 17, minute: 30),
        },
      );
    }
    return copyWith(
      workoutHour: time.hour,
      workoutMinute: time.minute,
      customTimes: {
        ...customTimes,
        NotificationType.workoutReminder: time,
      },
    );
  }

  NotificationSettings copyWith({
    Map<NotificationType, bool>? enabledMap,
    Map<NotificationType, TimeOfDay>? customTimes,
    int? workoutHour,
    int? workoutMinute,
    int? waterIntervalHours,
    int? quietHoursStartHour,
    int? quietHoursStartMinute,
    int? quietHoursEndHour,
    int? quietHoursEndMinute,
    int? maxDailyNotifications,
  }) {
    return NotificationSettings(
      enabledMap: enabledMap ?? this.enabledMap,
      customTimes: customTimes ?? this.customTimes,
      workoutHour: workoutHour ?? this.workoutHour,
      workoutMinute: workoutMinute ?? this.workoutMinute,
      waterIntervalHours: waterIntervalHours ?? this.waterIntervalHours,
      quietHoursStartHour: quietHoursStartHour ?? this.quietHoursStartHour,
      quietHoursStartMinute: quietHoursStartMinute ?? this.quietHoursStartMinute,
      quietHoursEndHour: quietHoursEndHour ?? this.quietHoursEndHour,
      quietHoursEndMinute: quietHoursEndMinute ?? this.quietHoursEndMinute,
      maxDailyNotifications: maxDailyNotifications ?? this.maxDailyNotifications,
    );
  }

  Map<String, dynamic> toStorageMap() => {
        'enabled': {
          for (final entry in enabledMap.entries) entry.key.name: entry.value,
        },
        'custom_times': {
          for (final entry in customTimes.entries)
            entry.key.name: '${entry.value.hour}:${entry.value.minute}',
        },
        'workout_hour': workoutHour,
        'workout_minute': workoutMinute,
        'water_interval_hours': waterIntervalHours,
        'quiet_hours_start_hour': quietHoursStartHour,
        'quiet_hours_start_minute': quietHoursStartMinute,
        'quiet_hours_end_hour': quietHoursEndHour,
        'quiet_hours_end_minute': quietHoursEndMinute,
        'max_daily_notifications': maxDailyNotifications,
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
      // Migrate legacy aliases if present
      if (!enabled.containsKey(NotificationType.mealBreakfastReminder) &&
          enabledRaw['breakfastReminder'] is bool) {
        enabled[NotificationType.mealBreakfastReminder] = enabledRaw['breakfastReminder'] as bool;
      }
      if (!enabled.containsKey(NotificationType.mealLunchReminder) &&
          enabledRaw['lunchReminder'] is bool) {
        enabled[NotificationType.mealLunchReminder] = enabledRaw['lunchReminder'] as bool;
      }
      if (!enabled.containsKey(NotificationType.mealDinnerReminder) &&
          enabledRaw['dinnerReminder'] is bool) {
        enabled[NotificationType.mealDinnerReminder] = enabledRaw['dinnerReminder'] as bool;
      }
      if (!enabled.containsKey(NotificationType.workoutReminder) &&
          enabledRaw['preWorkoutReminder'] is bool) {
        enabled[NotificationType.workoutReminder] = enabledRaw['preWorkoutReminder'] as bool;
      }
      if (!enabled.containsKey(NotificationType.bedtimeReminder) &&
          enabledRaw['sleepReminder'] is bool) {
        enabled[NotificationType.bedtimeReminder] = enabledRaw['sleepReminder'] as bool;
      }
      if (!enabled.containsKey(NotificationType.weeklyCheckInReminder) &&
          enabledRaw['weeklyReportReminder'] is bool) {
        enabled[NotificationType.weeklyCheckInReminder] = enabledRaw['weeklyReportReminder'] as bool;
      }
    }

    if (enabled.isEmpty) {
      enabled.addAll(defaultEnabledMap(hasWorkoutToday: hasWorkoutToday));
    }

    final customTimes = <NotificationType, TimeOfDay>{};
    final customRaw = json['custom_times'];
    if (customRaw is Map) {
      for (final type in NotificationType.values) {
        final timeStr = customRaw[type.name] as String?;
        if (timeStr != null) {
          final parts = timeStr.split(':');
          if (parts.length == 2) {
            final h = int.tryParse(parts[0]);
            final m = int.tryParse(parts[1]);
            if (h != null && m != null) {
              customTimes[type] = TimeOfDay(hour: h, minute: m);
            }
          }
        }
      }
    }

    return NotificationSettings(
      enabledMap: enabled,
      customTimes: customTimes,
      workoutHour: json['workout_hour'] as int?,
      workoutMinute: json['workout_minute'] as int?,
      waterIntervalHours: (json['water_interval_hours'] as num?)?.toInt() ?? 2,
      quietHoursStartHour: (json['quiet_hours_start_hour'] as num?)?.toInt() ?? 23,
      quietHoursStartMinute: (json['quiet_hours_start_minute'] as num?)?.toInt() ?? 0,
      quietHoursEndHour: (json['quiet_hours_end_hour'] as num?)?.toInt() ?? 7,
      quietHoursEndMinute: (json['quiet_hours_end_minute'] as num?)?.toInt() ?? 0,
      maxDailyNotifications: (json['max_daily_notifications'] as num?)?.toInt() ??
          defaultMaxDailyNotifications,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettings &&
          runtimeType == other.runtimeType &&
          workoutHour == other.workoutHour &&
          workoutMinute == other.workoutMinute &&
          waterIntervalHours == other.waterIntervalHours &&
          quietHoursStartHour == other.quietHoursStartHour &&
          quietHoursStartMinute == other.quietHoursStartMinute &&
          quietHoursEndHour == other.quietHoursEndHour &&
          quietHoursEndMinute == other.quietHoursEndMinute &&
          maxDailyNotifications == other.maxDailyNotifications &&
          _mapEquals(enabledMap, other.enabledMap) &&
          _mapEquals(customTimes, other.customTimes);

  @override
  int get hashCode => Object.hash(
        workoutHour,
        workoutMinute,
        waterIntervalHours,
        quietHoursStartHour,
        quietHoursStartMinute,
        quietHoursEndHour,
        quietHoursEndMinute,
        maxDailyNotifications,
        Object.hashAll(enabledMap.entries),
        Object.hashAll(customTimes.entries),
      );

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }
}
