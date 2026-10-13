import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:vireo/features/fasting/domain/fasting_session.dart';

class FastingNotificationService {
  static final FastingNotificationService instance = FastingNotificationService._();
  FastingNotificationService._();

  static const _channelId = 'vireo_fasting_channel';
  static const _channelName = 'Vireo Fasting Timer';
  static const _channelDesc = 'Alerts and milestones for intermittent fasting.';

  static const int idHalfway = 2001;
  static const int idOneHourLeft = 2002;
  static const int idGoalReached = 2003;
  static const int idWindowClosing = 2004;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (kIsWeb || _initialized) return;
    try {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.local);
      _initialized = true;
    } catch (_) {}
  }

  NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// Schedules notifications for a starting fasting session.
  Future<void> scheduleSessionNotifications(FastingSession session, {required bool isArabic}) async {
    if (kIsWeb) return;
    await init();
    await cancelAllFastingNotifications();

    final now = DateTime.now();
    final targetDuration = session.targetDuration;
    final endTime = session.startTime.add(targetDuration);

    // 1. Halfway Notification
    final halfwayTime = session.startTime.add(targetDuration ~/ 2);
    if (halfwayTime.isAfter(now)) {
      _scheduleAt(
        id: idHalfway,
        time: halfwayTime,
        title: isArabic ? 'نصف المسافة! ⏱️' : 'Halfway there! ⏱️',
        body: isArabic
            ? 'وصلت لمنتصف ساعات الصيام بنجاح. حافظ على شرب الماء!'
            : 'You reached the halfway point. Keep staying hydrated!',
      );
    }

    // 2. 1 Hour Left Notification
    final oneHourLeftTime = endTime.subtract(const Duration(hours: 1));
    if (oneHourLeftTime.isAfter(now)) {
      _scheduleAt(
        id: idOneHourLeft,
        time: oneHourLeftTime,
        title: isArabic ? 'ساعة واحدة متبقية! ⏳' : '1 Hour Left! ⏳',
        body: isArabic
            ? 'باقي ساعة واحدة فقط على إكمال هدف صيامك اليوم. أحسنت!'
            : 'Just 1 hour left until your fasting goal is reached. Great job!',
      );
    }

    // 3. Goal Reached Notification
    if (endTime.isAfter(now)) {
      _scheduleAt(
        id: idGoalReached,
        time: endTime,
        title: isArabic ? 'أكملت هدف الصيام! 🎉' : 'Fasting Goal Reached! 🎉',
        body: isArabic
            ? 'مبروك! أتممت ${session.targetHours} ساعة صيام بنجاح (+15 عملة في رصيدك).'
            : 'Congrats! You completed your ${session.targetHours}h fast (+15 coins awarded).',
      );
    }
  }

  /// Schedules notification when eating window is about to close.
  Future<void> scheduleEatingWindowClosing(DateTime closingTime, {required bool isArabic}) async {
    if (kIsWeb) return;
    await init();
    final alertTime = closingTime.subtract(const Duration(minutes: 30));
    if (alertTime.isAfter(DateTime.now())) {
      _scheduleAt(
        id: idWindowClosing,
        time: alertTime,
        title: isArabic ? 'نافذة الطعام توشك على الانتهاء 🥗' : 'Eating Window Closing Soon 🥗',
        body: isArabic
            ? 'متبقي 30 دقيقة على بدء نافذة الصيام القادمة. اشرب ماء وتناول وجبتك الأخيرة.'
            : '30 minutes left before your eating window closes. Hydrate and prepare!',
      );
    }
  }

  Future<void> _scheduleAt({
    required int id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    try {
      final tzTime = tz.TZDateTime.from(time, tz.local);
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        _details(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {}
  }

  Future<void> cancelAllFastingNotifications() async {
    if (kIsWeb) return;
    try {
      await _plugin.cancel(idHalfway);
      await _plugin.cancel(idOneHourLeft);
      await _plugin.cancel(idGoalReached);
      await _plugin.cancel(idWindowClosing);
    } catch (_) {}
  }
}
