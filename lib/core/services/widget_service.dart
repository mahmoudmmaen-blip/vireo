import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Service coordinating data updates to Android / iOS home-screen widgets.
class WidgetService {
  static const String appGroupId = 'group.com.vireofit.app';
  static const String androidWidgetSmall = 'VireoWidgetSmallProvider';
  static const String androidWidgetMedium = 'VireoWidgetMediumProvider';

  static const _lastPushKey = 'widget_last_push_ms';
  static const _minInterval = Duration(minutes: 30);

  /// Deep link opened when the user taps the home widget (camera meal log).
  static const String widgetLaunchUri = 'vireo://nutrition/camera';

  /// Sends updated snapshot data to the home-screen widgets.
  /// [force] bypasses the 30-minute throttle (e.g. after meal save).
  static Future<void> updateWidget({
    required int caloriesRemaining,
    required String mascotEmoji,
    required bool fastingActive,
    required int fastingRemainingMinutes,
    required bool isDarkTheme,
    required bool isRtl,
    int steps = 0,
    int waterMl = 0,
    int dailyScore = 0,
    bool force = false,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    if (!force) {
      final last =
          await HomeWidget.getWidgetData<int>(_lastPushKey, defaultValue: 0) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - last < _minInterval.inMilliseconds) return;
    }

    try {
      await HomeWidget.saveWidgetData<int>(
        'widget_calories_remaining',
        caloriesRemaining.clamp(0, 99999),
      );
      await HomeWidget.saveWidgetData<String>('widget_mascot_emoji', mascotEmoji);
      await HomeWidget.saveWidgetData<bool>('widget_fasting_active', fastingActive);
      await HomeWidget.saveWidgetData<int>(
        'widget_fasting_remaining_min',
        fastingRemainingMinutes.clamp(0, 9999),
      );
      await HomeWidget.saveWidgetData<bool>('widget_is_dark', isDarkTheme);
      await HomeWidget.saveWidgetData<bool>('widget_is_rtl', isRtl);

      // Legacy medium-widget fields
      await HomeWidget.saveWidgetData<int>('widget_daily_score', dailyScore);
      await HomeWidget.saveWidgetData<int>('widget_steps', steps);
      await HomeWidget.saveWidgetData<int>('widget_water_ml', waterMl);
      await HomeWidget.saveWidgetData<int>(
        _lastPushKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(androidName: androidWidgetSmall);
        await HomeWidget.updateWidget(androidName: androidWidgetMedium);
      }
    } catch (e) {
      debugPrint('[WidgetService] updateWidget failed: $e');
    }
  }
}
