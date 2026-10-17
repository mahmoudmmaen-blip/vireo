import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/install_date.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/notifications/domain/nurture_plan.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

/// Hive (settings box) flag: the user hit a goal during the first week.
/// Only then is the D6 share-card message scheduled.
const nurtureGoalHitKey = 'nurture_goal_hit';

/// Everything the planner needs. Pure data, so it is trivial to unit-test.
@immutable
class NurtureContext {
  const NurtureContext({
    required this.installDate,
    required this.now,
    required this.localeCode,
    required this.isFemale,
    required this.goalHit,
    required this.maxDailyNotifications,
    this.regularDailyCount = 0,
    this.quietStartHour = 23,
    this.quietStartMinute = 0,
    this.quietEndHour = 7,
    this.quietEndMinute = 0,
    this.isRamadan = false,
    this.iftarMinutes,
    this.usualLunchLogMinutes,
    this.usualDinnerLogMinutes,
  });

  /// First open / install date (Hive).
  final DateTime installDate;
  final DateTime now;
  final String localeCode;
  final bool isFemale;

  /// The user hit a goal in the first week (gates D6).
  final bool goalHit;

  /// User's daily notification cap (default 2).
  final int maxDailyNotifications;

  /// Recurring reminders already scheduled per day by [ReminderScheduler].
  /// Nurture needs one free slot on top of these.
  final int regularDailyCount;

  final int quietStartHour;
  final int quietStartMinute;
  final int quietEndHour;
  final int quietEndMinute;

  final bool isRamadan;
  final int? iftarMinutes;

  /// Median time (minutes since midnight) the user usually logs lunch / dinner.
  final int? usualLunchLogMinutes;
  final int? usualDinnerLogMinutes;
}

/// One concrete notification to schedule.
@immutable
class NurtureSlot {
  const NurtureSlot({
    required this.day,
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int day;
  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String payload;

  @override
  String toString() => 'NurtureSlot(day: $day, when: $when)';
}

/// Pure planner: [NurtureContext] → the slots to schedule. No I/O.
abstract final class NurturePlanner {
  /// Rules:
  /// - Days 1–7 after the install day, at most ONE nurture message per day, and
  ///   only while `regularDailyCount + 1 <= maxDailyNotifications` (max 2/day).
  /// - D6 (share card) only when [NurtureContext.goalHit].
  /// - Never inside quiet hours (shifted to just outside them).
  /// - Past times are skipped (the planner is safe to re-run any time).
  static List<NurtureSlot> plan(NurtureContext c) {
    if (c.maxDailyNotifications < 1) return const [];
    if (c.regularDailyCount + 1 > c.maxDailyNotifications) return const [];

    final slots = <NurtureSlot>[];
    for (final step in NurturePlan.steps) {
      if (step.requiresGoalHit && !c.goalHit) continue;

      final preferred = NurturePlan.preferredMinutes(
        step,
        usualLunchLogMinutes: c.usualLunchLogMinutes,
        usualDinnerLogMinutes: c.usualDinnerLogMinutes,
        isRamadan: c.isRamadan,
        iftarMinutes: c.iftarMinutes,
      );
      final minutes = NurturePlan.avoidQuietHours(
        preferred,
        startHour: c.quietStartHour,
        startMinute: c.quietStartMinute,
        endHour: c.quietEndHour,
        endMinute: c.quietEndMinute,
      );
      if (minutes == null) continue;

      // DateTime normalises day overflow (e.g. Jan 31 + 1).
      final when = DateTime(
        c.installDate.year,
        c.installDate.month,
        c.installDate.day + step.day,
        minutes ~/ 60,
        minutes % 60,
      );
      if (!when.isAfter(c.now)) continue;

      final text = NurturePlan.resolve(
        step,
        localeCode: c.localeCode,
        isFemale: c.isFemale,
        isRamadan: c.isRamadan,
      );
      slots.add(
        NurtureSlot(
          day: step.day,
          id: NurturePlan.notificationId(step.day),
          when: when,
          title: text.title,
          body: text.body,
          payload: step.payload,
        ),
      );
    }
    return slots;
  }

  /// Median minute-of-day of [times] that fall inside [fromHour, toHour).
  /// Needs at least [minSamples] logs, otherwise null (use the defaults).
  static int? usualLogMinutes(
    Iterable<DateTime> times, {
    required int fromHour,
    required int toHour,
    int minSamples = 3,
  }) {
    final minutes = times
        .where((t) => t.hour >= fromHour && t.hour < toHour)
        .map((t) => t.hour * 60 + t.minute)
        .toList()
      ..sort();
    if (minutes.length < minSamples) return null;
    return minutes[minutes.length ~/ 2];
  }
}

/// Where planned slots end up. A seam so the scheduler is testable.
abstract interface class NurtureNotificationSink {
  Future<void> cancelNurture();
  Future<void> schedule(NurtureSlot slot);
}

/// flutter_local_notifications implementation (same channel as the regular reminders).
class LocalNurtureNotificationSink implements NurtureNotificationSink {
  LocalNurtureNotificationSink({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'vireo_reminders_channel';
  static const _channelName = 'Vireo Smart Reminders';
  static const _channelDesc =
      'Timely, warm reminders for water, meals, workouts, and wellness.';

  @override
  Future<void> cancelNurture() async {
    if (kIsWeb) return;
    try {
      for (var d = NurturePlan.firstDay; d <= NurturePlan.lastDay; d++) {
        await _plugin.cancel(NurturePlan.notificationId(d));
      }
    } catch (_) {
      // Non-fatal.
    }
  }

  @override
  Future<void> schedule(NurtureSlot slot) async {
    if (kIsWeb) return;
    try {
      await _plugin.zonedSchedule(
        slot.id,
        slot.title,
        slot.body,
        tz.TZDateTime.from(slot.when, tz.local),
        const NotificationDetails(
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
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: slot.payload,
      );
    } catch (_) {
      // Skip individual slot failures (notifications are best-effort).
    }
  }
}

/// Schedules the first-week nurture notifications (idempotent).
class NurtureScheduler {
  NurtureScheduler({
    required this.sink,
    required this.readContext,
    required this.canNotify,
  });

  final NurtureNotificationSink sink;

  /// Null when there is nothing to schedule (no install date, reminders off…).
  final NurtureContext? Function() readContext;

  /// Notification permission granted AND the user has reminders enabled.
  final Future<bool> Function() canNotify;

  /// Cancels the old nurture notifications and schedules the current plan.
  /// Returns the scheduled slots.
  Future<List<NurtureSlot>> reschedule() async {
    await sink.cancelNurture();
    final ctx = readContext();
    if (ctx == null) return const [];
    if (!await canNotify()) return const [];

    final slots = NurturePlanner.plan(ctx);
    for (final slot in slots) {
      await sink.schedule(slot);
    }
    return slots;
  }

  /// Call when the user hits a goal. Unlocks D6 and re-plans.
  Future<void> markGoalHit() async {
    if (!HiveService.isInitialized) return;
    final already = HiveService.settingsBox.get(nurtureGoalHitKey) == true;
    if (already) return;
    final install = InstallDate.read();
    if (install == null || !NurturePlan.isActiveWindow(install, DateTime.now())) {
      return;
    }
    await HiveService.settingsBox.put(nurtureGoalHitKey, true);
    await reschedule();
  }
}

NurtureContext? _buildContext(Ref ref) {
  final install = InstallDate.read();
  if (install == null) return null;
  final now = DateTime.now();
  if (!NurturePlan.isActiveWindow(install, now)) return null;

  final settings = ref.read(notificationSettingsProvider);
  if (!settings.hasAnyEnabled) return null;

  final ramadan = ref.read(ramadanSettingsProvider);
  final prayer = ramadan.isEnabled ? ref.read(ramadanPrayerTimesProvider) : null;

  final logTimes = ref.read(aiMealLogProvider).map((e) => e.loggedAt).toList();

  final goalHit = HiveService.isInitialized &&
      HiveService.settingsBox.get(nurtureGoalHitKey) == true;

  return NurtureContext(
    installDate: install,
    now: now,
    localeCode: ref.read(localeProvider).languageCode,
    isFemale: UserSexNotifier.isFemaleSaved(),
    goalHit: goalHit,
    maxDailyNotifications: settings.maxDailyNotifications,
    quietStartHour: settings.quietHoursStartHour,
    quietStartMinute: settings.quietHoursStartMinute,
    quietEndHour: settings.quietHoursEndHour,
    quietEndMinute: settings.quietHoursEndMinute,
    isRamadan: ramadan.isEnabled,
    iftarMinutes:
        prayer == null ? null : prayer.maghrib.hour * 60 + prayer.maghrib.minute,
    usualLunchLogMinutes: NurturePlanner.usualLogMinutes(
      logTimes,
      fromHour: 10,
      toHour: 16,
    ),
    usualDinnerLogMinutes: NurturePlanner.usualLogMinutes(
      logTimes,
      fromHour: 17,
      toHour: 22,
    ),
  );
}

final nurtureSchedulerProvider = Provider<NurtureScheduler>((ref) {
  return NurtureScheduler(
    sink: LocalNurtureNotificationSink(),
    readContext: () => _buildContext(ref),
    canNotify: () async {
      if (!ref.read(notificationSettingsProvider).hasAnyEnabled) return false;
      return ref.read(notificationServiceProvider).hasPermission();
    },
  );
});

/// Runs once after the regular reminders were bootstrapped (watch it from the shell).
final nurtureBootstrapProvider = FutureProvider<void>((ref) async {
  if (!HiveService.isInitialized) return;
  await ref.watch(notificationBootstrapProvider.future);
  await ref.read(nurtureSchedulerProvider).reschedule();
});
