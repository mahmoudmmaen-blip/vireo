/// Subscription access level used for feature gating across the app.
enum SubscriptionAccessLevel {
  /// Basic tracking only (weight log, walking).
  free,

  /// Premium features during an active free trial.
  trialActive,

  /// Trial ended without conversion — paywall required for premium features.
  trialExpired,

  /// Active paid subscription (monthly, annual, or lifetime).
  premium,

  /// Paid subscription lapsed — premium gated, basic tracking remains.
  expired,
}

/// Identifiers for RevenueCat offering packages.
enum SubscriptionPlanId {
  monthly('monthly'),
  annual('annual'),
  lifetime('lifetime');

  const SubscriptionPlanId(this.packageId);
  final String packageId;
}

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.priceString,
    required this.packageIdentifier,
    this.isBestValue = false,
    this.trialLabel,
  });

  final SubscriptionPlanId id;
  final String title;
  final String priceString;
  final String packageIdentifier;
  final bool isBestValue;
  final String? trialLabel;
}

class SubscriptionSnapshot {
  const SubscriptionSnapshot({
    required this.accessLevel,
    this.trialDaysRemaining,
    this.activePlanId,
    this.plans = const [],
    this.isConfigured = false,
  });

  final SubscriptionAccessLevel accessLevel;
  final int? trialDaysRemaining;
  final SubscriptionPlanId? activePlanId;
  final List<SubscriptionPlan> plans;
  final bool isConfigured;

  bool get hasPremiumAccess =>
      accessLevel == SubscriptionAccessLevel.trialActive ||
      accessLevel == SubscriptionAccessLevel.premium;

  bool get shouldShowTrialEndedGate =>
      accessLevel == SubscriptionAccessLevel.trialExpired;

  bool get shouldShowExpiredGate =>
      accessLevel == SubscriptionAccessLevel.expired;

  bool get canUseUnlimitedFridgeScans => hasPremiumAccess;

  bool get canAccessFullProgramPhases => hasPremiumAccess;

  /// Basic tracking stays available on every tier.
  bool get canLogWeight => true;

  bool get canTrackWalking => true;

  SubscriptionSnapshot copyWith({
    SubscriptionAccessLevel? accessLevel,
    int? trialDaysRemaining,
    SubscriptionPlanId? activePlanId,
    List<SubscriptionPlan>? plans,
    bool? isConfigured,
  }) {
    return SubscriptionSnapshot(
      accessLevel: accessLevel ?? this.accessLevel,
      trialDaysRemaining: trialDaysRemaining ?? this.trialDaysRemaining,
      activePlanId: activePlanId ?? this.activePlanId,
      plans: plans ?? this.plans,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }

  static const demoFree = SubscriptionSnapshot(
    accessLevel: SubscriptionAccessLevel.free,
    isConfigured: false,
    plans: [
      SubscriptionPlan(
        id: SubscriptionPlanId.monthly,
        title: 'Monthly',
        priceString: '\$9.99/mo',
        packageIdentifier: 'monthly',
      ),
      SubscriptionPlan(
        id: SubscriptionPlanId.annual,
        title: 'Annual',
        priceString: '\$59.99/yr',
        packageIdentifier: 'annual',
        isBestValue: true,
      ),
      SubscriptionPlan(
        id: SubscriptionPlanId.lifetime,
        title: 'Lifetime',
        priceString: '\$149.99',
        packageIdentifier: 'lifetime',
      ),
    ],
  );
}
