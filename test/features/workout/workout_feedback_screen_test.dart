import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/features/vitality/data/vitality_daily_log.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/workout/domain/workout_rpe.dart';
import 'package:vireo/features/workout/screens/workout_feedback_screen.dart';

/// Avoids the sync engine / Supabase when the screen marks the workout done.
class _FakeVitalityNotifier extends VitalityDailyLogNotifier {
  @override
  VitalityDailyLog build() => VitalityDailyLog.empty('2026-10-16');

  @override
  Future<void> markWorkoutCompleted() async {}
}

Widget _wrap({Locale locale = const Locale('ar', 'EG')}) {
  return ProviderScope(
    overrides: [
      vitalityDailyLogProvider.overrideWith(_FakeVitalityNotifier.new),
    ],
    child: MaterialApp(
      theme: AppTheme.buildThemeForVariant(
        variant: AppThemeVariant.ember,
        brightness: Brightness.dark,
      ),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.3)),
        child: child!,
      ),
      home: const WorkoutFeedbackScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_rpe_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
    // Hive.close() can hang under the fake-async binding; the temp dir is
    // disposable, so only reset the flag.
  });

  group('WorkoutFeedbackScreen @ 360x640 ar_EG', () {
    Future<void> pumpScreen(WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      await tester.pumpWidget(_wrap());
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('renders non-empty content with the title and close button', (tester) async {
      await pumpScreen(tester);

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('التمرين كان إزاي؟'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      // Egyptian RPE feelings are visible.
      expect(find.text('تعب'), findsOneWidget);
      expect(find.text('ألم في مفصل'), findsOneWidget);
      expect(find.text('طاقة عالية'), findsOneWidget);
      // 1..10 scale.
      for (var i = 1; i <= 10; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('selecting RPE shows its label and enables save', (tester) async {
      await pumpScreen(tester);

      FilledButton saveButton() =>
          tester.widget<FilledButton>(find.byType(FilledButton));
      expect(saveButton().onPressed, isNull);

      await tester.ensureVisible(find.text('1'));
      await tester.tap(find.text('1'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('سهل جداً'), findsOneWidget);
      expect(saveButton().onPressed, isNotNull);

      await tester.tap(find.text('10'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('صعب جداً'), findsOneWidget);
    });

    testWidgets('save persists RPE and shows the smart comment', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('9'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.ensureVisible(find.text('ألم في مفصل'));
      await tester.tap(find.text('ألم في مفصل'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.ensureVisible(find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      // Let the async save finish without waiting on animations.
      // Hive does real file I/O, so alternate real time and frame pumps.
      for (var i = 0; i < 20 && find.text('تمام').evaluate().isEmpty; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(HiveService.settingsBox.get(lastWorkoutRpeKey), 9);
      expect(find.textContaining('خفّف'), findsOneWidget);
      expect(find.text('تمام'), findsOneWidget);
    });
  });

  group('WorkoutRpe', () {
    test('maps 1–3 easy, 4–7 justRight, 8–10 hard', () {
      for (var i = 1; i <= 3; i++) {
        expect(WorkoutRpe.toDifficulty(i), WorkoutDifficultyFeedback.easy);
      }
      for (var i = 4; i <= 7; i++) {
        expect(WorkoutRpe.toDifficulty(i), WorkoutDifficultyFeedback.justRight);
      }
      for (var i = 8; i <= 10; i++) {
        expect(WorkoutRpe.toDifficulty(i), WorkoutDifficultyFeedback.hard);
      }
    });

    test('insight priority: joint > hard > better > easy > partial > steady', () {
      WorkoutRpeInsight pick(int rpe,
              {Set<WorkoutFeeling> f = const {}, double c = 1, int? prev}) =>
          WorkoutRpe.insightFor(rpe: rpe, feelings: f, completion: c, previousRpe: prev);

      expect(pick(9, f: {WorkoutFeeling.jointPain}), WorkoutRpeInsight.joint);
      expect(pick(9), WorkoutRpeInsight.hard);
      expect(pick(5, prev: 7), WorkoutRpeInsight.better);
      expect(pick(2), WorkoutRpeInsight.easy);
      expect(pick(5, c: 0.4), WorkoutRpeInsight.partial);
      expect(pick(6, prev: 5), WorkoutRpeInsight.steady);
    });
  });
}
