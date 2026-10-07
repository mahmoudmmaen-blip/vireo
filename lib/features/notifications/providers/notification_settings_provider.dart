import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/notifications/data/local_notification_service.dart';
import 'package:vireo/features/notifications/domain/i_notification_service.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';

const _notificationSettingsKey = 'notification_settings';
const _permissionRequestedKey = 'notification_permission_requested';

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
  );
});

final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  return ref.read(notificationServiceProvider).hasPermission();
});

final hasWorkoutScheduledProvider = Provider<bool>((ref) {
  final session = ref.watch(todayWorkoutProvider).valueOrNull;
  return session != null && session.exercises.isNotEmpty;
});

final notificationPermissionRequestedProvider = Provider<bool>((ref) {
  if (!HiveService.isInitialized) return false;
  return HiveService.settingsBox.get(_permissionRequestedKey) == true;
});

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    return _loadFromHive();
  }

  NotificationSettings _loadFromHive() {
    final hasWorkout = ref.read(hasWorkoutScheduledProvider);
    if (!HiveService.isInitialized) {
      return NotificationSettings(enabledMap: defaultEnabledMap(hasWorkoutToday: hasWorkout));
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

    return NotificationSettings(enabledMap: defaultEnabledMap(hasWorkoutToday: hasWorkout));
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

  Future<void> _reschedule() async {
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

  Future<void> setWorkoutTime(TimeOfDay time) async {
    final updated = state.withWorkoutTime(time);
    state = updated;
    await _persist(updated);
    await _reschedule();
  }

  Future<void> applySettings(NotificationSettings settings) async {
    state = settings;
    await _persist(settings);
    await _reschedule();
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

/// Initializes notifications on app launch.
final notificationBootstrapProvider = FutureProvider<void>((ref) async {
  if (!HiveService.isInitialized) return;

  final service = ref.read(notificationServiceProvider);
  await service.initialize();

  final requested = ref.read(notificationPermissionRequestedProvider);
  if (!requested) {
    await service.requestPermission();
    await HiveService.settingsBox.put(_permissionRequestedKey, true);
  }

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
