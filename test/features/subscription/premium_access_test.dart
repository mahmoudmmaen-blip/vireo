import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

void main() {
  group('paywallContextForSnapshot §2.8', () {
    test('trialExpired uses trialEnded paywall context', () {
      const snapshot = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.trialExpired,
      );
      expect(paywallContextForSnapshot(snapshot), PaywallContext.trialEnded);
    });

    test('expired subscription uses subscriptionExpired context', () {
      const snapshot = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.expired,
      );
      expect(
        paywallContextForSnapshot(snapshot),
        PaywallContext.subscriptionExpired,
      );
    });

    test('free tier uses standard paywall context', () {
      const snapshot = SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.free,
      );
      expect(paywallContextForSnapshot(snapshot), PaywallContext.standard);
    });
  });
}
