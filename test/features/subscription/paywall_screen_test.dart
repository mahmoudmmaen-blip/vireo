import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/local_pro_prices.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

void main() {
  Widget wrapWithTheme(Widget child, {SubscriptionSnapshot? snapshot}) {
    final sub = snapshot ?? SubscriptionSnapshot.demoFree;

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
    testWidgets('renders Egypt list prices, lifetime, CTA, restore, legal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(wrapWithTheme(const PaywallScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(PaywallScreen), findsOneWidget);

      expect(
        find.text(LocalProPrices.displayFor(SubscriptionPlanId.monthly, isAr: false)),
        findsWidgets,
      );
      expect(
        find.text(LocalProPrices.displayFor(SubscriptionPlanId.annual, isAr: false)),
        findsWidgets,
      );
      expect(
        find.text(LocalProPrices.displayFor(SubscriptionPlanId.lifetime, isAr: false)),
        findsWidgets,
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Restore'), findsOneWidget);

      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Medical Disclaimer'), findsOneWidget);
    });
  });

  test('local Egypt display prices match P57', () {
    expect(LocalProPrices.monthlyEgp, 99);
    expect(LocalProPrices.annualEgp, 499);
    expect(LocalProPrices.lifetimeEgp, 1499);
  });
}

class _MockSubscriptionNotifier extends SubscriptionNotifier {
  _MockSubscriptionNotifier(this._snapshot);
  final SubscriptionSnapshot _snapshot;

  @override
  Future<SubscriptionSnapshot> build() async => _snapshot;
}
