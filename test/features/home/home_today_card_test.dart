import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  group('TodayHeroCard widget test', () {
    testWidgets('renders calories left and macro bars', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const sampleData = TodayNutrition(
        goalKcal: 2000,
        eatenKcal: 1200,
        burnedKcal: 300,
        proteinG: 90,
        carbsG: 110,
        fatG: 45,
        proteinTarget: 140,
        carbsTarget: 180,
        fatTarget: 60,
        items: [],
      );

      var tappedCard = false;
      var tappedBurned = false;

      await tester.pumpWidget(
        wrapWithTheme(
          TodayHeroCard(
            data: sampleData,
            onTap: () => tappedCard = true,
            onBurnedTap: () => tappedBurned = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 1200));

      // Verifies calories remaining rendered (2000 - 1200 + 300 = 1100)
      expect(find.byType(TodayHeroCard), findsOneWidget);
      expect(find.text('1,100'), findsOneWidget);

      // Verify tap callbacks work
      await tester.tap(find.byType(TodayHeroCard));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tappedCard, isTrue);

      await tester.tap(find.text('300'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tappedBurned, isTrue);
    });
  });
}
