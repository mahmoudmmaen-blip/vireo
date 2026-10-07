import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:vireo/features/notifications/data/notification_messages.dart';
import 'package:vireo/features/notifications/domain/i_notification_service.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';

typedef LocaleCodeReader = String Function();
typedef WeeklyDeficitReader = int? Function();
typedef HasWorkoutTodayReader = bool Function();

class LocalNotificationService implements INotificationService {
  LocalNotificationService({
    required LocaleCodeReader readLocaleCode,
    required WeeklyDeficitReader readWeeklyDeficit,
    required HasWorkoutTodayReader hasWorkoutToday,
  })  : _readLocaleCode = readLocaleCode,
        _readWeeklyDeficit = readWeeklyDeficit,
        _hasWorkoutToday = hasWorkoutToday;

  final LocaleCodeReader _readLocaleCode;
  final WeeklyDeficitReader _readWeeklyDeficit;
  final HasWorkoutTodayReader _hasWorkoutToday;

  static const _channelId = 'vireo_channel';
  static const _channelName = 'Vireo Reminders';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (kIsWeb || _initialized) return;

    try {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.local);

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
      );

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        const channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          importance: Importance.high,
          playSound: true,
        );
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      _initialized = true;
    } catch (_) {
      // Non-fatal — notifications remain unavailable.
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final status = await Permission.notification.request();
        if (status.isGranted) return true;
        return _androidNotificationsEnabled();
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        final granted = await ios?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
        return granted;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  @override
  Future<bool> hasPermission() async {
    if (kIsWeb) return false;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final status = await Permission.notification.status;
        if (status.isGranted) return true;
        return _androidNotificationsEnabled();
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        final settings = await ios?.checkPermissions();
        return settings?.isEnabled ?? false;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> _androidNotificationsEnabled() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await android?.areNotificationsEnabled();
    return enabled ?? false;
  }

  @override
  Future<void> scheduleAll(NotificationSettings settings) async {
    if (kIsWeb || !_initialized) return;

    await cancelAll();

    final locale = _readLocaleCode();
    final weeklyDeficit = _readWeeklyDeficit();

    for (final type in NotificationType.values) {
      if (!settings.isEnabled(type)) continue;

      switch (type) {
        case NotificationType.waterReminder:
          await _scheduleWater(settings, locale);
        case NotificationType.preWorkoutReminder:
          if (_hasWorkoutToday()) {
            await _schedulePreWorkout(settings, locale);
          }
        case NotificationType.weeklyReportReminder:
          await _scheduleWeekly(locale, weeklyDeficit);
        default:
          await _scheduleDailyFixed(type, locale, weeklyDeficit);
      }
    }
  }

  Future<void> _scheduleWater(NotificationSettings settings, String locale) async {
    for (var i = 0; i < waterReminderHours.length; i++) {
      final hour = waterReminderHours[i];
      final message = NotificationMessages.forType(
        NotificationType.waterReminder,
        localeCode: locale,
      );
      await _zonedDaily(
        id: NotificationType.waterReminder.notificationId(i),
        hour: hour,
        minute: 0,
        title: message.title,
        body: message.body,
      );
    }
  }

  Future<void> _scheduleDailyFixed(
    NotificationType type,
    String locale,
    int? weeklyDeficit,
  ) async {
    final time = type.fixedDailyTime;
    if (time == null) return;

    final message = NotificationMessages.forType(
      type,
      localeCode: locale,
      weeklyDeficitKcal: weeklyDeficit,
    );

    await _zonedDaily(
      id: type.notificationId(),
      hour: time.$1,
      minute: time.$2,
      title: message.title,
      body: message.body,
      weekday: type == NotificationType.weeklyReportReminder
          ? DateTime.sunday
          : null,
    );
  }

  Future<void> _scheduleWeekly(String locale, int? weeklyDeficit) async {
    final message = NotificationMessages.forType(
      NotificationType.weeklyReportReminder,
      localeCode: locale,
      weeklyDeficitKcal: weeklyDeficit,
    );
    await _zonedDaily(
      id: NotificationType.weeklyReportReminder.notificationId(),
      hour: 9,
      minute: 0,
      title: message.title,
      body: message.body,
      weekday: DateTime.sunday,
    );
  }

  Future<void> _schedulePreWorkout(
    NotificationSettings settings,
    String locale,
  ) async {
    final workout = settings.workoutTime ?? const TimeOfDay(hour: 18, minute: 0);
    var hour = workout.hour;
    var minute = workout.minute - 30;
    if (minute < 0) {
      minute += 60;
      hour -= 1;
    }
    if (hour < 0) hour = 0;

    final message = NotificationMessages.forType(
      NotificationType.preWorkoutReminder,
      localeCode: locale,
    );

    await _zonedDaily(
      id: NotificationType.preWorkoutReminder.notificationId(),
      hour: hour,
      minute: minute,
      title: message.title,
      body: message.body,
    );
  }

  Future<void> _zonedDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    int? weekday,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (weekday != null) {
        scheduled = _nextWeekdayTime(now, weekday, hour, minute);
      } else if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _details(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: weekday != null
            ? DateTimeComponents.dayOfWeekAndTime
            : DateTimeComponents.time,
      );
    } catch (_) {
      // Skip individual slot failures.
    }
  }

  tz.TZDateTime _nextWeekdayTime(
    tz.TZDateTime now,
    int weekday,
    int hour,
    int minute,
  ) {
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  @override
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {
      // Non-fatal.
    }
  }

  @override
  Future<void> cancelType(NotificationType type) async {
    if (kIsWeb) return;
    try {
      for (var i = 0; i < type.slotCount; i++) {
        await _plugin.cancel(type.notificationId(i));
      }
    } catch (_) {
      // Non-fatal.
    }
  }

  @override
  Future<void> showInstant(String title, String body, NotificationType type) async {
    if (kIsWeb || !_initialized) return;

    try {
      await _plugin.show(
        type.notificationId(99),
        title,
        body,
        _details(),
      );
    } catch (_) {
      // Non-fatal.
    }
  }
}
