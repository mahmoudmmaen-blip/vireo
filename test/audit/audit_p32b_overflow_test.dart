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
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/features/ai_nutrition/widgets/ai_scan_limit_sheet.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/home/widgets/daily_score_hero_card.dart';
import 'package:vireo/features/insights/widgets/next_meal_suggestion_card.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/nutrition/widgets/portion_picker_sheet.dart';
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
  RamadanSettingsState get state => const RamadanSettingsState(
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

Widget createP32bAuditWrapper({
  required Widget child,
  ThemeData? theme,
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
      locale: const Locale('ar', 'EG'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: theme ?? AppTheme.dark,
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: widget!,
        );
      },
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('p32b_audit_test_');
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
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('Audit: DailyScoreHeroCard with NextMealSuggestionCard renders without overflow at 360x640 ar_EG scale 1.3',
      (tester) async {
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

    await tester.pumpWidget(
      createP32bAuditWrapper(child: const DailyScoreHeroCard()),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(DailyScoreHeroCard), findsOneWidget);
    expect(find.byType(NextMealSuggestionCard), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in DailyScoreHeroCard at 360x640');
  });

  testWidgets('Audit: PortionPickerSheet renders without overflow at 360x640 ar_EG scale 1.3',
      (tester) async {
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

    await tester.pumpWidget(
      createP32bAuditWrapper(
        child: const PortionPickerSheet(
          nameAr: 'أرز أبيض مطبوخ',
          nameEn: 'Cooked white rice',
          initialGrams: 160,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(PortionPickerSheet), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in PortionPickerSheet at 360x640');
  });

  testWidgets('Audit: AiScanLimitSheet renders without overflow at 360x640 ar_EG scale 1.3',
      (tester) async {
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

    await tester.pumpWidget(
      createP32bAuditWrapper(child: const AiScanLimitSheet()),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(AiScanLimitSheet), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in AiScanLimitSheet at 360x640');
  });
}
