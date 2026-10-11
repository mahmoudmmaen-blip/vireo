enum NotificationType {
  waterReminder,
  mealBreakfastReminder,
  mealLunchReminder,
  mealDinnerReminder,
  fastingWindowOpenReminder,
  fastingWindowCloseReminder,
  workoutReminder,
  stepsNudgeReminder,
  bedtimeReminder,
  weeklyCheckInReminder,
  streakProtectionReminder;

  // Legacy compatibility aliases if needed
  static const NotificationType breakfastReminder = NotificationType.mealBreakfastReminder;
  static const NotificationType lunchReminder = NotificationType.mealLunchReminder;
  static const NotificationType dinnerReminder = NotificationType.mealDinnerReminder;
  static const NotificationType preWorkoutReminder = NotificationType.workoutReminder;
  static const NotificationType sleepReminder = NotificationType.bedtimeReminder;
  static const NotificationType weeklyReportReminder = NotificationType.weeklyCheckInReminder;
}

extension NotificationTypeIds on NotificationType {
  int get baseId => switch (this) {
        NotificationType.waterReminder => 1000,
        NotificationType.mealBreakfastReminder => 2000,
        NotificationType.mealLunchReminder => 2001,
        NotificationType.mealDinnerReminder => 2002,
        NotificationType.fastingWindowOpenReminder => 2100,
        NotificationType.fastingWindowCloseReminder => 2101,
        NotificationType.workoutReminder => 3000,
        NotificationType.stepsNudgeReminder => 3500,
        NotificationType.bedtimeReminder => 4000,
        NotificationType.weeklyCheckInReminder => 5000,
        NotificationType.streakProtectionReminder => 6000,
      };

  int notificationId([int index = 0]) => baseId + index;

  /// Number of scheduled notification slots for this type.
  int get slotCount => switch (this) {
        NotificationType.waterReminder => 8,
        _ => 1,
      };
}

extension NotificationTypeSchedule on NotificationType {
  /// Default hour and minute if not overridden by user or plan.
  (int hour, int minute) get defaultTime => switch (this) {
        NotificationType.waterReminder => (8, 0),
        NotificationType.mealBreakfastReminder => (8, 30),
        NotificationType.mealLunchReminder => (13, 0),
        NotificationType.mealDinnerReminder => (19, 30),
        NotificationType.fastingWindowOpenReminder => (12, 0),
        NotificationType.fastingWindowCloseReminder => (20, 0),
        NotificationType.workoutReminder => (17, 30),
        NotificationType.stepsNudgeReminder => (18, 0),
        NotificationType.bedtimeReminder => (22, 30),
        NotificationType.weeklyCheckInReminder => (9, 0),
        NotificationType.streakProtectionReminder => (21, 0),
      };

  /// Fixed daily hour/minute when applicable; null for dynamic types.
  (int hour, int minute)? get fixedDailyTime => switch (this) {
        NotificationType.mealBreakfastReminder => (8, 30),
        NotificationType.mealLunchReminder => (13, 0),
        NotificationType.mealDinnerReminder => (19, 30),
        NotificationType.fastingWindowOpenReminder => (12, 0),
        NotificationType.fastingWindowCloseReminder => (20, 0),
        NotificationType.stepsNudgeReminder => (18, 0),
        NotificationType.bedtimeReminder => (22, 30),
        NotificationType.weeklyCheckInReminder => (9, 0),
        NotificationType.streakProtectionReminder => (21, 0),
        _ => null,
      };
}

/// Water slots: 08:00–22:00 every 2 hours.
const waterReminderHours = [8, 10, 12, 14, 16, 18, 20, 22];
