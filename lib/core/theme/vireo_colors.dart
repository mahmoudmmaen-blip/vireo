import 'package:flutter/material.dart';

/// Design tokens for the Vireo dark theme.
@immutable
class VireoColors extends ThemeExtension<VireoColors> {
  const VireoColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.ember,
    required this.gold,
    required this.success,
    required this.danger,
    required this.text,
    required this.textMute,
    required this.line,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color ember;
  final Color gold;
  final Color success;
  final Color danger;
  final Color text;
  final Color textMute;
  final Color line;

  static const VireoColors dark = VireoColors(
    background: Color(0xFF0A0C10),
    surface: Color(0xFF12161D),
    surfaceRaised: Color(0xFF1C222C),
    ember: Color(0xFFE8763C),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    text: Color(0xFFF2F4F7),
    textMute: Color(0xFF9BA3AF),
    line: Color(0xFF3A4454),
  );

  @override
  VireoColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? ember,
    Color? gold,
    Color? success,
    Color? danger,
    Color? text,
    Color? textMute,
    Color? line,
  }) {
    return VireoColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      ember: ember ?? this.ember,
      gold: gold ?? this.gold,
      success: success ?? this.success,
      danger: danger ?? this.danger,
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
      ember: Color.lerp(ember, other.ember, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
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
