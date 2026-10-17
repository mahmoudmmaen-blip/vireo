import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/notifications/domain/reminder_scheduler.dart';

void main() {
  const scheduler = ReminderScheduler();

  group('ReminderScheduler - Quiet Hours', () {
    test('standard overnight quiet hours (23:00 to 07:00)', () {
      // 23:00 is quiet
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 23,
          minute: 0,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        isTrue,
      );

      // 03:30 is quiet
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 3,
          minute: 30,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        isTrue,
      );

      // 06:59 is quiet
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 6,
          minute: 59,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        isTrue,
      );

      // 07:00 is NOT quiet (morning boundary end)
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 7,
          minute: 0,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        isFalse,
      );

      // 12:00 is NOT quiet
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 12,
          minute: 0,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        isFalse,
      );

      // 22:59 is NOT quiet
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 22,
          minute: 59,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        isFalse,
      );
    });

    test('same-day quiet hours (e.g. 13:00 to 15:00 afternoon rest)', () {
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 14,
          minute: 0,
          startHour: 13,
          startMinute: 0,
          endHour: 15,
          endMinute: 0,
        ),
        isTrue,
      );
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 12,
          minute: 59,
          startHour: 13,
          startMinute: 0,
          endHour: 15,
          endMinute: 0,
        ),
        isFalse,
      );
      expect(
        ReminderScheduler.isInQuietHours(
          hour: 15,
          minute: 0,
          startHour: 13,
          startMinute: 0,
          endHour: 15,
          endMinute: 0,
        ),
        isFalse,
      );
    });

    test('quiet hours filter excludes candidate falling into quiet window', () {
      final settings = const NotificationSettings(
        enabledMap: {
          NotificationType.bedtimeReminder: true,
        },
        quietHoursStartHour: 22,
        quietHoursStartMinute: 0,
        quietHoursEndHour: 7,
        quietHoursEndMinute: 0,
      );

      // Bedtime is default 22:30, falls in 22:00-07:00 quiet hours
      const context = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 3000,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: context,
      );

      expect(schedule.any((c) => c.type == NotificationType.bedtimeReminder), isFalse);
    });
  });

  group('ReminderScheduler - Daily Cap', () {
    test('enforces max of 6 notifications per day even when more types are enabled', () {
      final settings = const NotificationSettings(
        enabledMap: {
          NotificationType.waterReminder: true, // 8 water slots
          NotificationType.mealBreakfastReminder: true,
          NotificationType.mealLunchReminder: true,
          NotificationType.mealDinnerReminder: true,
          NotificationType.workoutReminder: true,
          NotificationType.stepsNudgeReminder: true,
          NotificationType.streakProtectionReminder: true,
        },
        maxDailyNotifications: 6,
        quietHoursStartHour: 23,
        quietHoursStartMinute: 0,
        quietHoursEndHour: 7,
        quietHoursEndMinute: 0,
      );

      const context = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 1000,
        dailyStepsGoal: 6000,
        hasLoggedToday: false,
        hasWorkoutToday: true,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: context,
      );

      final dailyItems = schedule.where((c) => c.weekday == null).toList();
      expect(dailyItems.length, lessThanOrEqualTo(6));
    });

    test('custom max daily limit is respected (e.g. max 3 notifications)', () {
      final settings = const NotificationSettings(
        enabledMap: {
          NotificationType.mealBreakfastReminder: true,
          NotificationType.mealLunchReminder: true,
          NotificationType.mealDinnerReminder: true,
          NotificationType.workoutReminder: true,
        },
        maxDailyNotifications: 3,
      );

      const context = ReminderContext(
        isWaterGoalMet: true,
        currentSteps: 7000,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: true,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: context,
      );

      final dailyItems = schedule.where((c) => c.weekday == null).toList();
      expect(dailyItems.length, equals(3));
    });
  });

  group('ReminderScheduler - Goal Conditions', () {
    test('skips water reminders completely when water goal is met', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.waterReminder: true,
        },
      );

      const contextGoalMet = ReminderContext(
        isWaterGoalMet: true,
        currentSteps: 5000,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: contextGoalMet,
      );

      expect(schedule.any((c) => c.type == NotificationType.waterReminder), isFalse);
    });

    test('schedules water reminders across waking hours when water goal is not met', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.waterReminder: true,
        },
        maxDailyNotifications: 8,
      );

      const contextNotMet = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 5000,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
        wakeHour: 7,
        sleepHour: 23,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: contextNotMet,
      );

      final waterItems = schedule.where((c) => c.type == NotificationType.waterReminder).toList();
      expect(waterItems, isNotEmpty);
      for (final item in waterItems) {
        expect(item.hour, greaterThanOrEqualTo(7));
        expect(item.hour, lessThanOrEqualTo(23));
      }
    });

    test('Ramadan mode schedules a single water reminder between iftar and suhoor', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.waterReminder: true,
        },
        maxDailyNotifications: 4,
      );

      const contextRamadan = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 5000,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
        isRamadanMode: true,
        fastingStartHour: 4,
        fastingStartMinute: 30,
        fastingEndHour: 18,
        fastingEndMinute: 15,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: contextRamadan,
      );

      final waterItems =
          schedule.where((c) => c.type == NotificationType.waterReminder).toList();
      expect(waterItems.length, 1);
      // 90 min after iftar (18:15) → 19:45, before quiet hours at 23:00.
      expect(waterItems.single.hour, 19);
      expect(waterItems.single.minute, 45);
    });

    test('steps nudge triggers at 18:00 if under 50% of goal', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.stepsNudgeReminder: true,
        },
      );

      // 2500 out of 6000 (< 50%) -> should schedule
      const contextUnder50 = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 2500,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: contextUnder50,
      );

      final stepsItem = schedule.firstWhere((c) => c.type == NotificationType.stepsNudgeReminder);
      expect(stepsItem.hour, equals(18));
      expect(stepsItem.minute, equals(0));
    });

    test('steps nudge is skipped if at or over 50% of goal', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.stepsNudgeReminder: true,
        },
      );

      // 3500 out of 6000 (>= 50%) -> should NOT schedule
      const contextOver50 = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 3500,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: contextOver50,
      );

      expect(schedule.any((c) => c.type == NotificationType.stepsNudgeReminder), isFalse);
    });

    test('streak protection triggers at 21:00 only if nothing logged today', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.streakProtectionReminder: true,
        },
      );

      // Not logged today -> should schedule at 21:00
      const contextNotLogged = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 0,
        dailyStepsGoal: 6000,
        hasLoggedToday: false,
        hasWorkoutToday: false,
      );

      final scheduleUnlogged = scheduler.generateSchedule(
        settings: settings,
        context: contextNotLogged,
      );

      final streakItem = scheduleUnlogged.firstWhere(
        (c) => c.type == NotificationType.streakProtectionReminder,
      );
      expect(streakItem.hour, equals(21));
      expect(streakItem.minute, equals(0));

      // Logged today -> should skip
      const contextLogged = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 2000,
        dailyStepsGoal: 6000,
        hasLoggedToday: true,
        hasWorkoutToday: false,
      );

      final scheduleLogged = scheduler.generateSchedule(
        settings: settings,
        context: contextLogged,
      );

      expect(scheduleLogged.any((c) => c.type == NotificationType.streakProtectionReminder), isFalse);
    });

    test('workout reminder scheduled only when workout scheduled today and uses preferred time', () {
      final settings = const NotificationSettings(
        enabledMap: {
          NotificationType.workoutReminder: true,
        },
      ).withWorkoutTime(const TimeOfDay(hour: 17, minute: 15));

      // Has workout today
      const contextWithWorkout = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 0,
        dailyStepsGoal: 6000,
        hasLoggedToday: false,
        hasWorkoutToday: true,
      );

      final scheduleWithWorkout = scheduler.generateSchedule(
        settings: settings,
        context: contextWithWorkout,
      );

      final workoutItem = scheduleWithWorkout.firstWhere((c) => c.type == NotificationType.workoutReminder);
      expect(workoutItem.hour, equals(17));
      expect(workoutItem.minute, equals(15));

      // No workout today
      const contextNoWorkout = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 0,
        dailyStepsGoal: 6000,
        hasLoggedToday: false,
        hasWorkoutToday: false,
      );

      final scheduleNoWorkout = scheduler.generateSchedule(
        settings: settings,
        context: contextNoWorkout,
      );

      expect(scheduleNoWorkout.any((c) => c.type == NotificationType.workoutReminder), isFalse);
    });

    test('meals schedule from plan meal times', () {
      final settings = const NotificationSettings(
        enabledMap: {
          NotificationType.mealBreakfastReminder: true,
          NotificationType.mealLunchReminder: true,
          NotificationType.mealDinnerReminder: true,
        },
        // This test is about meal TIMES, not the default cap (now 2, P40).
        maxDailyNotifications: 6,
      );

      const context = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 0,
        dailyStepsGoal: 6000,
        hasLoggedToday: false,
        hasWorkoutToday: false,
        mealTimes: {
          MealType.breakfast: TimeOfDay(hour: 9, minute: 0),
          MealType.lunch: TimeOfDay(hour: 13, minute: 30),
          MealType.dinner: TimeOfDay(hour: 20, minute: 0),
        },
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: context,
      );

      final breakfast = schedule.firstWhere((c) => c.type == NotificationType.mealBreakfastReminder);
      final lunch = schedule.firstWhere((c) => c.type == NotificationType.mealLunchReminder);
      final dinner = schedule.firstWhere((c) => c.type == NotificationType.mealDinnerReminder);

      expect(breakfast.hour, equals(9));
      expect(breakfast.minute, equals(0));
      expect(lunch.hour, equals(13));
      expect(lunch.minute, equals(30));
      expect(dinner.hour, equals(20));
      expect(dinner.minute, equals(0));
    });

    test('weekly check-in scheduled for Sunday morning', () {
      const settings = NotificationSettings(
        enabledMap: {
          NotificationType.weeklyCheckInReminder: true,
        },
      );

      const context = ReminderContext(
        isWaterGoalMet: false,
        currentSteps: 0,
        dailyStepsGoal: 6000,
        hasLoggedToday: false,
        hasWorkoutToday: false,
      );

      final schedule = scheduler.generateSchedule(
        settings: settings,
        context: context,
      );

      final weekly = schedule.firstWhere((c) => c.type == NotificationType.weeklyCheckInReminder);
      expect(weekly.weekday, equals(DateTime.sunday));
      expect(weekly.hour, equals(9));
      expect(weekly.minute, equals(0));
    });
  });
}
