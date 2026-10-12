import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Service coordinating data updates to Android / iOS home-screen widgets.
class WidgetService {
  static const String appGroupId = 'group.com.vireofit.app';
  static const String androidWidgetSmall = 'VireoWidgetSmallProvider';
  static const String androidWidgetMedium = 'VireoWidgetMediumProvider';

  /// Sends updated snapshot data to the home-screen widgets.
  static Future<void> updateWidget({
    required int steps,
    required int waterMl,
    required int dailyScore,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    try {
      await HomeWidget.saveWidgetData<int>('widget_daily_score', dailyScore);
      await HomeWidget.saveWidgetData<int>('widget_steps', steps);
      await HomeWidget.saveWidgetData<int>('widget_water_ml', waterMl);

      // Trigger update for both small and medium Android widgets
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          androidName: androidWidgetSmall,
        );
        await HomeWidget.updateWidget(
          androidName: androidWidgetMedium,
        );
      }
    } catch (e) {
      debugPrint('[WidgetService] updateWidget failed: $e');
    }
  }
}
