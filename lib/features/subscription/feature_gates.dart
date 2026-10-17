import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/install_date.dart';
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

  /// Free scans per day during the first [firstWeekDays] days after install.
  static const freeMealScansFirstWeek = 5;
  static const firstWeekDays = 7;

  /// Hidden fair-use cap for Pro (the UI says "unlimited").
  static const proMealScansPerDay = 40;

  /// AI coach chat is Pro-only.
  static const freeCoachMessagesPerDay = 0;
  static const proCoachMessagesPerDay = 30;

  static const freeHistoryDays = 7;

  /// The 2 diet programs available to free users.
  static const freeDietPrograms = <DietProgramId>{
    DietProgramId.balancedDeficit,
    DietProgramId.egyptianClean,
  };

  static const _rewardedExtraScansKey = 'rewarded_extra_scans_today';
  static const _rewardedDietProgramKeyPrefix = 'rewarded_unlock_diet_';
  static const _rewardedAiCoachKey = 'rewarded_unlock_ai_coach';
  static const _rewardedVitalityKey = 'rewarded_unlock_vitality_pro';
  static const _rewardedCoinProKey = 'rewarded_unlock_coin_pro';

  /// True while the install is younger than [firstWeekDays] days.
  /// Unknown install date => false (the stricter 3/day limit).
  static bool isFirstWeek({DateTime? now}) {
    if (!HiveService.isInitialized) return false;
    return isWithinFirstWeek(InstallDate.read(), now ?? DateTime.now());
  }

  /// Pure helper (unit-testable): is [installDate] within the first week at [now]?
  static bool isWithinFirstWeek(DateTime? installDate, DateTime now) {
    if (installDate == null) return false;
    return InstallDate.dayAge(installDate, now) < firstWeekDays;
  }

  /// Base free scans per day (5 in the first week, otherwise 3), no rewarded bonus.
  static int freeMealScansBaseToday({DateTime? now}) =>
      isFirstWeek(now: now) ? freeMealScansFirstWeek : freeMealScansPerDay;

  /// Total free meal scans allowed today:
  /// base (5 in the first 7 days, else 3) + rewarded scans.
  static int getDailyFreeMealScansAllowed() {
    if (!HiveService.isInitialized) return freeMealScansPerDay;
    final today = _todayKey();
    final extra = HiveService.settingsBox.get('${_rewardedExtraScansKey}_$today') as int? ?? 0;
    return freeMealScansBaseToday() + extra;
  }

  /// Grants +2 extra AI meal scans for today via rewarded ad.
  static Future<void> grantRewardedMealScans() async {
    if (!HiveService.isInitialized) return;
    final today = _todayKey();
    final current = HiveService.settingsBox.get('${_rewardedExtraScansKey}_$today') as int? ?? 0;
    await HiveService.settingsBox.put('${_rewardedExtraScansKey}_$today', current + 2);
  }

  /// Unlocks a diet program for 24 hours via rewarded ad.
  static Future<void> grantRewardedDietProgram(DietProgramId id) async {
    if (!HiveService.isInitialized) return;
    final expiry = DateTime.now().add(const Duration(hours: 24)).toIso8601String();
    await HiveService.settingsBox.put('$_rewardedDietProgramKeyPrefix${id.name}', expiry);
  }

  /// Unlocks the AI coach for 24 hours via rewarded ad.
  static Future<void> grantRewardedAiCoach() async {
    if (!HiveService.isInitialized) return;
    final expiry = DateTime.now().add(const Duration(hours: 24)).toIso8601String();
    await HiveService.settingsBox.put(_rewardedAiCoachKey, expiry);
  }

  /// Checks if AI coach is unlocked via rewarded ad.
  static bool isAiCoachRewardedUnlocked() {
    if (!HiveService.isInitialized) return false;
    final expiryStr = HiveService.settingsBox.get(_rewardedAiCoachKey) as String?;
    if (expiryStr == null) return false;
    final expiry = DateTime.tryParse(expiryStr);
    return expiry != null && expiry.isAfter(DateTime.now());
  }

  /// Unlocks today's Pro vitality protocol item via rewarded ad.
  static Future<void> grantRewardedVitalityItem() async {
    if (!HiveService.isInitialized) return;
    final today = _todayKey();
    await HiveService.settingsBox.put('${_rewardedVitalityKey}_$today', true);
  }

  /// Checks if today's Pro vitality item is unlocked via rewarded ad.
  static bool isVitalityRewardedUnlocked() {
    if (!HiveService.isInitialized) return false;
    final today = _todayKey();
    return HiveService.settingsBox.get('${_rewardedVitalityKey}_$today') as bool? ?? false;
  }

  /// Check whether a given diet program is unlocked for the current access level or rewarded unlock.
  static bool isDietProgramUnlocked(DietProgramId id, {required bool isPro}) {
    if (isPro) return true;
    if (freeDietPrograms.contains(id)) return true;
    if (HiveService.isInitialized) {
      final expiryStr = HiveService.settingsBox.get('$_rewardedDietProgramKeyPrefix${id.name}') as String?;
      if (expiryStr != null) {
        final expiry = DateTime.tryParse(expiryStr);
        if (expiry != null && expiry.isAfter(DateTime.now())) {
          return true;
        }
      }
    }
    return false;
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
  static bool canAccessVitalityPro({required bool isPro}) {
    if (isPro) return true;
    return isVitalityRewardedUnlocked();
  }

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
  /// P40: these surfaces stay free forever — never route them through a paywall.
  static bool neverPaywallRamadanMode({required bool ramadanEnabled}) =>
      ramadanEnabled;

  static bool neverPaywallBarcodeScan() => true;

  static bool neverPaywallWomensModule() => true;

  static bool shouldBypassPaywall({
    bool ramadanEnabled = false,
    bool barcodeScan = false,
    bool womensModule = false,
  }) {
    if (neverPaywallRamadanMode(ramadanEnabled: ramadanEnabled)) return true;
    if (barcodeScan && neverPaywallBarcodeScan()) return true;
    if (womensModule && neverPaywallWomensModule()) return true;
    return false;
  }

  static bool requirePro(
    BuildContext context,
    WidgetRef ref, {
    PaywallContext paywallContext = PaywallContext.standard,
    bool force = true,
    bool ramadanEnabled = false,
    bool barcodeScan = false,
    bool womensModule = false,
  }) {
    if (shouldBypassPaywall(
      ramadanEnabled: ramadanEnabled,
      barcodeScan: barcodeScan,
      womensModule: womensModule,
    )) {
      return true;
    }

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

  /// Unlocks 1 day of Pro via engagement coins.
  static Future<void> grantCoinsProDay() async {
    if (!HiveService.isInitialized) return;
    final expiry = DateTime.now().add(const Duration(hours: 24)).toIso8601String();
    await HiveService.settingsBox.put(_rewardedCoinProKey, expiry);
  }

  /// Checks if 1 day of Pro is unlocked via engagement coins.
  static bool isCoinProUnlocked() {
    if (!HiveService.isInitialized) return false;
    final expiryStr = HiveService.settingsBox.get(_rewardedCoinProKey) as String?;
    if (expiryStr == null) return false;
    final expiry = DateTime.tryParse(expiryStr);
    return expiry != null && expiry.isAfter(DateTime.now());
  }

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

/// Convenience Riverpod provider for checking PRO access anywhere.
/// Covers RevenueCat Pro, `pro_grants`, and coin-unlocked Pro days — no ads.
final isProUserProvider = Provider<bool>((ref) {
  if (FeatureGates.isCoinProUnlocked()) return true;
  final hasGrant = ref.watch(proGrantProvider).valueOrNull ?? false;
  if (hasGrant) return true;
  return ref.watch(subscriptionProvider).maybeWhen(
        data: (s) => s.hasPremiumAccess,
        orElse: () => false,
      );
});
