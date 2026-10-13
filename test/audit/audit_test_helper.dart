import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/core/services/app_init_provider.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

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

Widget wrapAuditScreen(
  Widget child, {
  required Locale locale,
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
    ],
    child: MaterialApp(
      theme: AppTheme.dark,
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
      home: child,
    ),
  );
}

void testScreenOverflow(String name, Widget Function() builder) {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_audit_test_${name.toLowerCase()}_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  final configs = [
    (const Size(360, 640), const Locale('ar', 'EG'), '360x640 ar_EG'),
    (const Size(412, 915), const Locale('en'), '412x915 en'),
  ];

  for (final config in configs) {
    testWidgets('$name overflow test on ${config.$3}', (tester) async {
      tester.view.physicalSize = config.$1;
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
          wrapAuditScreen(
            builder(),
            locale: config.$2,
            textScale: 1.3,
          ),
        );
        // FadeSlideIn has up to 600ms stagger + 500ms duration
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump(const Duration(milliseconds: 600));

        expect(overflowError, isNull, reason: 'RenderFlex overflow detected in $name on ${config.$3}');
      } finally {
        FlutterError.onError = originalOnError;
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 1));
      }
    });
  }
}
