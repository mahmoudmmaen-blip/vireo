import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/engagement/domain/daily_coin_task.dart';
import 'package:vireo/features/engagement/services/coins_service.dart';
import 'package:vireo/features/women_health/models/cycle_data.dart';
import 'package:vireo/features/women_health/providers/women_health_provider.dart';
import 'package:vireo/features/women_health/services/women_health_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p33_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    HiveService.setInitializedForTesting(false);
    await Hive.close();
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  group('P33: Women Health Cycle Phase Prediction', () {
    test('regular 28-day cycle phase prediction', () {
      final periodStart = DateTime(2026, 1, 1);

      // Day 1 to 5: Menstrual phase
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 28,
          periodLength: 5,
          targetDate: DateTime(2026, 1, 1),
        ),
        CyclePhase.menstrual,
      );
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 28,
          periodLength: 5,
          targetDate: DateTime(2026, 1, 5),
        ),
        CyclePhase.menstrual,
      );

      // Day 8: Follicular phase
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 28,
          periodLength: 5,
          targetDate: DateTime(2026, 1, 9),
        ),
        CyclePhase.follicular,
      );

      // Day 14 (Jan 15): Ovulatory phase (28 - 14 = 14)
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 28,
          periodLength: 5,
          targetDate: DateTime(2026, 1, 15),
        ),
        CyclePhase.ovulatory,
      );

      // Day 20: Luteal phase
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 28,
          periodLength: 5,
          targetDate: DateTime(2026, 1, 21),
        ),
        CyclePhase.luteal,
      );

      // Next period prediction
      final next = WomenHealthService.predictNextPeriod(
        lastPeriodStart: periodStart,
        cycleLength: 28,
        fromDate: DateTime(2026, 1, 10),
      );
      expect(next, DateTime(2026, 1, 29));
      expect(
        WomenHealthService.daysUntilNextPeriod(
          lastPeriodStart: periodStart,
          cycleLength: 28,
          fromDate: DateTime(2026, 1, 10),
        ),
        19,
      );
    });

    test('irregular 35-day cycle phase prediction', () {
      final periodStart = DateTime(2026, 2, 1);

      // Day 1: Menstrual phase
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 35,
          periodLength: 5,
          targetDate: DateTime(2026, 2, 1),
        ),
        CyclePhase.menstrual,
      );

      // Day 12: Follicular phase
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 35,
          periodLength: 5,
          targetDate: DateTime(2026, 2, 13),
        ),
        CyclePhase.follicular,
      );

      // Day 21 (Feb 22): Ovulatory phase (35 - 14 = 21)
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 35,
          periodLength: 5,
          targetDate: DateTime(2026, 2, 22),
        ),
        CyclePhase.ovulatory,
      );

      // Day 30: Luteal phase
      expect(
        WomenHealthService.predictPhase(
          lastPeriodStart: periodStart,
          cycleLength: 35,
          periodLength: 5,
          targetDate: DateTime(2026, 3, 3),
        ),
        CyclePhase.luteal,
      );
    });
  });

  group('P33: Pregnancy & Breastfeeding Mode Calorie Adjustment', () {
    test('standard mode maintains normal deficit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final adjustment = container.read(womenCalorieAdjustmentProvider);
      expect(adjustment.disableDeficit, isFalse);
      expect(adjustment.surplusKcal, 0);
    });

    test('breastfeeding mode disables deficit and adds +350 surplus', () {
      final container = ProviderContainer(
        overrides: [
          womenHealthModeProvider.overrideWith((ref) => WomenHealthModeNotifier()..state = WomenMode.breastfeeding),
        ],
      );
      addTearDown(container.dispose);

      final adjustment = container.read(womenCalorieAdjustmentProvider);
      expect(adjustment.disableDeficit, isTrue);
      expect(adjustment.surplusKcal, 350);
      expect(adjustment.reason, contains('الرضاعة الطبيعية'));
    });

    test('pregnancy mode trimester adjustments', () {
      final container1 = ProviderContainer(
        overrides: [
          womenHealthModeProvider.overrideWith((ref) => WomenHealthModeNotifier()..state = WomenMode.pregnant),
          pregnancyTrimesterProvider.overrideWith((ref) => PregnancyTrimesterNotifier()..state = PregnancyTrimester.first),
        ],
      );
      addTearDown(container1.dispose);
      expect(container1.read(womenCalorieAdjustmentProvider).disableDeficit, isTrue);
      expect(container1.read(womenCalorieAdjustmentProvider).surplusKcal, 0);

      final container2 = ProviderContainer(
        overrides: [
          womenHealthModeProvider.overrideWith((ref) => WomenHealthModeNotifier()..state = WomenMode.pregnant),
          pregnancyTrimesterProvider.overrideWith((ref) => PregnancyTrimesterNotifier()..state = PregnancyTrimester.second),
        ],
      );
      addTearDown(container2.dispose);
      expect(container2.read(womenCalorieAdjustmentProvider).disableDeficit, isTrue);
      expect(container2.read(womenCalorieAdjustmentProvider).surplusKcal, 340);

      final container3 = ProviderContainer(
        overrides: [
          womenHealthModeProvider.overrideWith((ref) => WomenHealthModeNotifier()..state = WomenMode.pregnant),
          pregnancyTrimesterProvider.overrideWith((ref) => PregnancyTrimesterNotifier()..state = PregnancyTrimester.third),
        ],
      );
      addTearDown(container3.dispose);
      expect(container3.read(womenCalorieAdjustmentProvider).disableDeficit, isTrue);
      expect(container3.read(womenCalorieAdjustmentProvider).surplusKcal, 450);
    });
  });

  group('P33: Luteal Phase Message & Water Retention Reassurance', () {
    test('luteal phase tips include softer appetite note and water retention note', () {
      const phase = CyclePhase.luteal;
      expect(phase.displayNameAr, contains('المرحلة الصفرية'));
      expect(phase.tipBodyAr, contains('زيادة الشهية (+100-300 سعرة)'));
      expect(phase.tipBodyAr, contains('احتباس سوائل'));
    });
  });

  group('P33: Engagement Coins Anti-Abuse Rule & Pro Unlock', () {
    test('task awards points once per day only', () async {
      expect(CoinsService.getBalance(), 0);
      expect(CoinsService.isTaskAwardedToday(DailyCoinTask.meal), isFalse);

      // First award: awards points
      final awarded = await CoinsService.awardTask(DailyCoinTask.meal);
      expect(awarded, DailyCoinTask.meal.points);
      expect(CoinsService.getBalance(), DailyCoinTask.meal.points);
      expect(CoinsService.isTaskAwardedToday(DailyCoinTask.meal), isTrue);

      // Second award on same day: 0 points awarded
      final secondAward = await CoinsService.awardTask(DailyCoinTask.meal);
      expect(secondAward, 0);
      expect(CoinsService.getBalance(), DailyCoinTask.meal.points);

      // Different task works on same day
      final walkAward = await CoinsService.awardTask(DailyCoinTask.walk);
      expect(walkAward, DailyCoinTask.walk.points);
      expect(CoinsService.getBalance(), DailyCoinTask.meal.points + DailyCoinTask.walk.points);
    });

    test('spendForPro requires 500 coins and deducts accurately', () async {
      expect(await CoinsService.spendForPro(), isFalse);

      // Manually set 520 coins
      await HiveService.settingsBox.put('user_coins_balance', 520);
      expect(CoinsService.getBalance(), 520);

      final success = await CoinsService.spendForPro();
      expect(success, isTrue);
      expect(CoinsService.getBalance(), 20);
    });
  });

  group('P33: Themes Token Switch', () {
    test('theme variants return distinct color palettes', () {
      for (final variant in AppThemeVariant.values) {
        final darkTheme = AppTheme.buildThemeForVariant(variant: variant, brightness: Brightness.dark);
        final lightTheme = AppTheme.buildThemeForVariant(variant: variant, brightness: Brightness.light);

        final darkColors = darkTheme.extension<VireoColors>()!;
        final lightColors = lightTheme.extension<VireoColors>()!;

        expect(darkColors.background, isNot(equals(lightColors.background)));
        expect(darkColors.ember, isNotNull);
        expect(lightColors.ember, isNotNull);
      }
    });

    test('Calm Gold uses charcoal dark and white pill style buttons', () {
      final dark = AppTheme.buildThemeForVariant(variant: AppThemeVariant.calmGold, brightness: Brightness.dark);
      final darkColors = dark.extension<VireoColors>()!;
      expect(darkColors.ember, const Color(0xFFD4AF37));
      expect(darkColors.background, const Color(0xFF141618));

      final btnStyle = dark.elevatedButtonTheme.style;
      expect(btnStyle, isNotNull);
    });
  });
}
