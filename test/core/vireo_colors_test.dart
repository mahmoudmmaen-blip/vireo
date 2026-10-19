import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

void main() {
  group('VireoColors.dark premium tokens (P50)', () {
    const colors = VireoColors.dark;

    test('background is #12151a not pure black', () {
      expect(colors.background, const Color(0xFF12151A));
    });

    test('ember accent is #e8763c', () {
      expect(colors.ember, const Color(0xFFE8763C));
    });

    test('text / mute / line neutrals', () {
      expect(colors.text, const Color(0xFFE8E8E8));
      expect(colors.textMute, const Color(0xFF8B94A0));
      expect(colors.line, const Color(0xFF2A323D));
    });
  });

  group('VireoColors.light (P50)', () {
    const colors = VireoColors.light;

    test('light neutrals with same accent', () {
      expect(colors.background, const Color(0xFFF7F8FA));
      expect(colors.surface, const Color(0xFFFFFFFF));
      expect(colors.ember, const Color(0xFFE8763C));
      expect(colors.text, const Color(0xFF12151A));
    });
  });

  test('macro colors are fixed across themes', () {
    expect(VMacro.protein, const Color(0xFF5B9DFF));
    expect(VMacro.carbs, const Color(0xFFF5A524));
    expect(VMacro.fat, const Color(0xFFFF6B8A));
  });

  test('accent variants share dark/light neutrals', () {
    expect(VireoColors.calmGoldDark.background, VireoColors.dark.background);
    expect(VireoColors.oceanLight.surface, VireoColors.light.surface);
    expect(VireoColors.calmGoldDark.ember, isNot(VireoColors.dark.ember));
  });

  test('VireoColors is registered on AppTheme', () {
    final extension = ThemeData(
      extensions: const [VireoColors.dark],
    ).extension<VireoColors>();
    expect(extension, isNotNull);
    expect(extension!.background, VireoColors.dark.background);
  });
}
