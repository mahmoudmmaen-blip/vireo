import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

void main() {
  group('hasPremiumAccessProvider §2.8', () {
    test('reflects premium snapshot from subscription provider', () async {
      final container = ProviderContainer(
        overrides: [
          subscriptionProvider.overrideWith(
            () => _FixedSubscriptionNotifier(
              const SubscriptionSnapshot(
                accessLevel: SubscriptionAccessLevel.premium,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(subscriptionProvider.future);
      expect(container.read(hasPremiumAccessProvider), isTrue);
    });

    test('returns false for free tier', () async {
      final container = ProviderContainer(
        overrides: [
          subscriptionProvider.overrideWith(
            () => _FixedSubscriptionNotifier(
              const SubscriptionSnapshot(
                accessLevel: SubscriptionAccessLevel.free,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(subscriptionProvider.future);
      expect(container.read(hasPremiumAccessProvider), isFalse);
    });
  });
}

class _FixedSubscriptionNotifier extends SubscriptionNotifier {
  _FixedSubscriptionNotifier(this.snapshot);

  final SubscriptionSnapshot snapshot;

  @override
  Future<SubscriptionSnapshot> build() async => snapshot;
}
