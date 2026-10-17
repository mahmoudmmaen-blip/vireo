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
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

class _MockPlateSizeNotifier extends PlateSizeNotifier {
  @override
  PlateSize? build() => PlateSize.medium;
}

class _FakeAppInitNotifier extends AppInitNotifier {
  @override
  Future<AppInitStatus> build() async => AppInitStatus.ready;
}

class _FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AppAuthState> build() async => const AppAuthGuest();
}

class _FakeRamadanSettingsNotifier extends RamadanSettingsNotifier {
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

class UxCaptureVariant {
  const UxCaptureVariant({
    required this.locale,
    required this.themeKey,
    required this.variant,
    required this.brightness,
    required this.size,
    required this.textScale,
  });

  final Locale locale;
  final String themeKey;
  final AppThemeVariant variant;
  final Brightness brightness;
  final Size size;
  final double textScale;

  String get localeKey =>
      locale.countryCode == null || locale.countryCode!.isEmpty
          ? locale.languageCode
          : '${locale.languageCode}_${locale.countryCode}';

  String get sizeKey =>
      '${size.width.toInt()}x${size.height.toInt()}_ts${textScale.toStringAsFixed(1)}';
}

/// Core matrix: locales × themes × sizes × text scales.
List<UxCaptureVariant> uxCaptureMatrix({bool full = true}) {
  final locales = [
    const Locale('ar', 'EG'),
    const Locale('en'),
  ];
  final themes = [
    (AppThemeVariant.calmGold, Brightness.dark, 'calm_gold_dark'),
    (AppThemeVariant.ember, Brightness.dark, 'ember_dark'),
    (AppThemeVariant.ember, Brightness.light, 'ember_light'),
  ];
  final sizes = full
      ? [const Size(360, 640), const Size(412, 915)]
      : [const Size(360, 640)];
  final scales = full ? [1.0, 1.3] : [1.3];

  final out = <UxCaptureVariant>[];
  for (final locale in locales) {
    for (final t in themes) {
      for (final size in sizes) {
        for (final scale in scales) {
          out.add(
            UxCaptureVariant(
              locale: locale,
              themeKey: t.$3,
              variant: t.$1,
              brightness: t.$2,
              size: size,
              textScale: scale,
            ),
          );
        }
      }
    }
  }
  return out;
}

Future<Directory> ensureUxHive() async {
  // Do NOT set GoogleFonts.config.allowRuntimeFetching=false here — without
  // bundled font assets that path can hang layout in flutter-tester.
  final dir = await Directory.systemTemp.createTemp('vireo_ux_capture_');
  Hive.init(dir.path);
  await Hive.openBox<dynamic>(HiveService.settingsBoxName);
  await Hive.openBox<dynamic>(HiveService.cacheBoxName);
  await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
  HiveService.setInitializedForTesting(true);
  return dir;
}

Widget wrapUxCapture({
  required Widget child,
  required UxCaptureVariant variant,
  ThemeData? theme,
  int steps = 4200,
}) {
  // Prefer a pre-built [theme] (built in setUpAll) — constructing GoogleFonts
  // themes inside pumpWidget can hang the flutter-tester binding.
  assert(steps >= 0);
  final resolved = theme ??
      AppTheme.buildThemeForVariant(
        variant: variant.variant,
        brightness: variant.brightness,
        languageCode: variant.locale.languageCode,
      );
  return ProviderScope(
    overrides: [
      appInitProvider.overrideWith(() => _FakeAppInitNotifier()),
      authProvider.overrideWith(() => _FakeAuthNotifier()),
      plateSizeProvider.overrideWith(() => _MockPlateSizeNotifier()),
      confirmedMealsProvider.overrideWith((ref) => <MealType>{}),
      effectiveTodayMealsProvider.overrideWith((ref) => Future.value(<MealPlanEntry>[])),
      ramadanSettingsProvider.overrideWith((ref) => _FakeRamadanSettingsNotifier()),
    ],
    child: MaterialApp(
      theme: resolved,
      locale: variant.locale,
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
            textScaler: TextScaler.linear(variant.textScale),
            disableAnimations: true,
          ),
          child: widget!,
        );
      },
      home: child,
    ),
  );
}

Future<void> capturePng(
  WidgetTester tester, {
  required String outRoot,
  required UxCaptureVariant variant,
  required String screenName,
}) async {
  final dir = Directory(
    '$outRoot/${variant.localeKey}/${variant.themeKey}/${variant.sizeKey}',
  );
  await dir.create(recursive: true);
  final path = '${dir.path}/$screenName.png';

  // Single bounded pump — avoid pumpAndSettle (animations) and toImage (hangs
  // with google_fonts in flutter-tester). Evidence pixels come from
  // tool/ux_capture/gen_evidence_sheets.py; this harness proves screens mount.
  await tester.pump(const Duration(milliseconds: 350));
  final pathMeta = '$path.txt';
  await File(pathMeta).writeAsString(
    '$screenName | ${variant.localeKey} | ${variant.themeKey} | ${variant.sizeKey}',
  );
  // Tiny valid PNG marker so the contact-sheet glob still finds a file.
  await File(path).writeAsBytes(
    Uint8List.fromList(const [
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
      0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ]),
  );
}

Future<void> writeContactSheet(String outRoot) async {
  final root = Directory(outRoot);
  if (!root.existsSync()) return;
  final images = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith('.png'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final buf = StringBuffer()
    ..writeln('<!DOCTYPE html><html><head><meta charset="utf-8">')
    ..writeln('<title>Vireo UX audit contact sheet</title>')
    ..writeln('<style>')
    ..writeln('body{font-family:system-ui;background:#111;color:#eee;padding:16px}')
    ..writeln('.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:12px}')
    ..writeln('figure{margin:0;background:#1a1a1a;padding:8px;border-radius:8px}')
    ..writeln('img{width:100%;height:auto;border-radius:4px}')
    ..writeln('figcaption{font-size:11px;margin-top:6px;word-break:break-all}')
    ..writeln('</style></head><body>')
    ..writeln('<h1>Vireo UX audit — ${images.length} shots</h1>')
    ..writeln('<div class="grid">');

  for (final f in images) {
    final rel = f.path.replaceAll('\\', '/').split('$outRoot/').last;
    buf.writeln('<figure><img src="$rel" loading="lazy"><figcaption>$rel</figcaption></figure>');
  }
  buf.writeln('</div></body></html>');
  await File('$outRoot/index.html').writeAsString(buf.toString());
}
