import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Design tokens from vireo-ui-ux-specs.md §2.1
void main() {
  group('VireoColors.dark matches spec §2.1', () {
    const colors = VireoColors.dark;

    test('background', () {
      expect(colors.background, const Color(0xFF0A0C10));
    });

    test('surface', () {
      expect(colors.surface, const Color(0xFF12161D));
    });

    test('surfaceRaised', () {
      expect(colors.surfaceRaised, const Color(0xFF1C222C));
    });

    test('ember primary', () {
      expect(colors.ember, const Color(0xFFE8763C));
    });

    test('gold secondary', () {
      expect(colors.gold, const Color(0xFFC9A24B));
    });

    test('success', () {
      expect(colors.success, const Color(0xFF5FAE7A));
    });

    test('danger', () {
      expect(colors.danger, const Color(0xFFE85C5C));
    });

    test('text', () {
      expect(colors.text, const Color(0xFFF2F4F7));
    });

    test('textMute', () {
      expect(colors.textMute, const Color(0xFF9BA3AF));
    });
  });

  test('VireoColors is registered on AppTheme', () {
    final extension = ThemeData(
      extensions: const [VireoColors.dark],
    ).extension<VireoColors>();
    expect(extension, isNotNull);
    expect(extension!.background, VireoColors.dark.background);
  });
}
