import 'package:flutter/material.dart';

/// Design tokens for Vireo — exactly two brightness themes (P50).
///
/// Dark default base is `#12151a` (not pure black). Orange (`ember`) is the
/// accent only (CTA / FAB / today marker) — never a full-card fill.
@immutable
class VireoColors extends ThemeExtension<VireoColors> {
  const VireoColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceGradientStart,
    required this.surfaceGradientEnd,
    required this.ember,
    required this.gold,
    required this.success,
    required this.danger,
    required this.recovery,
    required this.text,
    required this.textMute,
    required this.line,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceGradientStart;
  final Color surfaceGradientEnd;
  final Color ember;
  final Color gold;
  final Color success;
  final Color danger;
  final Color recovery;
  final Color text;
  final Color textMute;
  final Color line;

  /// Dark theme — precise charcoal base, orange accent-only.
  static const VireoColors dark = VireoColors(
    background: Color(0xFF12151A),
    surface: Color(0xFF1A1E24),
    surfaceRaised: Color(0xFF22272F),
    surfaceGradientStart: Color(0xFF22272F),
    surfaceGradientEnd: Color(0xFF181B21),
    ember: Color(0xFFE8763C),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFE8E8E8),
    textMute: Color(0xFF8B94A0),
    line: Color(0xFF2A323D),
  );

  /// Light theme — clean black & white neutrals, same accent semantics.
  static const VireoColors light = VireoColors(
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF0F2F5),
    ember: Color(0xFFE8763C),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFF12151A),
    textMute: Color(0xFF6B7280),
    line: Color(0xFFE5E7EB),
  );

  // Accent variants share the same dark/light neutrals — only [ember] changes.
  static const VireoColors emberDark = dark;
  static const VireoColors emberLight = light;

  static const VireoColors calmGoldDark = VireoColors(
    background: Color(0xFF12151A),
    surface: Color(0xFF1A1E24),
    surfaceRaised: Color(0xFF22272F),
    surfaceGradientStart: Color(0xFF22272F),
    surfaceGradientEnd: Color(0xFF181B21),
    ember: Color(0xFFD4AF37),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFE8E8E8),
    textMute: Color(0xFF8B94A0),
    line: Color(0xFF2A323D),
  );

  static const VireoColors calmGoldLight = VireoColors(
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF0F2F5),
    ember: Color(0xFFC59E27),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFF12151A),
    textMute: Color(0xFF6B7280),
    line: Color(0xFFE5E7EB),
  );

  static const VireoColors oceanDark = VireoColors(
    background: Color(0xFF12151A),
    surface: Color(0xFF1A1E24),
    surfaceRaised: Color(0xFF22272F),
    surfaceGradientStart: Color(0xFF22272F),
    surfaceGradientEnd: Color(0xFF181B21),
    ember: Color(0xFF00B4D8),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFE8E8E8),
    textMute: Color(0xFF8B94A0),
    line: Color(0xFF2A323D),
  );

  static const VireoColors oceanLight = VireoColors(
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF0F2F5),
    ember: Color(0xFF0077B6),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFF12151A),
    textMute: Color(0xFF6B7280),
    line: Color(0xFFE5E7EB),
  );

  static const VireoColors roseDark = VireoColors(
    background: Color(0xFF12151A),
    surface: Color(0xFF1A1E24),
    surfaceRaised: Color(0xFF22272F),
    surfaceGradientStart: Color(0xFF22272F),
    surfaceGradientEnd: Color(0xFF181B21),
    ember: Color(0xFFD977A6),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFE8E8E8),
    textMute: Color(0xFF8B94A0),
    line: Color(0xFF2A323D),
  );

  static const VireoColors roseLight = VireoColors(
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF0F2F5),
    ember: Color(0xFFB84D81),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFF12151A),
    textMute: Color(0xFF6B7280),
    line: Color(0xFFE5E7EB),
  );

  /// AMOLED stays available as a skin, but still uses accent-only orange.
  static const VireoColors amoled = VireoColors(
    background: Color(0xFF000000),
    surface: Color(0xFF0A0A0A),
    surfaceRaised: Color(0xFF141414),
    surfaceGradientStart: Color(0xFF141414),
    surfaceGradientEnd: Color(0xFF000000),
    ember: Color(0xFFE8763C),
    gold: Color(0xFFFFC107),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFFFFFFF),
    textMute: Color(0xFFB0B0B0),
    line: Color(0xFF2A2A2A),
  );

  static const VireoColors navy = oceanDark;

  VireoColors withAccent(Color accent) => copyWith(ember: accent);

  @override
  VireoColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceGradientStart,
    Color? surfaceGradientEnd,
    Color? ember,
    Color? gold,
    Color? success,
    Color? danger,
    Color? recovery,
    Color? text,
    Color? textMute,
    Color? line,
  }) {
    return VireoColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceGradientStart: surfaceGradientStart ?? this.surfaceGradientStart,
      surfaceGradientEnd: surfaceGradientEnd ?? this.surfaceGradientEnd,
      ember: ember ?? this.ember,
      gold: gold ?? this.gold,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      recovery: recovery ?? this.recovery,
      text: text ?? this.text,
      textMute: textMute ?? this.textMute,
      line: line ?? this.line,
    );
  }

  @override
  VireoColors lerp(ThemeExtension<VireoColors>? other, double t) {
    if (other is! VireoColors) return this;
    return VireoColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceGradientStart:
          Color.lerp(surfaceGradientStart, other.surfaceGradientStart, t)!,
      surfaceGradientEnd:
          Color.lerp(surfaceGradientEnd, other.surfaceGradientEnd, t)!,
      ember: Color.lerp(ember, other.ember, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      recovery: Color.lerp(recovery, other.recovery, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMute: Color.lerp(textMute, other.textMute, t)!,
      line: Color.lerp(line, other.line, t)!,
    );
  }
}

extension VireoColorsContext on BuildContext {
  VireoColors get vireoColors =>
      Theme.of(this).extension<VireoColors>() ?? VireoColors.dark;
}
