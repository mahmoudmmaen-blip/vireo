import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

void main() {
  Widget wrapWithTheme(Widget child, {SubscriptionSnapshot? snapshot}) {
    final sub = snapshot ??
        const SubscriptionSnapshot(
          accessLevel: SubscriptionAccessLevel.free,
          plans: [
            SubscriptionPlan(
              id: SubscriptionPlanId.monthly,
              title: 'Monthly',
              priceString: '\$9.99/mo',
              packageIdentifier: 'monthly',
              rawPrice: 9.99,
              currencyCode: 'USD',
            ),
            SubscriptionPlan(
              id: SubscriptionPlanId.annual,
              title: 'Annual',
              priceString: '\$59.99/yr',
              packageIdentifier: 'annual',
              rawPrice: 59.99,
              currencyCode: 'USD',
            ),
          ],
        );

    return ProviderScope(
      overrides: [
        subscriptionProvider.overrideWith(() => _MockSubscriptionNotifier(sub)),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    );
  }

  group('PaywallScreen widget test', () {
    testWidgets('renders plans, CTA button, and legal compliance links', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(wrapWithTheme(const PaywallScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(PaywallScreen), findsOneWidget);

      // Verify pricing plans
      expect(find.text('\$59.99/yr'), findsOneWidget);
      expect(find.text('\$9.99/mo'), findsOneWidget);

      // Verify CTA button exists
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify legal compliance links
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Medical Disclaimer'), findsOneWidget);
    });
  });
}

class _MockSubscriptionNotifier extends SubscriptionNotifier {
  _MockSubscriptionNotifier(this._snapshot);
  final SubscriptionSnapshot _snapshot;

  @override
  Future<SubscriptionSnapshot> build() async => _snapshot;
}
