import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/home/domain/today_plan_item.dart';
import 'package:vireo/features/home/providers/today_plan_provider.dart';
import 'package:vireo/features/home/widgets/today_plan_section.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_today_plan_test_');
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

  Widget wrapWithTheme(Widget child, {List<dynamic> overrides = const []}) {
    return ProviderScope(
      overrides: [
        todayPlanProvider.overrideWithValue(
          (l10n, locale) => TodayPlanSnapshot(
            items: const [
              TodayPlanItem(
                id: 'water_morning',
                kind: TodayPlanKind.waterReminder,
                minutesOfDay: 480,
                icon: Icons.water_drop,
                title: 'Drink 500ml water',
                subtitle: 'Morning hydration',
                isPro: false,
              ),
              TodayPlanItem(
                id: 'sunlight_morning',
                kind: TodayPlanKind.vitalitySun,
                minutesOfDay: 500,
                icon: Icons.wb_sunny_rounded,
                title: 'Morning sunlight',
                subtitle: '10-15 mins',
                isPro: false,
              ),
            ],
            completedById: {'water_morning': true},
            completedCount: 1,
            totalCount: 2,
            progress: 0.5,
            nowItemId: 'sunlight_morning',
          ),
        ),
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
        home: const Scaffold(
          body: SingleChildScrollView(child: TodayPlanSection()),
        ),
      ),
    );
  }

  group('TodayPlanSection widget test', () {
    testWidgets('renders plan items and completion percentage', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(wrapWithTheme(const TodayPlanSection()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(TodayPlanSection), findsOneWidget);
      expect(find.text('Drink 500ml water'), findsOneWidget);
      expect(find.text('Morning sunlight'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });
  });
}
