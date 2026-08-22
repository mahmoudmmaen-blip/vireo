/// Analytics event names (Section 14).
/// Source: `docs/analytics/event_tracking_plan.md`
abstract final class AnalyticsEvents {
  static const onboardingStepCompleted = 'onboarding_step_completed';
  static const trainingEnvironmentSelected = 'training_environment_selected';
  static const consentAccepted = 'consent_accepted';
  static const workoutStarted = 'workout_started';
  static const workoutCompleted = 'workout_completed';
  static const setCompleted = 'set_completed';
  static const exerciseSwapped = 'exercise_swapped';
  static const fridgeScanUsed = 'fridge_scan_used';
  static const mealSwapped = 'meal_swapped';
  static const weightLogged = 'weight_logged';
  static const reassessmentCompleted = 'reassessment_completed';
  static const paywallViewed = 'paywall_viewed';
  static const subscriptionStarted = 'subscription_started';
  static const subscriptionCancelled = 'subscription_cancelled';
  static const accountDeleted = 'account_deleted';
}
