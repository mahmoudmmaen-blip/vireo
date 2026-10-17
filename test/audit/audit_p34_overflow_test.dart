import 'dart:io';
import 'dart:typed_data';
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
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/fasting/domain/fasting_plan.dart';
import 'package:vireo/features/fasting/domain/fasting_safety.dart';
import 'package:vireo/features/fasting/domain/fasting_session.dart';
import 'package:vireo/features/fasting/providers/fasting_provider.dart';
import 'package:vireo/features/fasting/screens/fasting_screen.dart';
import 'package:vireo/features/home/widgets/home_fasting_card.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

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

class MockPlateSizeNotifier extends PlateSizeNotifier {
  @override
  PlateSize? build() => PlateSize.medium;
}

Widget wrapP34AuditScreen(
  Widget child, {
  required ThemeData theme,
  Locale locale = const Locale('ar', 'EG'),
  double textScale = 1.3,
  List<dynamic> overrides = const [],
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
      ...overrides,
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
    tempDir = await Directory.systemTemp.createTemp('vireo_p34_audit_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  Future<void> runOverflowAudit(
    WidgetTester tester, {
    required String name,
    required Widget child,
    List<dynamic> overrides = const [],
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
      final theme = AppTheme.dark;
      await tester.pumpWidget(
        wrapP34AuditScreen(
          child,
          theme: theme,
          locale: const Locale('ar', 'EG'),
          textScale: 1.3,
          overrides: overrides,
        ),
      );

      // Pump explicitly with fixed duration instead of indefinite pumpAndSettle
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));

      expect(overflowError, isNull, reason: 'RenderFlex overflow in $name at 360x640 ar_EG textScale 1.3');
    } finally {
      FlutterError.onError = originalOnError;
    }
  }

  group('P34 Zero-Overflow UI Audits (360x640 ar_EG textScale 1.3)', () {
    testWidgets('FastingScreen renders cleanly with 0 overflows when idle', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'FastingScreen (Idle)',
        child: const FastingScreen(),
      );
    });

    testWidgets('FastingScreen renders cleanly with 0 overflows during active fast', (tester) async {
      final activeSession = FastingSession(
        id: 'audit_active',
        planType: FastingPlanType.p16_8,
        targetHours: 16,
        startTime: DateTime.now().subtract(const Duration(hours: 14, minutes: 20)),
      );

      final fakeState = FastingState(
        activeSession: activeSession,
        selectedPlan: FastingPlanType.p16_8,
        customHours: 16,
        history: [
          FastingSession(
            id: 'past_1',
            planType: FastingPlanType.p16_8,
            targetHours: 16,
            startTime: DateTime.now().subtract(const Duration(days: 1, hours: 16)),
            endTime: DateTime.now().subtract(const Duration(days: 1)),
            isCompleted: true,
          ),
        ],
        safety: const FastingSafetyProfile(),
      );

      await runOverflowAudit(
        tester,
        name: 'FastingScreen (Active Fasting)',
        child: const FastingScreen(),
        overrides: [
          fastingProvider.overrideWith((ref) => FastingNotifier(ref, fakeState)),
        ],
      );
    });

    testWidgets('HomeFastingCard renders cleanly when inactive', (tester) async {
      await runOverflowAudit(
        tester,
        name: 'HomeFastingCard (Inactive)',
        child: const HomeFastingCard(),
      );
    });

    testWidgets('HomeFastingCard renders cleanly when active', (tester) async {
      final activeSession = FastingSession(
        id: 'audit_active_card',
        planType: FastingPlanType.p16_8,
        targetHours: 16,
        startTime: DateTime.now().subtract(const Duration(hours: 14, minutes: 20)),
      );

      final fakeState = FastingState(
        activeSession: activeSession,
        selectedPlan: FastingPlanType.p16_8,
        customHours: 16,
        history: const [],
        safety: const FastingSafetyProfile(),
      );

      await runOverflowAudit(
        tester,
        name: 'HomeFastingCard (Active)',
        child: const HomeFastingCard(),
        overrides: [
          fastingProvider.overrideWith((ref) => FastingNotifier(ref, fakeState)),
        ],
      );
    });

    testWidgets('MealReviewScreen renders cleanly with source chips, oil row, and ± range', (tester) async {
      final dummyLines = [
        const ResolvedMealLine(
          nameAr: 'كشري مصري',
          nameEn: 'Koshari',
          grams: 350,
          cookingMethod: CookingMethod.boiled,
          confidence: 0.95,
          kcal: 560,
          protein: 18,
          carbs: 95,
          fat: 8,
          isEstimated: false,
          source: FoodDatabaseSource.egyptianDb,
          gramsLow: 300,
          gramsHigh: 400,
          kcalLow: 500,
          kcalHigh: 620,
        ),
        const ResolvedMealLine(
          nameAr: 'صدور دجاج مشوية',
          nameEn: 'Grilled chicken breast',
          grams: 200,
          cookingMethod: CookingMethod.grilled,
          confidence: 0.92,
          kcal: 330,
          protein: 62,
          carbs: 0,
          fat: 7,
          isEstimated: false,
          source: FoodDatabaseSource.usda,
          gramsLow: 180,
          gramsHigh: 220,
          kcalLow: 300,
          kcalHigh: 360,
        ),
        const ResolvedMealLine(
          nameAr: 'أرز مصري بالشعرية',
          nameEn: 'Rice with vermicelli',
          grams: 200,
          cookingMethod: CookingMethod.boiled,
          confidence: 0.88,
          kcal: 260,
          protein: 5,
          carbs: 56,
          fat: 3,
          isEstimated: false,
          source: FoodDatabaseSource.personalCalibrated,
          gramsLow: 180,
          gramsHigh: 220,
          kcalLow: 240,
          kcalHigh: 280,
        ),
      ];

      final transparentPng = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
        0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
        0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
      ]);

      final draft = MealScanDraft(
        lines: dummyLines,
        imageBytes: transparentPng,
        imagesBytes: [transparentPng],
      );

      await runOverflowAudit(
        tester,
        name: 'MealReviewScreen with Source Chips & ± Range',
        child: MealReviewScreen(draft: draft),
      );
    });
  });
}
