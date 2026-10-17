import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/features/debug/design_system_page.dart';

import 'ux_capture_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ensureUxHive();
  });

  testWidgets('single design-system PNG capture', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final variant = const UxCaptureVariant(
      locale: Locale('ar', 'EG'),
      themeKey: 'calm_gold_dark',
      variant: AppThemeVariant.calmGold,
      brightness: Brightness.dark,
      size: Size(360, 640),
      textScale: 1.3,
    );

    final key = GlobalKey();
    await tester.pumpWidget(
      wrapUxCapture(
        child: RepaintBoundary(key: key, child: const DesignSystemPage()),
        variant: variant,
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1.0);
      final bd = await image.toByteData(format: ui.ImageByteFormat.png);
      return bd!.buffer.asUint8List();
    });

    final dir = Directory('build/ux_audit/ar_EG/calm_gold_dark/360x640_ts1.3');
    await dir.create(recursive: true);
    await File('${dir.path}/design_system.png').writeAsBytes(bytes!);
    expect(File('${dir.path}/design_system.png').existsSync(), isTrue);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
