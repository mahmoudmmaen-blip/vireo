import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';

/// Represents a candidate notification to be scheduled.
@immutable
class ReminderCandidate {
  const ReminderCandidate({
    required this.type,
    required this.slotIndex,
    required this.hour,
    required this.minute,
    required this.priority,
    this.weekday,
    this.mealType,
  });

  final NotificationType type;
  final int slotIndex;
  final int hour;
  final int minute;
  final int priority; // Lower integer = higher priority
  final int? weekday; // 1 = Monday ... 7 = Sunday
  final MealType? mealType;

  int get id => type.notificationId(slotIndex);

  int get minutesOfDay => hour * 60 + minute;

  @override
  String toString() =>
      'ReminderCandidate(type: ${type.name}, slot: $slotIndex, time: $hour:$minute, priority: $priority)';
}

/// Context passed to [ReminderScheduler] to evaluate conditions.
@immutable
class ReminderContext {
  const ReminderContext({
    required this.isWaterGoalMet,
    required this.currentSteps,
    required this.dailyStepsGoal,
    required this.hasLoggedToday,
    required this.hasWorkoutToday,
    this.mealTimes = const {},
    this.fastingOpenTime,
    this.fastingCloseTime,
    this.preferredWorkoutTime,
    this.weeklyDeficitKcal,
    this.wakeHour = 7,
    this.sleepHour = 23,
    this.isRamadanMode = false,
    this.fastingStartHour,
    this.fastingStartMinute,
    this.fastingEndHour,
    this.fastingEndMinute,
  });

  final bool isWaterGoalMet;
  final int currentSteps;
  final int dailyStepsGoal;
  final bool hasLoggedToday;
  final bool hasWorkoutToday;
  final Map<MealType, TimeOfDay> mealTimes;
  final TimeOfDay? fastingOpenTime;
  final TimeOfDay? fastingCloseTime;
  final TimeOfDay? preferredWorkoutTime;
  final int? weeklyDeficitKcal;
  final int wakeHour;
  final int sleepHour;
  final bool isRamadanMode;
  final int? fastingStartHour;
  final int? fastingStartMinute;
  final int? fastingEndHour;
  final int? fastingEndMinute;
}

/// Pure business logic engine for scheduling Vireo smart local reminders.
///
/// Applies:
/// 1. Type toggle checks
/// 2. Condition checks (water goal met, steps under 50% at 18:00, streak protection if logged)
/// 3. Quiet hours filtering (default 23:00 - 07:00)
/// 4. Daily cap of notifications (default max 6 per day)
class ReminderScheduler {
  const ReminderScheduler();

  /// Determines if a time is within quiet hours.
  ///
  /// Quiet hours can wrap around midnight, e.g., 23:00 to 07:00.
  static bool isInQuietHours({
    required int hour,
    required int minute,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) {
    final timeMin = hour * 60 + minute;
    final startMin = startHour * 60 + startMinute;
    final endMin = endHour * 60 + endMinute;

    if (startMin == endMin) {
      // Quiet hours disabled or 0 length
      return false;
    }

    if (startMin < endMin) {
      // Simple range in same day: e.g. 01:00 to 05:00
      return timeMin >= startMin && timeMin < endMin;
    } else {
      // Spans midnight: e.g. 23:00 to 07:00
      return timeMin >= startMin || timeMin < endMin;
    }
  }

  /// Calculates waking hours water slots spread between waking and sleep hours.
  static List<(int hour, int minute)> calculateWaterSlots({
    required int count,
    required int wakeHour,
    required int sleepHour,
  }) {
    if (count <= 0) return const [];
    final wakeMin = wakeHour * 60;
    final sleepMin = sleepHour * 60;
    if (wakeMin >= sleepMin) {
      return [for (var i = 0; i < count; i++) (8 + i * 2, 0)];
    }

    final span = sleepMin - wakeMin;
    final step = span ~/ (count + 1);

    return List.generate(count, (i) {
      final m = wakeMin + (i + 1) * step;
      return (m ~/ 60, m % 60);
    });
  }

  /// Evaluates all candidates and returns the final filtered list of scheduled reminders.
  List<ReminderCandidate> generateSchedule({
    required NotificationSettings settings,
    required ReminderContext context,
  }) {
    final candidates = <ReminderCandidate>[];

    // 1. Water reminders (spread across waking hours, skip when goal is met)
    if (settings.isEnabled(NotificationType.waterReminder) && !context.isWaterGoalMet) {
      final waterSlots = calculateWaterSlots(
        count: NotificationType.waterReminder.slotCount,
        wakeHour: context.wakeHour,
        sleepHour: context.sleepHour,
      );
      for (var i = 0; i < waterSlots.length; i++) {
        final slot = waterSlots[i];
        candidates.add(
          ReminderCandidate(
            type: NotificationType.waterReminder,
            slotIndex: i,
            hour: slot.$1,
            minute: slot.$2,
            priority: 4, // water is normal priority
          ),
        );
      }
    }

    // 2. Meal reminders (from Today Plan times or custom times)
    final mealTypes = [
      (NotificationType.mealBreakfastReminder, MealType.breakfast),
      (NotificationType.mealLunchReminder, MealType.lunch),
      (NotificationType.mealDinnerReminder, MealType.dinner),
    ];
    for (final entry in mealTypes) {
      final notifType = entry.$1;
      final mealType = entry.$2;
      if (settings.isEnabled(notifType)) {
        final time = settings.customTimes[notifType] ??
            context.mealTimes[mealType] ??
            settings.timeFor(notifType);
        candidates.add(
          ReminderCandidate(
            type: notifType,
            slotIndex: 0,
            hour: time.hour,
            minute: time.minute,
            priority: 2, // meals are high priority
            mealType: mealType,
          ),
        );
      }
    }

    // 3. Fasting window opens/closes
    if (settings.isEnabled(NotificationType.fastingWindowOpenReminder)) {
      final time = settings.customTimes[NotificationType.fastingWindowOpenReminder] ??
          context.fastingOpenTime ??
          settings.timeFor(NotificationType.fastingWindowOpenReminder);
      candidates.add(
        ReminderCandidate(
          type: NotificationType.fastingWindowOpenReminder,
          slotIndex: 0,
          hour: time.hour,
          minute: time.minute,
          priority: 2,
        ),
      );
    }
    if (settings.isEnabled(NotificationType.fastingWindowCloseReminder)) {
      final time = settings.customTimes[NotificationType.fastingWindowCloseReminder] ??
          context.fastingCloseTime ??
          settings.timeFor(NotificationType.fastingWindowCloseReminder);
      candidates.add(
        ReminderCandidate(
          type: NotificationType.fastingWindowCloseReminder,
          slotIndex: 0,
          hour: time.hour,
          minute: time.minute,
          priority: 2,
        ),
      );
    }

    // 4. Workout reminder (preferred time from onboarding/settings)
    if (settings.isEnabled(NotificationType.workoutReminder) && context.hasWorkoutToday) {
      final time = settings.customTimes[NotificationType.workoutReminder] ??
          context.preferredWorkoutTime ??
          settings.workoutTime ??
          settings.timeFor(NotificationType.workoutReminder);
      candidates.add(
        ReminderCandidate(
          type: NotificationType.workoutReminder,
          slotIndex: 0,
          hour: time.hour,
          minute: time.minute,
          priority: 1, // workout is highest priority
        ),
      );
    }

    // 5. Steps nudge at 18:00 if under 50% of goal
    if (settings.isEnabled(NotificationType.stepsNudgeReminder)) {
      final isUnder50 = context.dailyStepsGoal > 0 &&
          (context.currentSteps < (context.dailyStepsGoal * 0.5));
      if (isUnder50) {
        final time = settings.customTimes[NotificationType.stepsNudgeReminder] ??
            settings.timeFor(NotificationType.stepsNudgeReminder);
        candidates.add(
          ReminderCandidate(
            type: NotificationType.stepsNudgeReminder,
            slotIndex: 0,
            hour: time.hour,
            minute: time.minute,
            priority: 3,
          ),
        );
      }
    }

    // 6. Bedtime reminder
    if (settings.isEnabled(NotificationType.bedtimeReminder)) {
      final time = settings.customTimes[NotificationType.bedtimeReminder] ??
          settings.timeFor(NotificationType.bedtimeReminder);
      candidates.add(
        ReminderCandidate(
          type: NotificationType.bedtimeReminder,
          slotIndex: 0,
          hour: time.hour,
          minute: time.minute,
          priority: 3,
        ),
      );
    }

    // 7. Weekly check-in (Sundays at 09:00)
    if (settings.isEnabled(NotificationType.weeklyCheckInReminder)) {
      final time = settings.customTimes[NotificationType.weeklyCheckInReminder] ??
          settings.timeFor(NotificationType.weeklyCheckInReminder);
      candidates.add(
        ReminderCandidate(
          type: NotificationType.weeklyCheckInReminder,
          slotIndex: 0,
          hour: time.hour,
          minute: time.minute,
          priority: 2,
          weekday: DateTime.sunday,
        ),
      );
    }

    // 7b. Weekly Wrapped (Friday evening at 19:00 / 7:00 PM)
    if (settings.isEnabled(NotificationType.weeklyWrappedReminder)) {
      final time = settings.customTimes[NotificationType.weeklyWrappedReminder] ??
          settings.timeFor(NotificationType.weeklyWrappedReminder);
      candidates.add(
        ReminderCandidate(
          type: NotificationType.weeklyWrappedReminder,
          slotIndex: 0,
          hour: time.hour,
          minute: time.minute,
          priority: 2,
          weekday: DateTime.friday,
        ),
      );
    }

    // 8. Streak protection at 21:00 if nothing logged today
    if (settings.isEnabled(NotificationType.streakProtectionReminder)) {
      if (!context.hasLoggedToday) {
        final time = settings.customTimes[NotificationType.streakProtectionReminder] ??
            settings.timeFor(NotificationType.streakProtectionReminder);
        candidates.add(
          ReminderCandidate(
            type: NotificationType.streakProtectionReminder,
            slotIndex: 0,
            hour: time.hour,
            minute: time.minute,
            priority: 1, // high priority to prevent streak loss
          ),
        );
      }
    }

    // Filter out quiet hours and Ramadan fasting hours (for food/water)
    final filtered = candidates.where((c) {
      if (isInQuietHours(
        hour: c.hour,
        minute: c.minute,
        startHour: settings.quietHoursStartHour,
        startMinute: settings.quietHoursStartMinute,
        endHour: settings.quietHoursEndHour,
        endMinute: settings.quietHoursEndMinute,
      )) {
        return false;
      }

      // If Ramadan mode is on, suppress food and water reminders during fasting hours (Fajr to Maghrib)
      if (context.isRamadanMode &&
          context.fastingStartHour != null &&
          context.fastingEndHour != null) {
        final isFoodOrWater = c.type == NotificationType.waterReminder ||
            c.type == NotificationType.mealBreakfastReminder ||
            c.type == NotificationType.mealLunchReminder ||
            c.type == NotificationType.mealDinnerReminder;
        if (isFoodOrWater) {
          final tMin = c.hour * 60 + c.minute;
          final fStart = context.fastingStartHour! * 60 + (context.fastingStartMinute ?? 0);
          final fEnd = context.fastingEndHour! * 60 + (context.fastingEndMinute ?? 0);
          if (tMin >= fStart && tMin < fEnd) {
            return false;
          }
        }
      }

      return true;
    }).toList();

    // Group candidates into daily candidates vs weekly candidates
    final dailyCandidates = filtered.where((c) => c.weekday == null).toList();
    final weeklyCandidates = filtered.where((c) => c.weekday != null).toList();

    // Apply max daily cap to daily notifications
    final maxDaily = settings.maxDailyNotifications;
    List<ReminderCandidate> selectedDaily;
    if (dailyCandidates.length <= maxDaily) {
      selectedDaily = dailyCandidates;
    } else {
      // Sort by priority (ascending), then by slot/time order
      dailyCandidates.sort((a, b) {
        final p = a.priority.compareTo(b.priority);
        if (p != 0) return p;
        return a.minutesOfDay.compareTo(b.minutesOfDay);
      });
      selectedDaily = dailyCandidates.take(maxDaily).toList();
    }

    // Sort final list chronologically by time of day
    final result = [...selectedDaily, ...weeklyCandidates];
    result.sort((a, b) => a.minutesOfDay.compareTo(b.minutesOfDay));
    return result;
  }
}
