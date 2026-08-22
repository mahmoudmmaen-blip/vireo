import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

void main() {
  group('VireoColors.dark premium tokens', () {
    const colors = VireoColors.dark;

    test('background', () {
      expect(colors.background, const Color(0xFF0D0F12));
    });

    test('surfaceRaised', () {
      expect(colors.surfaceRaised, const Color(0xFF1E232B));
    });

    test('ember primary', () {
      expect(colors.ember, const Color(0xFFE8763C));
    });

    test('text', () {
      expect(colors.text, const Color(0xFFF0F2F5));
    });

    test('textMute', () {
      expect(colors.textMute, const Color(0xFF8B94A0));
    });

    test('line', () {
      expect(colors.line, const Color(0xFF2A323D));
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
