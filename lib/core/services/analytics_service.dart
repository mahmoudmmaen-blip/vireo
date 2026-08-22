import 'package:flutter/foundation.dart';
import 'package:vireo/core/analytics/analytics_events.dart';

export 'package:vireo/core/analytics/analytics_events.dart';

/// Lightweight analytics facade (Section 14). Wire to PostHog/Firebase later.
abstract final class AnalyticsService {
  static Future<void> logEvent(
    String name, {
    Map<String, Object?> properties = const {},
  }) async {
    if (kDebugMode) {
      debugPrint('[analytics] $name $properties');
    }
  }

  static Future<void> mealSwapped({
    required String fromRecipeId,
    required String toRecipeId,
    required String mealType,
    required int dayIndex,
    String? cuisineFrom,
    String? cuisineTo,
  }) =>
      logEvent(
        AnalyticsEvents.mealSwapped,
        properties: {
          'from_recipe_id': fromRecipeId,
          'to_recipe_id': toRecipeId,
          'meal_type': mealType,
          'day_index': dayIndex,
          if (cuisineFrom != null) 'cuisine_from': cuisineFrom,
          if (cuisineTo != null) 'cuisine_to': cuisineTo,
        },
      );

  static Future<void> fridgeScanUsed({
    required int itemsDetectedCount,
    String? scanId,
    int? remainingScans,
    required bool isPremium,
  }) =>
      logEvent(
        AnalyticsEvents.fridgeScanUsed,
        properties: {
          'items_detected_count': itemsDetectedCount,
          if (scanId != null) 'scan_id': scanId,
          if (remainingScans != null) 'remaining_scans': remainingScans,
          'is_premium': isPremium,
        },
      );
}
