import 'package:flutter/material.dart';

/// Design tokens for the Vireo dark theme.
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

  static const VireoColors dark = VireoColors(
    background: Color(0xFF0D0F12),
    surface: Color(0xFF161A20),
    surfaceRaised: Color(0xFF1E232B),
    surfaceGradientStart: Color(0xFF1E232B),
    surfaceGradientEnd: Color(0xFF161A20),
    ember: Color(0xFFE8763C),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFF0F2F5),
    textMute: Color(0xFF8B94A0),
    line: Color(0xFF2A323D),
  );

  static const VireoColors light = VireoColors(
    background: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF0F0F0),
    ember: Color(0xFFE8763C),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFF1A1A1A),
    textMute: Color(0xFF6B7280),
    line: Color(0xFFE5E7EB),
  );

  /// Returns a copy with a custom primary accent (ember).
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
