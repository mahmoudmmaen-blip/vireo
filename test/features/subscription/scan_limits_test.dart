import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/install_date.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/meal_scan_quota.dart';

int _tsConst(String source, String name) {
  final m = RegExp('export const $name = (\\d+);').firstMatch(source);
  expect(m, isNotNull, reason: '$name not found in ai-usage.ts');
  return int.parse(m!.group(1)!);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Client limits (P40)', () {
    test('constants', () {
      expect(FeatureGates.freeMealScansPerDay, 3);
      expect(FeatureGates.freeMealScansFirstWeek, 5);
      expect(FeatureGates.proMealScansPerDay, 40);
      expect(FeatureGates.freeCoachMessagesPerDay, 0);
      expect(FeatureGates.proCoachMessagesPerDay, 30);
    });

    test('first-week window is install day + 6 days', () {
      final install = DateTime(2026, 10, 10, 23, 30);
      expect(FeatureGates.isWithinFirstWeek(install, DateTime(2026, 10, 10, 23, 59)), isTrue);
      expect(FeatureGates.isWithinFirstWeek(install, DateTime(2026, 10, 16, 0, 5)), isTrue);
      expect(FeatureGates.isWithinFirstWeek(install, DateTime(2026, 10, 17, 0, 5)), isFalse);
      expect(FeatureGates.isWithinFirstWeek(null, DateTime(2026, 10, 10)), isFalse);
    });

    test('day age ignores DST (UTC midnights)', () {
      expect(
        InstallDate.dayAge(DateTime(2026, 3, 26, 12), DateTime(2026, 4, 2, 0, 1)),
        7,
      );
    });
  });

  group('MealScanQuota remaining', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vireo_meal_quota_');
      Hive.init(tempDir.path);
      await Hive.openBox<dynamic>(HiveService.settingsBoxName);
      HiveService.setInitializedForTesting(true);
    });

    tearDown(() async {
      HiveService.setInitializedForTesting(false);
      await Hive.close().timeout(const Duration(seconds: 10));
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('remaining = allowed - used', () async {
      await HiveService.settingsBox
          .put('app_install_date', DateTime.now().toIso8601String());
      expect(MealScanQuota.remainingFreeScansToday(), 5);
      await MealScanQuota.recordScanConsumed();
      await MealScanQuota.recordScanConsumed();
      expect(MealScanQuota.remainingFreeScansToday(), 3);
    });
  });

  group('getDailyFreeMealScansAllowed (Hive install date)', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vireo_scan_limit_');
      Hive.init(tempDir.path);
      await Hive.openBox<dynamic>(HiveService.settingsBoxName);
      HiveService.setInitializedForTesting(true);
    });

    tearDown(() async {
      HiveService.setInitializedForTesting(false);
      await Hive.close().timeout(const Duration(seconds: 10));
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('no install date → 3', () {
      expect(FeatureGates.getDailyFreeMealScansAllowed(), 3);
    });

    test('installed today → 5, plus rewarded scans', () async {
      await HiveService.settingsBox
          .put('app_install_date', DateTime.now().toIso8601String());
      expect(FeatureGates.getDailyFreeMealScansAllowed(), 5);
      await FeatureGates.grantRewardedMealScans();
      expect(FeatureGates.getDailyFreeMealScansAllowed(), 7);
    });

    test('first_open_at alias works', () async {
      await HiveService.settingsBox.put(
        'first_open_at',
        DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      );
      expect(FeatureGates.getDailyFreeMealScansAllowed(), 5);
    });

    test('installed 10 days ago → 3, plus rewarded scans', () async {
      await HiveService.settingsBox.put(
        'app_install_date',
        DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      );
      expect(FeatureGates.getDailyFreeMealScansAllowed(), 3);
      await FeatureGates.grantRewardedMealScans();
      expect(FeatureGates.getDailyFreeMealScansAllowed(), 5);
    });
  });

  group('Server limits (supabase/functions/_shared/ai-usage.ts)', () {
    late String ts;
    setUpAll(() {
      ts = File('supabase/functions/_shared/ai-usage.ts').readAsStringSync();
    });

    test('match the client constants', () {
      expect(_tsConst(ts, 'MEAL_SCAN_LIMIT_FREE'), FeatureGates.freeMealScansPerDay);
      expect(
        _tsConst(ts, 'MEAL_SCAN_LIMIT_FREE_FIRST_WEEK'),
        FeatureGates.freeMealScansFirstWeek,
      );
      expect(_tsConst(ts, 'MEAL_SCAN_LIMIT_PREMIUM'), FeatureGates.proMealScansPerDay);
      expect(_tsConst(ts, 'COACH_CHAT_LIMIT_FREE'), FeatureGates.freeCoachMessagesPerDay);
      expect(_tsConst(ts, 'COACH_CHAT_LIMIT_PREMIUM'), FeatureGates.proCoachMessagesPerDay);
      expect(_tsConst(ts, 'FIRST_WEEK_DAYS'), FeatureGates.firstWeekDays);
    });

    test('coach chat is Pro-only for anonymous users too', () {
      expect(_tsConst(ts, 'COACH_CHAT_LIMIT_ANON'), 0);
    });

    test('mealScanLimit accepts installDayAge / firstWeek', () {
      expect(ts, contains('installDayAge?: number | null;'));
      expect(ts, contains('firstWeek?: boolean;'));
      expect(ts, contains('export async function getAccountCreatedAt'));
    });

    test('analyze-meal wires created_at into the limit', () {
      final src = File('supabase/functions/analyze-meal/index.ts').readAsStringSync();
      expect(src, contains('getAccountCreatedAt(adminClient, user)'));
      expect(src, contains('mealScanLimit({ premium, isAnonymous, installDayAge })'));
    });

    test('parse-meal-text no longer consumes the meal_scan quota', () {
      final src = File('supabase/functions/parse-meal-text/index.ts').readAsStringSync();
      expect(src, isNot(contains('consumeDailyQuota')));
      expect(src, isNot(contains("'meal_scan'")));
    });
  });
}
