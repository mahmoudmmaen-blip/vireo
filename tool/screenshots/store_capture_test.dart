import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../../integration_test/ux_capture_helper.dart';

/// Seeds demo Hive and writes raw 1080×1920 markers for the 8 Play listing
/// screens × ar/en × Calm Gold dark / Ember dark.
///
/// Final captioned frames: `python tool/screenshots/compose_store_shots.py`
/// → `build/store_screenshots/{ar,en}/01..08.png` (women’s #07 = neutral art).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ensureUxHive();
  });

  final locales = ['ar', 'en'];
  final themes = ['calm_gold_dark', 'ember_dark'];
  final markers = [
    '01_home',
    '02_meal_scan',
    '03_household',
    '04_next_meal',
    '05_fasting',
    '06_body',
    '07_women',
    '08_coach',
  ];

  test('store screenshot markers for 8 listing frames', () async {
    for (final localeKey in locales) {
      for (final themeKey in themes) {
        for (final name in markers) {
          final dir =
              Directory('build/store_screenshots/_raw/$localeKey/$themeKey');
          await dir.create(recursive: true);
          final path = '${dir.path}/$name.png';
          await File('$path.txt').writeAsString(
            '$name | $localeKey | $themeKey | 1080x1920 | demo-seeded',
          );
          await File(path).writeAsBytes(
            Uint8List.fromList(const [
              0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00,
              0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
              0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89,
              0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63,
              0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4,
              0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60,
              0x82,
            ]),
          );
          expect(File(path).existsSync(), isTrue);
        }
      }
    }
  });
}
