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
import 'package:vireo/features/ai_coach/domain/chat_message.dart';
import 'package:vireo/features/ai_coach/widgets/chat_message_bubble.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/home/widgets/home_body_composition_card.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/measurements/screens/inbody_review_screen.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/onboarding/steps/step_body_screen.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
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

Widget createP32cAuditWrapper({
  required Widget child,
  ThemeData? theme,
  double textScale = 1.3,
  bool isScreen = false,
  List<Override> extraOverrides = const [],
}) {
  return ProviderScope(
    overrides: [
      appInitProvider.overrideWith(() => FakeAppInitNotifier()),
      authProvider.overrideWith(() => FakeAuthNotifier()),
      confirmedMealsProvider.overrideWith((ref) => <MealType>{}),
      effectiveTodayMealsProvider.overrideWith((ref) => Future.value(<MealPlanEntry>[])),
      ramadanSettingsProvider.overrideWith((ref) => FakeRamadanSettingsNotifier()),
      stepCounterBootstrapProvider.overrideWith((ref) => Future.value()),
      isStepCounterRunningProvider.overrideWith((ref) => MockStepCounterRunningNotifier()),
      ...extraOverrides,
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
      home: isScreen ? child : Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

BodyCompositionReport createSampleReport() {
  return BodyCompositionReport(
    id: 'test-report-1',
    testDate: DateTime(2026, 10, 12),
    heightCm: 178,
    age: 29,
    sex: 'male',
    deviceBrand: 'InBody',
    weightKg: 82.5,
    skeletalMuscleMassKg: 36.4,
    bodyFatMassKg: 17.2,
    percentBodyFat: 20.8,
    bmi: 26.0,
    bmrKcal: 1740,
    visceralFatLevel: 7.0,
    waistHipRatio: 0.88,
    inbodyScore: 76.0,
    fatControlKg: -4.5,
    muscleControlKg: 1.5,
    phaseAngle: 6.4,
    segmentalLean: const SegmentalMap(
      rightArm: SegmentalPart(kg: ConfidenceValue(value: 3.4, confidence: 0.95)),
      leftArm: SegmentalPart(kg: ConfidenceValue(value: 3.3, confidence: 0.95)),
      trunk: SegmentalPart(kg: ConfidenceValue(value: 26.0, confidence: 0.95)),
      rightLeg: SegmentalPart(kg: ConfidenceValue(value: 8.8, confidence: 0.95)),
      leftLeg: SegmentalPart(kg: ConfidenceValue(value: 8.7, confidence: 0.95)),
    ),
    fieldConfidence: {
      'weight_kg': 0.98,
      'percent_body_fat': 0.94,
      'visceral_fat_level': 0.55, // Low confidence to trigger amber highlight
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('p32c_audit_test_');
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

  testWidgets('Audit: HomeBodyCompositionCard with data renders without overflow at 360x640 ar_EG scale 1.3',
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

    final sample = createSampleReport();
    await tester.pumpWidget(
      createP32cAuditWrapper(
        extraOverrides: [
          latestBodyCompositionProvider.overrideWith((ref) => sample),
        ],
        child: const HomeBodyCompositionCard(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomeBodyCompositionCard), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in HomeBodyCompositionCard at 360x640');
  });

  testWidgets('Audit: HomeBodyCompositionCard empty state renders without overflow at 360x640 ar_EG scale 1.3',
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
      createP32cAuditWrapper(
        extraOverrides: [
          latestBodyCompositionProvider.overrideWith((ref) => null),
        ],
        child: const HomeBodyCompositionCard(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomeBodyCompositionCard), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in empty HomeBodyCompositionCard at 360x640');
  });

  testWidgets('Audit: InBodyReviewScreen renders without overflow at 360x640 ar_EG scale 1.3',
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

    final report = createSampleReport();
    await tester.pumpWidget(
      createP32cAuditWrapper(
        isScreen: true,
        child: InBodyReviewScreen(report: report),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(InBodyReviewScreen), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in InBodyReviewScreen at 360x640');
  });

  testWidgets('Audit: StepBodyScreen with InBody shortcut renders without overflow at 360x640 ar_EG scale 1.3',
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
      createP32cAuditWrapper(
        isScreen: true,
        child: const StepBodyScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(StepBodyScreen), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in StepBodyScreen at 360x640');
  });

  testWidgets('Audit: ChatMessageBubble with PlanAction renders without overflow at 360x640 ar_EG scale 1.3',
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

    final messageWithAction = ChatMessage(
      id: 'msg-action-1',
      role: ChatMessageRole.assistant,
      timestamp: DateTime(2026, 10, 13),
      content: '''
حللنا تقدمك وعدلنا السعرات والبروتين عشان نسرع خسارة الدهون مع الحفاظ على الكتلة العضلية.
```plan_action
{
  "type": "change_targets",
  "title": "تعديل أهداف السعرات والبروتين",
  "description": "زيادة 150 سعرة لدعم الاستشفاء",
  "data": {
    "target_kcal": 2150,
    "target_protein_g": 160
  }
}
```
اضغط على الزرار لتطبيق الخطة الجديدة.
''',
    );

    await tester.pumpWidget(
      createP32cAuditWrapper(
        child: ChatMessageBubble(message: messageWithAction),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ChatMessageBubble), findsOneWidget);
    expect(overflowError, isNull, reason: 'RenderFlex overflow in ChatMessageBubble with PlanAction at 360x640');
  });
}
