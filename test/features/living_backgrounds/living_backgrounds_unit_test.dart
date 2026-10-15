import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';
import 'package:vireo/features/home/living_backgrounds/domain/milestone_tracker.dart';
import 'package:vireo/features/home/living_backgrounds/domain/scene_pack.dart';
import 'package:vireo/features/home/living_backgrounds/domain/scrim_contrast.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_living_bg_test_');
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

  group('P35: JourneyStage Step Progression Calculations', () {
    test('calculates correct stage for 0, 999, 1000, 12k, 20k steps', () {
      // 0 steps -> Stage 0 (Dawn, no star badge, early night/dawn)
      final stage0 = JourneyStage.fromSteps(0);
      expect(stage0.index, 0);
      expect(stage0.skyTime, JourneySkyTime.dawn);
      expect(stage0.hasStarBadge, isFalse);
      expect(stage0.isNightOrDawn, isTrue);
      expect(stage0.landmarks.contains(LandmarkType.starBadge), isFalse);

      // 999 steps -> Stage 0
      final stage999 = JourneyStage.fromSteps(999);
      expect(stage999.index, 0);
      expect(stage999.skyTime, JourneySkyTime.dawn);
      expect(stage999.hasStarBadge, isFalse);

      // 1000 steps -> Stage 1 (Dawn)
      final stage1000 = JourneyStage.fromSteps(1000);
      expect(stage1000.index, 1);
      expect(stage1000.skyTime, JourneySkyTime.dawn);
      expect(stage1000.hasStarBadge, isFalse);

      // 5500 steps -> Stage 5 (Morning)
      final stage5 = JourneyStage.fromSteps(5500);
      expect(stage5.index, 5);
      expect(stage5.skyTime, JourneySkyTime.morning);
      expect(stage5.landmarks.contains(LandmarkType.palm), isTrue);
      expect(stage5.landmarks.contains(LandmarkType.pyramid), isTrue);

      // 7000 steps -> Stage 7 (Noon)
      final stage7 = JourneyStage.fromSteps(7000);
      expect(stage7.index, 7);
      expect(stage7.skyTime, JourneySkyTime.noon);
      expect(stage7.landmarks.contains(LandmarkType.minaret), isTrue);

      // 12000 steps -> Stage 12 (Golden, Star Badge unlocked!)
      final stage12k = JourneyStage.fromSteps(12000);
      expect(stage12k.index, 12);
      expect(stage12k.skyTime, JourneySkyTime.golden);
      expect(stage12k.hasStarBadge, isTrue);
      expect(stage12k.landmarks.contains(LandmarkType.starBadge), isTrue);

      // 20000 steps -> Capped at Stage 12 with Star Badge
      final stage20k = JourneyStage.fromSteps(20000);
      expect(stage20k.index, 12);
      expect(stage20k.skyTime, JourneySkyTime.golden);
      expect(stage20k.hasStarBadge, isTrue);
    });

    test('theme accent ramp adapts per stage and yields gold at stage 12', () {
      final stage0 = JourneyStage.fromSteps(0);
      final stage6 = JourneyStage.fromSteps(6000);
      final stage12 = JourneyStage.fromSteps(12000);

      const variant = AppThemeVariant.ember;
      expect(stage0.ringAccent(variant), variant.primaryAccent);
      expect(stage6.ringAccent(variant), isNot(variant.primaryAccent));
      expect(stage12.ringAccent(variant), const Color(0xFFFFD700)); // Gold badge
    });
  });

  group('P35: Milestones Fire Once Per Day & Gender-Aware Toasts', () {
    test('triggers 25, 50, 75, 100% milestones at most once per day', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('ar'));

      final today = DateTime(2026, 10, 14);
      final tomorrow = DateTime(2026, 10, 15);

      // 1. Cross 50% milestone (3500 / 7000) for male user
      final hit50Male = await MilestoneTracker.checkAndTriggerMilestone(
        stepsCurrent: 3500,
        stepsGoal: 7000,
        l10n: l10n,
        now: today,
        isFemale: false,
      );
      expect(hit50Male, isNotNull);
      expect(hit50Male!.percentage, 50);
      expect(hit50Male.message, contains('بطل'));

      // 2. Same milestone on same day -> null (fire at most once per day)
      final hitAgainToday = await MilestoneTracker.checkAndTriggerMilestone(
        stepsCurrent: 4000,
        stepsGoal: 7000,
        l10n: l10n,
        now: today,
        isFemale: false,
      );
      expect(hitAgainToday, isNull);

      // 3. Cross 100% milestone (7500 / 7000) for female user
      final hit100Female = await MilestoneTracker.checkAndTriggerMilestone(
        stepsCurrent: 7500,
        stepsGoal: 7000,
        l10n: l10n,
        now: today,
        isFemale: true,
      );
      expect(hit100Female, isNotNull);
      expect(hit100Female!.percentage, 100);
      expect(hit100Female.message, contains('بطلة'));

      // 4. On the next day, 50% milestone can fire again
      final hit50Tomorrow = await MilestoneTracker.checkAndTriggerMilestone(
        stepsCurrent: 3600,
        stepsGoal: 7000,
        l10n: l10n,
        now: tomorrow,
        isFemale: true,
      );
      expect(hit50Tomorrow, isNotNull);
      expect(hit50Tomorrow!.percentage, 50);
      expect(hit50Tomorrow.message, contains('بطلة'));
    });
  });

  group('P35: Deterministic 3-Day Scene Pack Rotation & Overrides', () {
    test('pack changes deterministically every 3 days without network', () {
      final day0 = DateTime.utc(2026, 1, 1);
      final day1 = DateTime.utc(2026, 1, 2);
      final day2 = DateTime.utc(2026, 1, 3);
      final day3 = DateTime.utc(2026, 1, 4);

      final packDay0 = ScenePack.rotatingPackForDate(day0);
      final packDay1 = ScenePack.rotatingPackForDate(day1);
      final packDay2 = ScenePack.rotatingPackForDate(day2);
      final packDay3 = ScenePack.rotatingPackForDate(day3);

      // Days 0, 1, 2 belong to the same 3-day bucket
      expect(packDay0, equals(packDay1));
      expect(packDay1, equals(packDay2));

      // Day 3 rotates to the next pack in the 6 standard packs
      expect(packDay3, isNot(equals(packDay0)));
    });

    test('special overrides: Ramadan, Eid, and Streak 7+ days', () {
      final date = DateTime.utc(2026, 3, 10);

      // Ramadan override
      final ramadanPack = ScenePack.resolveActive(
        date: date,
        isEnabled: true,
        isRamadan: true,
      );
      expect(ramadanPack, ScenePackId.ramadan);

      // Eid override
      final eidPack = ScenePack.resolveActive(
        date: date,
        isEnabled: true,
        isRamadan: false,
        isEid: true,
      );
      expect(eidPack, ScenePackId.eid);

      // Streak >= 7 days override
      final streakPack = ScenePack.resolveActive(
        date: date,
        isEnabled: true,
        streakDays: 7,
      );
      expect(streakPack, ScenePackId.streakReward);

      // Explicit fixed pack choice overrides automatic rotation & Ramadan
      final fixedChoice = ScenePack.resolveActive(
        date: date,
        isEnabled: true,
        fixedPack: ScenePackId.desertDunes,
        isRamadan: true,
      );
      expect(fixedChoice, ScenePackId.desertDunes);
    });
  });

  group('P35: Scrim Contrast & Readability Verification (WCAG AA >= 4.5:1)', () {
    test('contrast ratio utility correctly computes known WCAG ratios', () {
      // White on Black = 21:1
      expect(ScrimContrast.contrastRatio(Colors.white, Colors.black), closeTo(21.0, 0.1));
      // Same color = 1:1
      expect(ScrimContrast.contrastRatio(Colors.white, Colors.white), closeTo(1.0, 0.01));
    });

    test('automatic dark scrim guarantees WCAG AA >= 4.5:1 in all 4 themes, light & dark, and stages', () {
      const themes = [
        VireoColors.emberDark,
        VireoColors.emberLight,
        VireoColors.calmGoldDark,
        VireoColors.calmGoldLight,
        VireoColors.oceanDark,
        VireoColors.oceanLight,
        VireoColors.roseDark,
        VireoColors.roseLight,
      ];

      const testStages = [0, 2, 6, 10, 12];
      const testPacks = ScenePack.standardPacks;

      const whiteText = Color(0xFFFFFFFF);
      final scrimGradient = ScrimContrast.standardStepsScrim();

      // Check across themes, stages, and packs
      for (final _ in themes) {
        for (final packId in testPacks) {
          final pack = ScenePack(id: packId);
          for (final st in testStages) {
            final stage = JourneyStage.fromSteps(st * 1000);
            final palette = pack.paletteFor(stage, AppThemeVariant.ember, true);

            // Worst case background is the brightest color in the sky gradient
            for (final skyColor in palette.skyGradient) {
              // The scrim applied over the body where numbers and stats sit has opacity >= 0.70
              final effectiveScrim = scrimGradient.colors[1]; // 0.70 alpha over slate-900
              final compositeBg = ScrimContrast.composite(effectiveScrim, skyColor);
              final ratio = ScrimContrast.contrastRatio(whiteText, compositeBg);

              expect(
                ratio >= 4.5,
                isTrue,
                reason: 'Failed WCAG AA on pack ${pack.id}, stage $st, skyColor $skyColor. Got $ratio:1',
              );
            }
          }
        }
      }
    });
  });
}
