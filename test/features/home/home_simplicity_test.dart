import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/widgets/vireo_ad_widgets.dart';
import 'package:vireo/features/home/providers/feature_unlock_provider.dart';
import 'package:vireo/features/home/widgets/daily_score_hero_card.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';
import 'package:vireo/features/home/widgets/quick_water_card.dart';
import 'package:vireo/features/home/widgets/smart_next_action_card.dart';
import 'package:vireo/features/home/widgets/today_plan_section.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_simplicity_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    HiveService.setInitializedForTesting(false);
    await Hive.close();
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  Widget buildApp({
    required List<Override> overrides,
    Locale locale = const Locale('ar'),
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.dark,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: HomeDashboardBody(),
        ),
      ),
    );
  }

  group('Home Simplicity & Max 5 Cards Rule', () {
    testWidgets('Day 1 user sees the 5 primary cards above the fold and progressive disclosure', (tester) async {
      await tester.pumpWidget(
        buildApp(
          overrides: [
            userJourneyDayProvider.overrideWithValue(1),
            isAdvancedFeaturesUnlockedProvider.overrideWith((ref) => FeatureUnlockNotifier(false)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Card 1: Daily Score + Steps hero
      expect(find.byType(DailyScoreHeroCard), findsOneWidget);

      // Card 2: "الخطوة الجاية" smart next-action card
      expect(find.byType(SmartNextActionCard), findsOneWidget);

      // Card 3: Today Plan collapsed
      expect(find.byType(TodayPlanSection), findsOneWidget);

      // Card 4: Water quick card
      expect(find.byType(QuickWaterCard), findsOneWidget);

      // Card 5: Native ad slot
      expect(find.byType(VireoNativeAdCard), findsOneWidget);

      // Advanced sections ("المزيد والتحليلات") should NOT appear on Day 1
      expect(find.text('المزيد والتحليلات'), findsNothing);
    });

    testWidgets('Day 3+ user unlocks advanced features under progressive disclosure section', (tester) async {
      await tester.pumpWidget(
        buildApp(
          overrides: [
            userJourneyDayProvider.overrideWithValue(3),
            isAdvancedFeaturesUnlockedProvider.overrideWith((ref) => FeatureUnlockNotifier(true)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Core 5 cards are still present
      expect(find.byType(DailyScoreHeroCard), findsOneWidget);
      expect(find.byType(SmartNextActionCard), findsOneWidget);
      expect(find.byType(TodayPlanSection), findsOneWidget);
      expect(find.byType(QuickWaterCard), findsOneWidget);
      expect(find.byType(VireoNativeAdCard), findsOneWidget);

      // Advanced section is now unlocked and present
      expect(find.text('المزيد والتحليلات'), findsOneWidget);
    });

    testWidgets('Manual override unlocks advanced features even on Day 1', (tester) async {
      final notifier = FeatureUnlockNotifier(false);
      await notifier.unlockAllManually();

      await tester.pumpWidget(
        buildApp(
          overrides: [
            userJourneyDayProvider.overrideWithValue(1),
            isAdvancedFeaturesUnlockedProvider.overrideWith((ref) => notifier),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Advanced section is now visible due to manual unlock
      expect(find.text('المزيد والتحليلات'), findsOneWidget);
    });
  }, skip: 'TODO: Hive mock hang');
}
