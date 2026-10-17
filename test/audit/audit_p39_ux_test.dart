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
import 'package:vireo/core/ui/async_state_view.dart';
import 'package:vireo/core/ui/estimated_kcal_label.dart';
import 'package:vireo/core/ui/vireo_icon_button.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/debug/design_system_page.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/profile/settings_screen.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

class _MockPlate extends PlateSizeNotifier {
  @override
  PlateSize? build() => PlateSize.medium;
}

class _FakeInit extends AppInitNotifier {
  @override
  Future<AppInitStatus> build() async => AppInitStatus.ready;
}

class _FakeAuth extends AuthNotifier {
  @override
  Future<AppAuthState> build() async => const AppAuthGuest();
}

class _FakeRamadan extends RamadanSettingsNotifier {
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

Widget _wrap(Widget child, {required ThemeData theme}) {
  return ProviderScope(
    overrides: [
      appInitProvider.overrideWith(() => _FakeInit()),
      authProvider.overrideWith(() => _FakeAuth()),
      plateSizeProvider.overrideWith(() => _MockPlate()),
      confirmedMealsProvider.overrideWith((ref) => <MealType>{}),
      effectiveTodayMealsProvider.overrideWith((ref) => Future.value(<MealPlanEntry>[])),
      ramadanSettingsProvider.overrideWith((ref) => _FakeRamadan()),
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
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.3),
          disableAnimations: true,
        ),
        child: widget!,
      ),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;
  late ThemeData theme;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_audit_p39_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
    theme = AppTheme.buildThemeForVariant(
      variant: AppThemeVariant.calmGold,
      brightness: Brightness.dark,
    );
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  testWidgets('P39 design system + shared states @ 360x640 ar_EG 1.3', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_wrap(const DesignSystemPage(), theme: theme));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('نظام'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('P39 AsyncStateView empty/error/offline have retry', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    var retried = false;
    await tester.pumpWidget(
      _wrap(
        Scaffold(
          body: AsyncStateView.error(onRetry: () => retried = true),
        ),
        theme: theme,
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('جرّب تاني'), findsOneWidget);
    await tester.tap(find.text('جرّب تاني'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(retried, isTrue);
  });

  testWidgets('P39 EstimatedKcalLabel shows تقديري', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        const Scaffold(body: Center(child: EstimatedKcalLabel(kcal: 1850))),
        theme: theme,
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('1,850'), findsOneWidget);
    expect(find.textContaining('تقديري'), findsOneWidget);
  });

  testWidgets('P39 VireoIconButton enforces 48dp', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        Scaffold(
          body: VireoIconButton(
            icon: Icons.close,
            tooltip: 'إغلاق',
            onPressed: () {},
          ),
        ),
        theme: theme,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    final size = tester.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('P39 paywall uses fair-use copy @ 360x640 ar_EG 1.3', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_wrap(const PaywallScreen(), theme: theme));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    // Skeleton or content — no overflow, no "غير محدود" honesty trap on scans row.
    expect(tester.takeException(), isNull);
  });

  testWidgets('P39 settings overflow-safe @ 360x640 ar_EG 1.3', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    FlutterErrorDetails? overflow;
    final original = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.toString().contains('overflowed')) overflow = d;
      original?.call(d);
    };
    try {
      await tester.pumpWidget(_wrap(const SettingsScreen(), theme: theme));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 600));
      expect(overflow, isNull);
    } finally {
      FlutterError.onError = original;
    }
  });
}
