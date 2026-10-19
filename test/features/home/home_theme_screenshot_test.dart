import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/app_init_provider.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';
import 'package:vireo/features/home/widgets/meal_capture_hero_card.dart';
import 'package:vireo/features/home/widgets/premium_steps_hero_card.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

import '../../audit/audit_test_helper.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p50_home_theme_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  Future<void> pumpHome(WidgetTester tester, Brightness brightness) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    final theme = AppTheme.buildThemeForVariant(
      variant: AppThemeVariant.ember,
      brightness: brightness,
      languageCode: 'ar',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appInitProvider.overrideWith(() => FakeAppInitNotifier()),
          authProvider.overrideWith(() => FakeAuthNotifier()),
          plateSizeProvider.overrideWith(() => MockPlateSizeNotifier()),
          confirmedMealsProvider.overrideWith((ref) => <MealType>{}),
          effectiveTodayMealsProvider
              .overrideWith((ref) => Future.value(<MealPlanEntry>[])),
          ramadanSettingsProvider
              .overrideWith((ref) => FakeRamadanSettingsNotifier()),
        ],
        child: MaterialApp(
          theme: theme,
          locale: const Locale('ar', 'EG'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: HomeDashboardBody()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
  }

  Future<void> disposeHome(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    // Flush HC/steps poll timers left by Home providers.
    await tester.pump(const Duration(hours: 1));
  }

  testWidgets('P50 dark+light theme tokens Arabic RTL', (tester) async {
    for (final brightness in [Brightness.dark, Brightness.light]) {
      final theme = AppTheme.buildThemeForVariant(
        variant: AppThemeVariant.ember,
        brightness: brightness,
        languageCode: 'ar',
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          locale: const Locale('ar', 'EG'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) {
              final colors = context.vireoColors;
              final expected = brightness == Brightness.dark
                  ? VireoColors.dark
                  : VireoColors.light;
              expect(colors.background, expected.background);
              expect(colors.ember, expected.ember);
              expect(colors.text, expected.text);
              expect(colors.success, expected.success);
              expect(Directionality.of(context), TextDirection.rtl);
              return Scaffold(
                backgroundColor: colors.background,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: colors.ember,
                  child: const Icon(Icons.add),
                ),
                body: Center(
                  child: Text(
                    brightness == Brightness.dark ? 'داكن' : 'فاتح',
                    style: TextStyle(color: colors.text),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('P50 Home mounts in dark Arabic RTL', (tester) async {
    await pumpHome(tester, Brightness.dark);
    expect(find.byType(HomeDashboardBody), findsOneWidget);
    expect(find.byType(PremiumStepsHeroCard), findsOneWidget);
    expect(find.byType(MealCaptureHeroCard), findsOneWidget);
    final colors =
        tester.element(find.byType(HomeDashboardBody)).vireoColors;
    expect(colors.background, VireoColors.dark.background);
    await disposeHome(tester);
  });

  testWidgets('P50 Home mounts in light Arabic RTL', (tester) async {
    await pumpHome(tester, Brightness.light);
    expect(find.byType(HomeDashboardBody), findsOneWidget);
    expect(find.byType(MealCaptureHeroCard), findsOneWidget);
    final colors =
        tester.element(find.byType(HomeDashboardBody)).vireoColors;
    expect(colors.background, VireoColors.light.background);
    await disposeHome(tester);
  });

  testWidgets(
    'P50 Home goldens dark+light RTL',
    (tester) async {
      await pumpHome(tester, Brightness.dark);
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/p50_home_dark_ar.png'),
      );
      await disposeHome(tester);

      await pumpHome(tester, Brightness.light);
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/p50_home_light_ar.png'),
      );
      await disposeHome(tester);
    },
    skip: Platform.environment['UPDATE_GOLDENS'] != '1',
  );
}
