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
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/home/home_screen.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

class MockPlateSizeNotifier extends PlateSizeNotifier {
  @override
  PlateSize? build() => PlateSize.medium;
}

class FakeAppInitNotifier extends AppInitNotifier {
  @override
  Future<AppInitStatus> build() async => AppInitStatus.ready;
}

class FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AppAuthState> build() async => const AppAuthGuest();
}

class FakeRamadanSettingsNotifier extends RamadanSettingsNotifier {
  @override
  RamadanSettingsState get state => RamadanSettingsState(
        isEnabled: false,
        calculationMethod: RamadanCalculationMethod.egyptian,
        cityName: 'Cairo',
        latitude: 30.0444,
        longitude: 31.2357,
        isAutoSuggested: false,
      );
}

class MockStepCounterRunningNotifier extends StateNotifier<bool>
    implements StepCounterRunningNotifier {
  MockStepCounterRunningNotifier() : super(false);

  @override
  Future<void> resync() async {}

  @override
  void setOptimistic(bool value) {
    state = value;
  }
}

Widget wrapHomeLivingAudit({
  required Widget child,
  required ThemeData theme,
  required int stepsCurrent,
  Locale locale = const Locale('ar', 'EG'),
  double textScale = 1.3,
}) {
  return ProviderScope(
    overrides: [
      appInitProvider.overrideWith(() => FakeAppInitNotifier()),
      authProvider.overrideWith(() => FakeAuthNotifier()),
      plateSizeProvider.overrideWith(() => MockPlateSizeNotifier()),
      confirmedMealsProvider.overrideWith((ref) => <MealType>{}),
      effectiveTodayMealsProvider.overrideWith((ref) => Future.value(<MealPlanEntry>[])),
      ramadanSettingsProvider.overrideWith((ref) => FakeRamadanSettingsNotifier()),
      stepCounterBootstrapProvider.overrideWith((ref) => Future.value()),
      isStepCounterRunningProvider.overrideWith((ref) => MockStepCounterRunningNotifier()),
      liveStepsProvider.overrideWith((ref) => Stream.value(LiveStepsSnapshot(
            todaySteps: stepsCurrent,
            source: StepSource.pedometer,
            permissionGranted: true,
            sensorAvailable: true,
            last7Days: StepCounterService.last7DaysFromHistory(todaySteps: stepsCurrent),
          ))),
    ],
    child: MaterialApp(
      theme: theme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: true, // Respect reduced motion
          ),
          child: widget!,
        );
      },
      home: Material(child: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p35_audit_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    await StepCounterService.stopListening();
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
    try {
      await Hive.close().timeout(const Duration(seconds: 10));
    } catch (_) {}
    try {
      await tempDir.delete(recursive: true).timeout(const Duration(seconds: 10));
    } catch (_) {}
  });

  group('P35 Living Backgrounds Home Audit at 360x640 ar_EG textScale 1.3', () {
    final stages = [
      (0, 0, 'Stage 0 (Dawn)'),
      (5, 5000, 'Stage 5 (Morning)'),
      (12, 12500, 'Stage 12 (Golden Triumph ★)'),
    ];

    for (final (_, steps, stageName) in stages) {
      testWidgets('Home screen $stageName in Ember Dark - zero overflow', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final darkTheme = AppTheme.buildThemeForVariant(
          variant: AppThemeVariant.ember,
          brightness: Brightness.dark,
        );

        await tester.pumpWidget(
          wrapHomeLivingAudit(
            child: const HomeScreen(),
            theme: darkTheme,
            stepsCurrent: steps,
          ),
        );

        // Use pump(Duration) as required by prompt
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 650));

        expect(tester.takeException(), isNull, reason: 'Overflow in Ember Dark at $stageName');
      }, timeout: const Timeout(Duration(minutes: 2)));

      testWidgets('Home screen $stageName in Calm Gold Light - zero overflow', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final lightTheme = AppTheme.buildThemeForVariant(
          variant: AppThemeVariant.calmGold,
          brightness: Brightness.light,
        );

        await tester.pumpWidget(
          wrapHomeLivingAudit(
            child: const HomeScreen(),
            theme: lightTheme,
            stepsCurrent: steps,
          ),
        );

        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 650));

        expect(tester.takeException(), isNull, reason: 'Overflow in Calm Gold Light at $stageName');
      }, timeout: const Timeout(Duration(minutes: 2)));
    }
  });
}
