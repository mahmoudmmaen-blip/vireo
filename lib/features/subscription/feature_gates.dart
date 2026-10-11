import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

/// Single source of truth for FREE vs PRO feature gating across Vireo.
abstract final class FeatureGates {
  // Quota limits
  static const freeMealScansPerDay = 3;
  static const proMealScansPerDay = 50;

  static const freeCoachMessagesPerDay = 20;
  static const proCoachMessagesPerDay = 200;

  static const freeHistoryDays = 7;

  /// The 2 diet programs available to free users.
  static const freeDietPrograms = <DietProgramId>{
    DietProgramId.balancedDeficit,
    DietProgramId.egyptianClean,
  };

  /// Check whether a given diet program is unlocked for the current access level.
  static bool isDietProgramUnlocked(DietProgramId id, {required bool isPro}) {
    if (isPro) return true;
    return freeDietPrograms.contains(id);
  }

  /// Check whether adaptive calorie recommendations are unlocked.
  static bool canAccessAdaptiveCalories({required bool isPro}) => isPro;

  /// Check whether weekly progress reports are unlocked.
  static bool canAccessWeeklyReport({required bool isPro}) => isPro;

  /// Check whether full history & long-term trends beyond 7 days are unlocked.
  static bool canAccessFullHistory({required bool isPro}) => isPro;

  /// Check whether GPS workout history is unlocked.
  static bool canAccessGpsWorkoutHistory({required bool isPro}) => isPro;

  /// Check whether wearable health trends are unlocked.
  static bool canAccessWearableHealthTrends({required bool isPro}) => isPro;

  /// Check whether Vitality Pro protocol is unlocked.
  static bool canAccessVitalityPro({required bool isPro}) => isPro;

  /// Check whether upsell banners should be hidden (no upsell banners on Pro).
  static bool shouldShowUpsellBanners({required bool isPro}) => !isPro;

  // ── Daily Paywall Trigger Throttling (Never more than once per day) ──
  static const _lastPaywallShownDateKey = 'paywall_last_shown_date';

  /// Returns true if paywall can be shown today.
  static bool canShowPaywallToday() {
    if (!HiveService.isInitialized) return true;
    final lastDate = HiveService.settingsBox.get(_lastPaywallShownDateKey) as String?;
    final today = _todayKey();
    return lastDate != today;
  }

  /// Records that the paywall was displayed today to prevent showing more than once per day.
  static Future<void> markPaywallShownToday() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_lastPaywallShownDateKey, _todayKey());
  }

  /// Triggers paywall with daily throttling.
  /// If [force] is true (e.g. user explicitly taps a PRO item or Upgrade button),
  /// the paywall will always open. If false (e.g. daily limit hit or auto trigger),
  /// it respects the "never more than once per day" rule.
  static Future<bool> triggerPaywall(
    BuildContext context, {
    PaywallContext paywallContext = PaywallContext.standard,
    bool force = false,
  }) async {
    if (!force && !canShowPaywallToday()) {
      return false;
    }

    await markPaywallShownToday();
    if (!context.mounted) return false;
    await openPaywall(context, paywallContext: paywallContext);
    return true;
  }

  /// Checks if the user is PRO. If not, triggers the paywall and returns false.
  /// For direct user interactions (tapping a PRO item), force: true opens the paywall.
  static bool requirePro(
    BuildContext context,
    WidgetRef ref, {
    PaywallContext paywallContext = PaywallContext.standard,
    bool force = true,
  }) {
    final snapshot = ref.read(subscriptionProvider).valueOrNull;
    if (snapshot?.hasPremiumAccess == true) return true;

    triggerPaywall(context, paywallContext: paywallContext, force: force);
    return false;
  }

  // ── Day-5 Trial Reminder Notification ──
  static const _trialReminderScheduledKey = 'trial_day_5_reminder_scheduled';

  /// Checks if user is in an active trial and schedules or delivers the day-5 reminder.
  /// (e.g. 2 days remaining in a 7-day trial).
  static Future<void> checkAndScheduleTrialReminder(WidgetRef ref) async {
    if (!HiveService.isInitialized) return;
    final sub = ref.read(subscriptionProvider).valueOrNull;
    if (sub == null) return;

    if (sub.accessLevel == SubscriptionAccessLevel.trialActive) {
      final daysRemaining = sub.trialDaysRemaining ?? 0;
      final alreadyScheduled =
          HiveService.settingsBox.get(_trialReminderScheduledKey) as bool? ?? false;

      // On day 5 of a 7-day trial, daysRemaining is <= 2
      if (daysRemaining <= 2 && !alreadyScheduled) {
        await HiveService.settingsBox.put(_trialReminderScheduledKey, true);
        final notifService = ref.read(notificationServiceProvider);
        final isArabic = ref.read(localeProvider).languageCode.startsWith('ar');
        await notifService.showInstant(
          isArabic ? '⏳ باقي يومين في تجربتك المجانية' : '⏳ 2 days left in your free trial',
          isArabic
              ? 'استكشف مميزات Vireo Pro المتقدمة قبل انتهاء الفترة التجريبية.'
              : 'Explore all Vireo Pro advanced features before your trial ends.',
          NotificationType.weeklyCheckInReminder,
        );
      }
    } else {
      // Reset if no longer in trial
      if (HiveService.settingsBox.containsKey(_trialReminderScheduledKey)) {
        await HiveService.settingsBox.delete(_trialReminderScheduledKey);
      }
    }
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

/// Convenience Riverpod provider for checking PRO access anywhere.
final isProUserProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).maybeWhen(
        data: (s) => s.hasPremiumAccess,
        orElse: () => false,
      );
});
