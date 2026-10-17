import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:vireo/core/services/install_date.dart';
import 'package:vireo/features/notifications/data/notification_messages.dart';
import 'package:vireo/features/notifications/domain/nurture_plan.dart';
import 'package:vireo/features/notifications/domain/i_notification_service.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/notifications/domain/reminder_scheduler.dart';

typedef LocaleCodeReader = String Function();
typedef WeeklyDeficitReader = int? Function();
typedef HasWorkoutTodayReader = bool Function();
typedef ReminderContextProvider = ReminderContext Function();
typedef NotificationTapHandler = void Function(String? payload);

class LocalNotificationService implements INotificationService {
  LocalNotificationService({
    required LocaleCodeReader readLocaleCode,
    required WeeklyDeficitReader readWeeklyDeficit,
    required HasWorkoutTodayReader hasWorkoutToday,
    ReminderContextProvider? reminderContextProvider,
    NotificationTapHandler? onNotificationTap,
    FlutterLocalNotificationsPlugin? plugin,
  })  : _readLocaleCode = readLocaleCode,
        _readWeeklyDeficit = readWeeklyDeficit,
        _hasWorkoutToday = hasWorkoutToday,
        _reminderContextProvider = reminderContextProvider,
        _onNotificationTap = onNotificationTap,
        _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final LocaleCodeReader _readLocaleCode;
  final WeeklyDeficitReader _readWeeklyDeficit;
  final HasWorkoutTodayReader _hasWorkoutToday;
  final ReminderContextProvider? _reminderContextProvider;
  final NotificationTapHandler? _onNotificationTap;

  static const _channelId = 'vireo_reminders_channel';
  static const _channelName = 'Vireo Smart Reminders';
  static const _channelDesc = 'Timely, warm reminders for water, meals, workouts, and wellness.';

  final FlutterLocalNotificationsPlugin _plugin;
  final ReminderScheduler _scheduler = const ReminderScheduler();
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
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          _onNotificationTap?.call(payload);
        },
      );

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        const channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
          playSound: true,
        );
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      // Check for launch notification if app was opened via notification tap
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp == true) {
        final payload = launchDetails?.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          _onNotificationTap?.call(payload);
        }
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

    // Keep the first-week nurture notifications (ids 7001-7007); they are
    // (re)scheduled by NurtureScheduler.
    await _cancelAllExceptNurture();

    // P40: max N per day INCLUDING the nurture message. During the first week
    // one daily slot is reserved for it.
    final install = InstallDate.read();
    final reserveForNurture = install != null &&
        settings.maxDailyNotifications >= 1 &&
        NurturePlan.isActiveWindow(install, DateTime.now());
    final effectiveSettings = reserveForNurture
        ? settings.copyWith(
            maxDailyNotifications: settings.maxDailyNotifications - 1,
          )
        : settings;

    final locale = _readLocaleCode();
    final weeklyDeficit = _readWeeklyDeficit();

    final reminderCtx = _reminderContextProvider != null
        ? _reminderContextProvider()
        : ReminderContext(
            isWaterGoalMet: false,
            currentSteps: 0,
            dailyStepsGoal: 6000,
            hasLoggedToday: false,
            hasWorkoutToday: _hasWorkoutToday(),
            weeklyDeficitKcal: weeklyDeficit,
          );

    final scheduledCandidates = _scheduler.generateSchedule(
      settings: effectiveSettings,
      context: reminderCtx,
    );

    for (final candidate in scheduledCandidates) {
      final message = NotificationMessages.forType(
        candidate.type,
        localeCode: locale,
        mealType: candidate.mealType,
        weeklyDeficitKcal: weeklyDeficit,
      );

      await _zonedDaily(
        id: candidate.id,
        hour: candidate.hour,
        minute: candidate.minute,
        title: message.title,
        body: message.body,
        payload: message.payload,
        weekday: candidate.weekday,
      );
    }
  }

  Future<void> _zonedDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String payload,
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
        payload: payload,
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
        channelDescription: _channelDesc,
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

  /// Cancels every pending notification except the first-week nurture ones.
  Future<void> _cancelAllExceptNurture() async {
    if (kIsWeb) return;
    try {
      final pending = await _plugin.pendingNotificationRequests();
      for (final p in pending) {
        if (NurturePlan.isNurtureId(p.id)) continue;
        await _plugin.cancel(p.id);
      }
    } catch (_) {
      // Fall back to the old behaviour; nurture is re-planned on next launch.
      await cancelAll();
    }
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
      final message = NotificationMessages.forType(
        type,
        localeCode: _readLocaleCode(),
      );
      await _plugin.show(
        type.notificationId(99),
        title,
        body,
        _details(),
        payload: message.payload,
      );
    } catch (_) {
      // Non-fatal.
    }
  }
}
