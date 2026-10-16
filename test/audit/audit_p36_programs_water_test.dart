import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/diet_programs/screens/diet_programs_screen.dart';
import 'package:vireo/features/home/widgets/today_plan_section.dart';

import 'audit_test_helper.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p36_prog_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  test('programs compute distinct calorie targets via deficitFactor', () {
    const input = DietPlanInput(
      weightKg: 80,
      heightCm: 175,
      age: 30,
      maintenanceKcal: 2600,
    );
    final calories = <int>{};
    for (final p in DietProgramsCatalog.all) {
      final t = DietPlanEngine.targetsFor(p, input);
      calories.add(t.calories);
      expect(t.deficitKcal, greaterThanOrEqualTo(0));
      expect(t.weeklyLossKg, greaterThanOrEqualTo(0));
    }
    // Not all identical
    expect(calories.length, greaterThan(1));
  });

  testWidgets(
    'Diet programs list renders without overflow @ 360x640 ar_EG 1.3',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      FlutterErrorDetails? overflowError;
      final original = FlutterError.onError;
      FlutterError.onError = (d) {
        if (d.toString().contains('overflowed')) overflowError = d;
        original?.call(d);
      };

      await tester.pumpWidget(
        wrapAuditScreen(
          const DietProgramsScreen(),
          locale: const Locale('ar', 'EG'),
          textScale: 1.3,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(overflowError, isNull);
      FlutterError.onError = original;
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  testWidgets(
    'Today Plan water is a single collapsed row @ 360x640 ar_EG 1.3',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        wrapAuditScreen(
          const Scaffold(
            body: SingleChildScrollView(child: TodayPlanSection()),
          ),
          locale: const Locale('ar', 'EG'),
          textScale: 1.3,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Should not flood with many "تذكير ماء X من" rows
      final manyWater = find.textContaining('تذكير ماء');
      expect(manyWater.evaluate().length, lessThan(3));
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('catalog deficitFactors match P36 spec', () {
    double factor(DietProgramId id) =>
        DietProgramsCatalog.byId(id).deficitFactor;
    expect(factor(DietProgramId.balancedDeficit), 1.0);
    expect(factor(DietProgramId.highProtein), 1.05);
    expect(factor(DietProgramId.intermittentFasting), 0.95);
    expect(factor(DietProgramId.lowCarb), 1.1);
    expect(factor(DietProgramId.keto), 1.15);
    expect(factor(DietProgramId.fastingLowCarb), 1.1);
    expect(factor(DietProgramId.egyptianClean), 0.9);
  });
}
