import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/data/models/subscription_state.dart';

void main() {
  group('SubscriptionPlanId §2.8 RevenueCat plans', () {
    test('defines monthly, annual, and lifetime package ids', () {
      expect(SubscriptionPlanId.values.length, 3);
      expect(SubscriptionPlanId.monthly.packageId, 'monthly');
      expect(SubscriptionPlanId.annual.packageId, 'annual');
      expect(SubscriptionPlanId.lifetime.packageId, 'lifetime');
    });

    test('demo offering includes all three plans', () {
      expect(SubscriptionSnapshot.demoFree.plans.length, 3);
      expect(
        SubscriptionSnapshot.demoFree.plans.map((p) => p.id),
        containsAll(SubscriptionPlanId.values),
      );
    });
  });

  group('SubscriptionSnapshot §2.8 feature gating', () {
    test('hasPremiumAccess for trial and paid premium', () {
      const trial = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.trialActive,
        trialDaysRemaining: 3,
      );
      const premium = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.premium,
        activePlanId: SubscriptionPlanId.annual,
      );

      expect(trial.hasPremiumAccess, isTrue);
      expect(premium.hasPremiumAccess, isTrue);
      expect(trial.canUseUnlimitedFridgeScans, isTrue);
      expect(premium.canAccessFullProgramPhases, isTrue);
    });

    test('free, trialExpired, and expired tiers gate premium features', () {
      const free = SubscriptionSnapshot(accessLevel: SubscriptionAccessLevel.free);
      const trialExpired = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.trialExpired,
      );
      const expired = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.expired,
      );

      for (final snapshot in [free, trialExpired, expired]) {
        expect(snapshot.hasPremiumAccess, isFalse);
        expect(snapshot.canUseUnlimitedFridgeScans, isFalse);
        expect(snapshot.canAccessFullProgramPhases, isFalse);
      }
    });

    test('basic tracking stays available on every tier', () {
      for (final level in SubscriptionAccessLevel.values) {
        final snapshot = SubscriptionSnapshot(accessLevel: level);
        expect(snapshot.canLogWeight, isTrue);
        expect(snapshot.canTrackWalking, isTrue);
      }
    });

    test('trial and subscription expiry drive shell gates', () {
      const trialExpired = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.trialExpired,
      );
      const lapsed = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.expired,
      );

      expect(trialExpired.shouldShowTrialEndedGate, isTrue);
      expect(lapsed.shouldShowExpiredGate, isTrue);
    });
  });

  group('RevenueCatService §2.8 config', () {
    test('premium entitlement id is premium', () {
      expect(RevenueCatService.premiumEntitlementId, 'premium');
    });
  });
}
