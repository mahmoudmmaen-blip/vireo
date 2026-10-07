enum NotificationType {
  waterReminder,
  breakfastReminder,
  lunchReminder,
  dinnerReminder,
  preWorkoutReminder,
  sleepReminder,
  weeklyReportReminder,
}

extension NotificationTypeIds on NotificationType {
  int get baseId => switch (this) {
        NotificationType.waterReminder => 1000,
        NotificationType.breakfastReminder => 2000,
        NotificationType.lunchReminder => 2001,
        NotificationType.dinnerReminder => 2002,
        NotificationType.preWorkoutReminder => 3000,
        NotificationType.sleepReminder => 4000,
        NotificationType.weeklyReportReminder => 5000,
      };

  int notificationId([int index = 0]) => baseId + index;

  /// Number of scheduled notification slots for this type.
  int get slotCount => switch (this) {
        NotificationType.waterReminder => 8,
        _ => 1,
      };
}

extension NotificationTypeSchedule on NotificationType {
  /// Fixed daily hour/minute when applicable; null for dynamic types.
  (int hour, int minute)? get fixedDailyTime => switch (this) {
        NotificationType.breakfastReminder => (8, 30),
        NotificationType.lunchReminder => (13, 0),
        NotificationType.dinnerReminder => (19, 30),
        NotificationType.sleepReminder => (22, 30),
        NotificationType.weeklyReportReminder => (9, 0),
        _ => null,
      };
}

/// Water slots: 08:00–22:00 every 2 hours.
const waterReminderHours = [8, 10, 12, 14, 16, 18, 20, 22];
