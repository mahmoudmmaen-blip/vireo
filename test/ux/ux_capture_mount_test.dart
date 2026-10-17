import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/ui/async_state_view.dart';

import 'ux_capture_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ThemeData theme;

  setUpAll(() async {
    await ensureUxHive();
    theme = AppTheme.buildThemeForVariant(
      variant: AppThemeVariant.calmGold,
      brightness: Brightness.dark,
    );
  });

  final variant = const UxCaptureVariant(
    locale: Locale('ar', 'EG'),
    themeKey: 'calm_gold_dark',
    variant: AppThemeVariant.calmGold,
    brightness: Brightness.dark,
    size: Size(360, 640),
    textScale: 1.3,
  );

  testWidgets('wrapUxCapture mounts a simple scaffold', (tester) async {
    tester.view.physicalSize = variant.size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      wrapUxCapture(
        child: const Scaffold(body: Center(child: Text('vireo-ux'))),
        variant: variant,
        theme: theme,
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('vireo-ux'), findsOneWidget);
    await capturePng(
      tester,
      outRoot: 'build/ux_audit',
      variant: variant,
      screenName: 'simple_scaffold_mount',
    );
  });

  testWidgets('AsyncStateView.error mounts with Egyptian retry', (tester) async {
    tester.view.physicalSize = variant.size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      wrapUxCapture(
        child: Scaffold(body: AsyncStateView.error(onRetry: () {})),
        variant: variant,
        theme: theme,
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('جرّب تاني'), findsOneWidget);
    await capturePng(
      tester,
      outRoot: 'build/ux_audit',
      variant: variant,
      screenName: 'state_error_mount',
    );
  });

  testWidgets('theme builds for capture matrix variants', (tester) async {
    for (final v in uxCaptureMatrix(full: false)) {
      final t = AppTheme.buildThemeForVariant(
        variant: v.variant,
        brightness: v.brightness,
        languageCode: v.locale.languageCode,
      );
      expect(t.extensions.isNotEmpty, isTrue);
    }
  });
}
