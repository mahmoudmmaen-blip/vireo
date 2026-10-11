import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

import 'package:vireo/features/subscription/feature_gates.dart';

/// Returns true when the user may proceed; otherwise opens the paywall.
bool requirePremiumAccess(
  BuildContext context,
  WidgetRef ref, {
  PaywallContext paywallContext = PaywallContext.standard,
}) {
  return FeatureGates.requirePro(
    context,
    ref,
    paywallContext: paywallContext,
    force: true,
  );
}

PaywallContext paywallContextForSnapshot(SubscriptionSnapshot snapshot) {
  if (snapshot.shouldShowTrialEndedGate) {
    return PaywallContext.trialEnded;
  }
  if (snapshot.shouldShowExpiredGate) {
    return PaywallContext.subscriptionExpired;
  }
  return PaywallContext.standard;
}
