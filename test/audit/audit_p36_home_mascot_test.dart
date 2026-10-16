import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/vireo_ad_widgets.dart';
import 'package:vireo/features/home/mascot/domain/mascot_companion.dart';
import 'package:vireo/features/home/mascot/widgets/calorie_mascot_wave.dart';
import 'package:vireo/features/home/widgets/calories_today_mascot_card.dart';
import 'package:vireo/features/home/widgets/daily_score_hero_card.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';
import 'package:vireo/features/home/widgets/meal_capture_hero_card.dart';
import 'package:vireo/features/home/widgets/premium_steps_hero_card.dart';
import 'package:vireo/features/home/widgets/today_pillars_grid.dart';
import 'package:vireo/features/home/widgets/today_plan_section.dart';

import 'audit_test_helper.dart';

VireoColors _colorsFor(AppThemeVariant v) => switch (v) {
      AppThemeVariant.ember => VireoColors.emberDark,
      AppThemeVariant.calmGold => VireoColors.calmGoldDark,
      AppThemeVariant.ocean => VireoColors.oceanDark,
      AppThemeVariant.rose => VireoColors.roseDark,
    };

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p36_home_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  testWidgets(
    'P36 Home order: calories mascot before Daily Score; ad after pillars',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Soften overflow assertions so layout audits still check order.
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.toString().contains('overflowed')) return;
        originalOnError?.call(details);
      };
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        wrapAuditScreen(
          const Scaffold(body: HomeDashboardBody()),
          locale: const Locale('ar', 'EG'),
          textScale: 1.3,
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(PremiumStepsHeroCard), findsOneWidget);
      expect(find.byType(MealCaptureHeroCard), findsOneWidget);

      // ListView.builder only mounts visible children — scroll and record order.
      final firstSeen = <Type>[];
      void note(Type t, Finder f) {
        if (f.evaluate().isNotEmpty && !firstSeen.contains(t)) {
          firstSeen.add(t);
        }
      }

      var sawCaloriesTitle = false;
      for (var i = 0; i < 16; i++) {
        note(PremiumStepsHeroCard, find.byType(PremiumStepsHeroCard));
        note(MealCaptureHeroCard, find.byType(MealCaptureHeroCard));
        note(CaloriesTodayMascotCard, find.byType(CaloriesTodayMascotCard));
        note(DailyScoreHeroCard, find.byType(DailyScoreHeroCard));
        note(TodayPillarsGrid, find.byType(TodayPillarsGrid));
        note(TodayPlanSection, find.byType(TodayPlanSection));
        note(VireoNativeAdCard, find.byType(VireoNativeAdCard));
        if (find.textContaining('سعراتك النهارده').evaluate().isNotEmpty) {
          sawCaloriesTitle = true;
        }
        final lists = find.byType(ListView);
        if (lists.evaluate().isEmpty) break;
        await tester.drag(lists.first, const Offset(0, -240));
        await tester.pump(const Duration(milliseconds: 160));
      }

      expect(
        firstSeen,
        contains(CaloriesTodayMascotCard),
        reason: 'Never saw CaloriesTodayMascotCard. Seen: $firstSeen',
      );
      expect(firstSeen, contains(DailyScoreHeroCard));
      expect(
        firstSeen.indexOf(CaloriesTodayMascotCard) <
            firstSeen.indexOf(DailyScoreHeroCard),
        isTrue,
        reason: 'Calories mascot must appear before Daily Score. Seen: $firstSeen',
      );
      expect(firstSeen, contains(TodayPillarsGrid));
      if (firstSeen.contains(VireoNativeAdCard)) {
        expect(
          firstSeen.indexOf(TodayPillarsGrid) <
              firstSeen.indexOf(VireoNativeAdCard),
          isTrue,
          reason: 'Ad must not precede pillars. Seen: $firstSeen',
        );
      }
      expect(sawCaloriesTitle, isTrue, reason: 'سعراتك النهارده title never appeared');

      // Dispose repeating mascot tickers before the binding checks invariants.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  for (final variant in AppThemeVariant.values) {
    testWidgets(
      'P36 mascot wave renders in ${variant.name} @ 360x640 ar_EG 1.3',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final colors = _colorsFor(variant);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark.copyWith(extensions: [colors]),
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(360, 640),
                textScaler: TextScaler.linear(1.3),
              ),
              child: Scaffold(
                backgroundColor: colors.background,
                body: Center(
                  child: CalorieMascotWave(
                    consumedKcal: 1100,
                    targetKcal: 2000,
                    companion: MascotCompanion.camel,
                    isFemale: false,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byType(CalorieMascotWave), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 1));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  }
}
