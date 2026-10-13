import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/app_init_provider.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/widgets/daily_score_hero_card.dart';
import '../../audit/audit_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_ring_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  group('Home Score Ring Scaling & Rendering', () {
    for (final score in [3, 75, 100]) {
      testWidgets('renders score $score cleanly at textScale 1.3 without clipping', (tester) async {
        final mockBreakdown = DailyScoreBreakdown(
          totalScore: score,
          stepsScore: score * 0.25,
          proteinScore: score * 0.20,
          caloriesScore: score * 0.15,
          waterScore: score * 0.15,
          workoutScore: score * 0.15,
          sleepScore: score * 0.10,
          tips: const [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appInitProvider.overrideWith(() => FakeAppInitNotifier()),
              authProvider.overrideWith(() => FakeAuthNotifier()),
              dailyScoreProvider.overrideWithValue(mockBreakdown),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('ar', 'EG'),
              home: MediaQuery(
                data: const MediaQueryData(
                  size: Size(360, 640),
                  textScaler: TextScaler.linear(1.3),
                ),
                child: const Scaffold(
                  body: SingleChildScrollView(
                    child: DailyScoreHeroCard(),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // Ensure score number and /100 are rendered
        expect(find.text('$score'), findsWidgets);
        expect(find.text('/100'), findsOneWidget);

        // Ensure no Flutter errors or overflow exceptions were thrown
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
      });
    }
  });
}
