import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/notifications/data/local_notification_service.dart';
import 'package:vireo/features/notifications/domain/i_notification_service.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/notifications/domain/reminder_scheduler.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

const _notificationSettingsKey = 'notification_settings';
const notificationPermissionRequestedKey = 'notification_permission_requested';

final notificationServiceProvider = Provider<INotificationService>((ref) {
  return LocalNotificationService(
    readLocaleCode: () => ref.read(localeProvider).languageCode,
    readWeeklyDeficit: () {
      final summary = ref.read(weeklyDeficitProvider);
      return summary.hasData ? summary.totalNetKcal : null;
    },
    hasWorkoutToday: () {
      final session = ref.read(todayWorkoutProvider).valueOrNull;
      return session != null && session.exercises.isNotEmpty;
    },
    reminderContextProvider: () {
      final waterCurrent = ref.read(waterTrackerProvider);
      final waterGoal = ref.read(waterDailyGoalMlProvider);
      final stepsCurrent = ref.read(todayStepsProvider);
      final stepsGoal =
          ref.read(walkingContextProvider).valueOrNull?.dailyGoal ?? 6000;
      final workoutSession = ref.read(todayWorkoutProvider).valueOrNull;
      final hasWorkout =
          workoutSession != null && workoutSession.exercises.isNotEmpty;

      // Has logged today check
      final confirmedMeals = ref.read(confirmedMealsProvider);
      final vitalityLog = ref.read(vitalityDailyLogProvider);
      final hasLogged = waterCurrent > 0 ||
          confirmedMeals.isNotEmpty ||
          vitalityLog.workoutCompleted ||
          vitalityLog.sunlightDone ||
          vitalityLog.breathingSessions > 0 ||
          stepsCurrent > 0;

      // Meal times from plan
      final meals = ref.read(effectiveTodayMealsProvider).valueOrNull ?? [];
      final mealTimes = <MealType, TimeOfDay>{};
      for (final meal in meals) {
        final defTime = meal.mealType == MealType.breakfast
            ? const TimeOfDay(hour: 8, minute: 30)
            : meal.mealType == MealType.lunch
                ? const TimeOfDay(hour: 13, minute: 0)
                : const TimeOfDay(hour: 19, minute: 30);
        mealTimes[meal.mealType] = defTime;
      }

      // Fasting window
      final fastingStatus = ref.read(fastingWindowStatusProvider);
      TimeOfDay? fastingOpen;
      TimeOfDay? fastingClose;
      if (fastingStatus != null) {
        fastingOpen = TimeOfDay(hour: fastingStatus.startHour, minute: 0);
        final closeHour =
            (fastingStatus.startHour + fastingStatus.eatingHours) % 24;
        fastingClose = TimeOfDay(hour: closeHour, minute: 0);
      }

      final preferredWorkout = readPreferredWorkoutTimeFromProfile();
      final weeklyDeficit = ref.read(weeklyDeficitProvider);

      final ramadan = ref.read(ramadanSettingsProvider);
      final prayer = ramadan.isEnabled ? ref.read(ramadanPrayerTimesProvider) : null;

      return ReminderContext(
        isWaterGoalMet: waterGoal > 0 && waterCurrent >= waterGoal,
        currentSteps: stepsCurrent,
        dailyStepsGoal: stepsGoal,
        hasLoggedToday: hasLogged,
        hasWorkoutToday: hasWorkout,
        mealTimes: mealTimes,
        fastingOpenTime: fastingOpen,
        fastingCloseTime: fastingClose,
        preferredWorkoutTime: preferredWorkout,
        weeklyDeficitKcal:
            weeklyDeficit.hasData ? weeklyDeficit.totalNetKcal : null,
        isRamadanMode: ramadan.isEnabled,
        fastingStartHour: prayer?.fajr.hour,
        fastingStartMinute: prayer?.fajr.minute,
        fastingEndHour: prayer?.maghrib.hour,
        fastingEndMinute: prayer?.maghrib.minute,
      );
    },
    onNotificationTap: (payload) {
      if (payload == null || payload.isEmpty) return;
      _handleDeepLink(ref, payload);
    },
  );
});

void _handleDeepLink(Ref ref, String payload) {
  final uri = Uri.tryParse(payload);
  if (uri == null) return;

  final host = uri.host;
  final path = uri.path;

  if (host == 'quick_log' || path.contains('water')) {
    ref.read(shellTabIndexProvider.notifier).goHome();
  } else if (host == 'nutrition' || path.contains('nutrition')) {
    MealType? tab;
    if (payload.contains('breakfast')) tab = MealType.breakfast;
    if (payload.contains('lunch')) tab = MealType.lunch;
    if (payload.contains('dinner')) tab = MealType.dinner;
    ref.read(shellTabIndexProvider.notifier).goNutrition(mealTab: tab);
  } else if (host == 'workout' || path.contains('workout')) {
    ref.read(shellTabIndexProvider.notifier).goWorkout();
  } else if (host == 'progress' || path.contains('progress')) {
    ref.read(shellTabIndexProvider.notifier).goProgress();
  } else if (host == 'diary' || path.contains('diary')) {
    ref.read(shellTabIndexProvider.notifier).goDiary();
  } else {
    ref.read(shellTabIndexProvider.notifier).goHome();
  }
}

final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  return ref.read(notificationServiceProvider).hasPermission();
});

final hasWorkoutScheduledProvider = Provider<bool>((ref) {
  final session = ref.watch(todayWorkoutProvider).valueOrNull;
  return session != null && session.exercises.isNotEmpty;
});

final notificationPermissionRequestedProvider = Provider<bool>((ref) {
  if (!HiveService.isInitialized) return false;
  return HiveService.settingsBox.get(notificationPermissionRequestedKey) == true;
});

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    return _loadFromHive();
  }

  NotificationSettings _loadFromHive() {
    final hasWorkout = ref.read(hasWorkoutScheduledProvider);
    if (!HiveService.isInitialized) {
      return NotificationSettings(
        enabledMap: defaultEnabledMap(hasWorkoutToday: hasWorkout),
      );
    }

    try {
      final raw = HiveService.settingsBox.get(_notificationSettingsKey);
      if (raw is Map) {
        var settings = NotificationSettings.fromStorageMap(
          Map<String, dynamic>.from(raw),
          hasWorkoutToday: hasWorkout,
        );
        if (settings.workoutTime == null) {
          final preferred = readPreferredWorkoutTimeFromProfile();
          if (preferred != null) {
            settings = settings.withWorkoutTime(preferred);
          }
        }
        return settings;
      }
    } catch (_) {
      // Fall through to defaults.
    }

    return NotificationSettings(
      enabledMap: defaultEnabledMap(hasWorkoutToday: hasWorkout),
    );
  }

  Future<void> _persist(NotificationSettings settings) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.settingsBox.put(
        _notificationSettingsKey,
        settings.toStorageMap(),
      );
    } catch (_) {
      // Non-fatal.
    }
  }

  Future<void> reschedule() async {
    final service = ref.read(notificationServiceProvider);
    if (state.hasAnyEnabled) {
      await service.scheduleAll(state);
    } else {
      await service.cancelAll();
    }
  }

  Future<void> toggleType(NotificationType type) async {
    final nextEnabled = !state.isEnabled(type);
    final updated = state.copyWith(
      enabledMap: {...state.enabledMap, type: nextEnabled},
    );
    state = updated;
    await _persist(updated);

    final service = ref.read(notificationServiceProvider);
    if (nextEnabled) {
      await service.scheduleAll(updated);
    } else {
      await service.cancelType(type);
    }
  }

  Future<void> setReminderTime(NotificationType type, TimeOfDay time) async {
    final updatedTimes = Map<NotificationType, TimeOfDay>.from(state.customTimes);
    updatedTimes[type] = time;
    var updated = state.copyWith(customTimes: updatedTimes);
    if (type == NotificationType.workoutReminder) {
      updated = updated.copyWith(
        workoutHour: time.hour,
        workoutMinute: time.minute,
      );
    }
    state = updated;
    await _persist(updated);
    await reschedule();
  }

  Future<void> setWorkoutTime(TimeOfDay time) async {
    await setReminderTime(NotificationType.workoutReminder, time);
  }

  Future<void> setQuietHours({
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) async {
    final updated = state.copyWith(
      quietHoursStartHour: startHour,
      quietHoursStartMinute: startMinute,
      quietHoursEndHour: endHour,
      quietHoursEndMinute: endMinute,
    );
    state = updated;
    await _persist(updated);
    await reschedule();
  }

  Future<void> setMaxDailyNotifications(int max) async {
    final updated = state.copyWith(maxDailyNotifications: max);
    state = updated;
    await _persist(updated);
    await reschedule();
  }

  Future<void> applySettings(NotificationSettings settings) async {
    state = settings;
    await _persist(settings);
    await reschedule();
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

/// Initializes notifications on app launch without prompting for permission unasked.
final notificationBootstrapProvider = FutureProvider<void>((ref) async {
  if (!HiveService.isInitialized) return;

  final service = ref.read(notificationServiceProvider);
  await service.initialize();

  final settings = ref.read(notificationSettingsProvider);
  if (settings.hasAnyEnabled) {
    await service.scheduleAll(settings);
  }
});

TimeOfDay? readPreferredWorkoutTimeFromProfile() {
  if (!HiveService.isInitialized) return null;

  final prefs = HiveService.settingsBox.get('notification_preferences');
  if (prefs is Map) {
    final iso = prefs['preferred_workout_time'] as String?;
    if (iso != null) {
      final dt = DateTime.tryParse(iso);
      if (dt != null) return TimeOfDay(hour: dt.hour, minute: dt.minute);
    }
  }

  return null;
}
