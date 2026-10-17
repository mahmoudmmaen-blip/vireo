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
import 'package:vireo/features/men_health/widgets/men_vitality_hero_card.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/onboarding/steps/step_body_screen.dart';
import 'package:vireo/features/onboarding/steps/step_goal_screen.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/women_health/screens/women_health_screen.dart';
import 'package:vireo/features/women_health/widgets/women_health_hero_card.dart';

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
  RamadanSettingsState get state => const RamadanSettingsState(
        isEnabled: false,
        calculationMethod: RamadanCalculationMethod.egyptian,
        cityPresetId: 'cairo',
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

Widget wrapP33AuditScreen(
  Widget child, {
  required ThemeData theme,
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
    tempDir = await Directory.systemTemp.createTemp('vireo_p33_audit_test_');
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
  });

  Future<void> runOverflowAudit(
    WidgetTester tester, {
    required String name,
    required Widget child,
    ThemeData? theme,
  }) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    FlutterErrorDetails? overflowError;
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed by') ||
          details.toString().contains('RenderFlex overflowed')) {
        overflowError = details;
      }
      originalOnError?.call(details);
    };

    try {
      await tester.pumpWidget(
        wrapP33AuditScreen(
          child,
          theme: theme ?? AppTheme.dark,
        ),
      );

      // Safe multi-step pump without pumpAndSettle on animated widgets
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(overflowError, isNull, reason: 'RenderFlex overflow in $name at 360x640 ar_EG textScale 1.3');
    } finally {
      FlutterError.onError = originalOnError;
      await StepCounterService.stopListening();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  group('P33 Screen & Widget Overflow Audits (360x640 ar_EG textScale 1.3)', () {
    testWidgets('WomenHealthScreen no overflow', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'WomenHealthScreen',
        child: const WomenHealthScreen(),
      );
    });

    testWidgets('WomenHealthHeroCard no overflow', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'WomenHealthHeroCard',
        child: const SingleChildScrollView(child: WomenHealthHeroCard()),
      );
    });

    testWidgets('MenVitalityHeroCard no overflow', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'MenVitalityHeroCard',
        child: const SingleChildScrollView(child: MenVitalityHeroCard()),
      );
    });

    testWidgets('PaywallScreen no overflow', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'PaywallScreen',
        child: const PaywallScreen(),
      );
    });

    testWidgets('StepBodyScreen onboarding pickers no overflow', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'StepBodyScreen',
        child: const StepBodyScreen(),
      );
    });

    testWidgets('StepGoalScreen goal chips no overflow', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'StepGoalScreen',
        child: const StepGoalScreen(),
      );
    });

    testWidgets('HomeScreen in Calm Gold dark no overflow', (tester) async {
      final calmGoldDark = AppTheme.buildThemeForVariant(
        variant: AppThemeVariant.calmGold,
        brightness: Brightness.dark,
      );
      await runOverflowAudit(
        tester,
        name: 'HomeScreen Calm Gold dark',
        theme: calmGoldDark,
        child: const HomeScreen(),
      );
    });

    testWidgets('HomeScreen in Calm Gold light no overflow', (tester) async {
      final calmGoldLight = AppTheme.buildThemeForVariant(
        variant: AppThemeVariant.calmGold,
        brightness: Brightness.light,
      );
      await runOverflowAudit(
        tester,
        name: 'HomeScreen Calm Gold light',
        theme: calmGoldLight,
        child: const HomeScreen(),
      );
    });
  });
}
