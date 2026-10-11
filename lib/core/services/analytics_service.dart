import 'package:flutter/foundation.dart';
import 'package:vireo/core/analytics/analytics_events.dart';

export 'package:vireo/core/analytics/analytics_events.dart';

/// Lightweight analytics facade with strict privacy standards (no health/food values).
abstract final class AnalyticsService {
  static Future<void> logEvent(
    String name, {
    Map<String, Object?> properties = const {},
  }) async {
    if (kDebugMode) {
      debugPrint('[analytics] $name $properties');
    }
  }

  static Future<void> appOpen({required String environment, required String locale}) =>
      logEvent('app_open', properties: {'environment': environment, 'locale': locale});

  static Future<void> onboardingStepViewed({
    required int stepIndex,
    required String stepName,
  }) =>
      logEvent(
        AnalyticsEvents.onboardingStepViewed,
        properties: {
          'step_index': stepIndex,
          'step_name': stepName,
        },
      );

  static Future<void> onboardingStepCompleted({
    required int stepIndex,
    required String stepName,
    Map<String, Object?> properties = const {},
  }) =>
      logEvent(
        AnalyticsEvents.onboardingStepCompleted,
        properties: {
          'step_index': stepIndex,
          'step_name': stepName,
          ...properties,
        },
      );

  static Future<void> scanStarted({required String mode}) =>
      logEvent('scan_started', properties: {'mode': mode});

  static Future<void> scanSucceeded({required int itemsCount, int? durationMs}) =>
      logEvent('scan_succeeded', properties: {
        'items_count': itemsCount,
        'duration_ms': ?durationMs,
      });

  static Future<void> scanFailed({required String errorType}) =>
      logEvent('scan_failed', properties: {'error_type': errorType});

  static Future<void> mealSaved({required String mealType, required bool hasPhoto}) =>
      logEvent('meal_saved', properties: {'meal_type': mealType, 'has_photo': hasPhoto});

  static Future<void> coachMessage({required int turnCount}) =>
      logEvent('coach_message', properties: {'turn_count': turnCount});

  static Future<void> workoutCompleted({required int exercisesCount, required int durationMin}) =>
      logEvent(
        AnalyticsEvents.workoutCompleted,
        properties: {
          'exercises_count': exercisesCount,
          'duration_min': durationMin,
        },
      );

  static Future<void> paywallViewed({required String source}) =>
      logEvent(AnalyticsEvents.paywallViewed, properties: {'source': source});

  static Future<void> purchaseStarted({required String planId}) =>
      logEvent('purchase_started', properties: {'plan_id': planId});

  static Future<void> purchaseCompleted({required String planId, required bool hasTrial}) =>
      logEvent(
        AnalyticsEvents.subscriptionStarted,
        properties: {'plan_id': planId, 'has_trial': hasTrial},
      );

  static Future<void> reminderOpened({required String reminderType}) =>
      logEvent('reminder_opened', properties: {'reminder_type': reminderType});

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
          'cuisine_from': ?cuisineFrom,
          'cuisine_to': ?cuisineTo,
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
          'scan_id': ?scanId,
          'remaining_scans': ?remainingScans,
          'is_premium': isPremium,
        },
      );
}
