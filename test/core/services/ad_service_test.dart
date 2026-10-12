import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/widgets/vireo_ad_widgets.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_ad_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Interstitial Frequency Capping', () {
    test('Pro users are never shown interstitials', () {
      final canShow = AdService.instance.canShowInterstitial(isPro: true);
      expect(canShow, isFalse);
    });

    test('Fresh install within 3 days is not shown interstitials', () {
      final now = DateTime(2026, 10, 12, 12, 0);
      HiveService.settingsBox.put('app_install_date', DateTime(2026, 10, 11, 12, 0).toIso8601String());

      final canShow = AdService.instance.canShowInterstitial(
        isPro: false,
        nowOverride: now,
      );
      expect(canShow, isFalse);
    });

    test('Shows interstitial after 3 days post install', () {
      final now = DateTime(2026, 10, 15, 12, 0);
      HiveService.settingsBox.put('app_install_date', DateTime(2026, 10, 10, 12, 0).toIso8601String());

      final canShow = AdService.instance.canShowInterstitial(
        isPro: false,
        nowOverride: now,
      );
      expect(canShow, isTrue);
    });

    test('Enforces 10 minute cooldown between interstitials', () {
      final now = DateTime(2026, 10, 15, 12, 5);
      HiveService.settingsBox.put('app_install_date', DateTime(2026, 10, 10, 12, 0).toIso8601String());
      HiveService.settingsBox.put('ad_last_interstitial_time', DateTime(2026, 10, 15, 12, 0).toIso8601String());

      final canShow5Min = AdService.instance.canShowInterstitial(
        isPro: false,
        nowOverride: now,
      );
      expect(canShow5Min, isFalse);

      final canShow15Min = AdService.instance.canShowInterstitial(
        isPro: false,
        nowOverride: DateTime(2026, 10, 15, 12, 11),
      );
      expect(canShow15Min, isTrue);
    });

    test('Enforces maximum 3 interstitials per day', () {
      final now = DateTime(2026, 10, 15, 16, 0);
      HiveService.settingsBox.put('app_install_date', DateTime(2026, 10, 10, 12, 0).toIso8601String());
      HiveService.settingsBox.put('ad_daily_interstitial_count_2026-10-15', 3);

      final canShow = AdService.instance.canShowInterstitial(
        isPro: false,
        nowOverride: now,
      );
      expect(canShow, isFalse);
    });
  });

  group('Rewarded Ad Unlocks & Expiry', () {
    test('Rewarded extra meal scans are granted and incremented', () async {
      expect(FeatureGates.getDailyFreeMealScansAllowed(), equals(3));
      await FeatureGates.grantRewardedMealScans();
      expect(FeatureGates.getDailyFreeMealScansAllowed(), equals(5));
    });

    test('Diet program unlock expires after 24 hours', () async {
      expect(FeatureGates.isDietProgramUnlocked(DietProgramId.keto, isPro: false), isFalse);

      await FeatureGates.grantRewardedDietProgram(DietProgramId.keto);
      expect(FeatureGates.isDietProgramUnlocked(DietProgramId.keto, isPro: false), isTrue);

      // Expire the key manually in Hive
      final past = DateTime.now().subtract(const Duration(hours: 1)).toIso8601String();
      await HiveService.settingsBox.put('rewarded_unlock_diet_keto', past);
      expect(FeatureGates.isDietProgramUnlocked(DietProgramId.keto, isPro: false), isFalse);
    });

    test('AI Coach 24 hour unlock and expiry', () async {
      expect(FeatureGates.isAiCoachRewardedUnlocked(), isFalse);

      await FeatureGates.grantRewardedAiCoach();
      expect(FeatureGates.isAiCoachRewardedUnlocked(), isTrue);

      final past = DateTime.now().subtract(const Duration(hours: 1)).toIso8601String();
      await HiveService.settingsBox.put('rewarded_unlock_ai_coach', past);
      expect(FeatureGates.isAiCoachRewardedUnlocked(), isFalse);
    });

    test('Vitality Pro item unlocked for today only', () async {
      expect(FeatureGates.isVitalityRewardedUnlocked(), isFalse);

      await FeatureGates.grantRewardedVitalityItem();
      expect(FeatureGates.isVitalityRewardedUnlocked(), isTrue);
      expect(FeatureGates.canAccessVitalityPro(isPro: false), isTrue);
    });

    test('Max 5 rewarded ads per day cap', () async {
      final now = DateTime(2026, 10, 12);
      expect(AdService.canWatchRewardedToday(nowOverride: now), isTrue);

      for (int i = 0; i < 5; i++) {
        await AdService.incrementRewardedCountToday(nowOverride: now);
      }
      expect(AdService.canWatchRewardedToday(nowOverride: now), isFalse);
    });
  });

  group('Ad Free Guarantee for Pro Users', () {
    testWidgets('VireoBannerAdWidget renders empty SizedBox for Pro users', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isProUserProvider.overrideWithValue(true),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: VireoBannerAdWidget(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('VireoNativeAdCard renders empty SizedBox for Pro users', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isProUserProvider.overrideWithValue(true),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: VireoNativeAdCard(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('إزالة الإعلانات ✨'), findsNothing);
      expect(find.text('إعلان'), findsNothing);
    });
  });
}
