import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

const softPaywallAfterThirdMealKey = 'soft_paywall_after_third_meal_shown';

/// Soft, dismissible Pro prompt after the **3rd** successful meal log (P57).
/// Never charges — opens [PaywallScreen] only; purchase is via Play sheet.
Future<void> maybeShowSoftPaywallAfterThirdMeal(
  BuildContext context,
  WidgetRef ref, {
  required int mealCountAfterSave,
}) async {
  if (mealCountAfterSave != 3) return;
  if (!HiveService.isInitialized) return;
  if (HiveService.settingsBox.get(softPaywallAfterThirdMealKey) == true) {
    return;
  }

  final isPro =
      ref.read(subscriptionProvider).valueOrNull?.hasPremiumAccess == true;
  if (isPro) return;

  await HiveService.settingsBox.put(softPaywallAfterThirdMealKey, true);
  if (!context.mounted) return;

  await openPaywall(context, paywallContext: PaywallContext.standard);
}

/// Back-compat alias used by older call sites.
@Deprecated('Use maybeShowSoftPaywallAfterThirdMeal')
Future<void> maybeShowSoftPaywallAfterFirstScan(
  BuildContext context,
  WidgetRef ref, {
  required int scanCountAfterSave,
}) {
  return maybeShowSoftPaywallAfterThirdMeal(
    context,
    ref,
    mealCountAfterSave: scanCountAfterSave,
  );
}
