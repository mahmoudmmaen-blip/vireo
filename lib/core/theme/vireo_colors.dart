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
    surface: Color(0xFF1A1D21),
    surfaceRaised: Color(0xFF1E232B),
    surfaceGradientStart: Color(0xFF1E232B),
    surfaceGradientEnd: Color(0xFF161A20),
    ember: Color(0xFFFF6B35),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFFE8E8E8),
    textMute: Color(0xFF8B94A0),
    line: Color(0xFF2A323D),
  );

  static const VireoColors light = VireoColors(
    background: Color(0xFFF8F9FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF0F0F0),
    ember: Color(0xFFFF6B35),
    gold: Color(0xFFC9A24B),
    success: Color(0xFF5FAE7A),
    danger: Color(0xFFE85C5C),
    recovery: Color(0xFF4DA3B8),
    text: Color(0xFF1A1A1A),
    textMute: Color(0xFF6B7280),
    line: Color(0xFFE5E7EB),
  );

  // ── 1. Ember (Orange) ──
  static const VireoColors emberDark = dark;
  static const VireoColors emberLight = light;

  // ── 2. Calm Gold (Charcoal background, warm gold/olive accents, pastel pillars) ──
  static const VireoColors calmGoldDark = VireoColors(
    background: Color(0xFF141618), // Deep charcoal
    surface: Color(0xFF1E2124),
    surfaceRaised: Color(0xFF282C30),
    surfaceGradientStart: Color(0xFF282C30),
    surfaceGradientEnd: Color(0xFF1E2124),
    ember: Color(0xFFD4AF37), // Warm Gold accent
    gold: Color(0xFF9E8E62),
    success: Color(0xFF8F9E8B), // Soft sage/olive
    danger: Color(0xFFD86969),
    recovery: Color(0xFF7E9DA8),
    text: Color(0xFFF7F5F0),
    textMute: Color(0xFF9C988F),
    line: Color(0xFF33383E),
  );

  static const VireoColors calmGoldLight = VireoColors(
    background: Color(0xFFF9F7F2), // Warm ivory
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF2EFE9),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF2EFE9),
    ember: Color(0xFFC59E27), // Antique gold
    gold: Color(0xFF8A7740),
    success: Color(0xFF6B8A68),
    danger: Color(0xFFC75252),
    recovery: Color(0xFF5E8592),
    text: Color(0xFF22201D),
    textMute: Color(0xFF757067),
    line: Color(0xFFE2DDD3),
  );

  // ── 3. Ocean (Deep navy + teal) ──
  static const VireoColors oceanDark = VireoColors(
    background: Color(0xFF09131F), // Deep oceanic midnight
    surface: Color(0xFF0F1E2E),
    surfaceRaised: Color(0xFF172B40),
    surfaceGradientStart: Color(0xFF172B40),
    surfaceGradientEnd: Color(0xFF0F1E2E),
    ember: Color(0xFF00B4D8), // Electric teal
    gold: Color(0xFF48CAE4),
    success: Color(0xFF06D6A0),
    danger: Color(0xFFEF476F),
    recovery: Color(0xFF118AB2),
    text: Color(0xFFEBF6FC),
    textMute: Color(0xFF7F9DB7),
    line: Color(0xFF1F3A55),
  );

  static const VireoColors oceanLight = VireoColors(
    background: Color(0xFFF0F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFE5F1F8),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFE5F1F8),
    ember: Color(0xFF0077B6),
    gold: Color(0xFF0096C7),
    success: Color(0xFF00AF87),
    danger: Color(0xFFD6335C),
    recovery: Color(0xFF023E8A),
    text: Color(0xFF102538),
    textMute: Color(0xFF5C7994),
    line: Color(0xFFD0E2EE),
  );

  // ── 4. Rose (Soft plum + rose, refined look) ──
  static const VireoColors roseDark = VireoColors(
    background: Color(0xFF171015), // Deep plum
    surface: Color(0xFF231821),
    surfaceRaised: Color(0xFF31222E),
    surfaceGradientStart: Color(0xFF31222E),
    surfaceGradientEnd: Color(0xFF231821),
    ember: Color(0xFFD977A6), // Soft rose
    gold: Color(0xFFE8A4C8),
    success: Color(0xFF7FB093),
    danger: Color(0xFFE05A74),
    recovery: Color(0xFF9682AA),
    text: Color(0xFFF9F1F6),
    textMute: Color(0xFFA18F9C),
    line: Color(0xFF3F2D3B),
  );

  static const VireoColors roseLight = VireoColors(
    background: Color(0xFFFAF2F6),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF5E4EE),
    surfaceGradientStart: Color(0xFFFFFFFF),
    surfaceGradientEnd: Color(0xFFF5E4EE),
    ember: Color(0xFFB84D81),
    gold: Color(0xFFC9739F),
    success: Color(0xFF5B9270),
    danger: Color(0xFFC73653),
    recovery: Color(0xFF765F8E),
    text: Color(0xFF281822),
    textMute: Color(0xFF826E7C),
    line: Color(0xFFE8D3E0),
  );

  /// AMOLED pure black with high-contrast gold / cyan accents.
  static const VireoColors amoled = VireoColors(
    background: Color(0xFF000000),
    surface: Color(0xFF0A0A0A),
    surfaceRaised: Color(0xFF141414),
    surfaceGradientStart: Color(0xFF141414),
    surfaceGradientEnd: Color(0xFF000000),
    ember: Color(0xFFFFD54F),
    gold: Color(0xFFFFC107),
    success: Color(0xFF00E5FF),
    danger: Color(0xFFFF5252),
    recovery: Color(0xFF00BCD4),
    text: Color(0xFFFFFFFF),
    textMute: Color(0xFFB0B0B0),
    line: Color(0xFF2A2A2A),
  );

  /// Deep navy (#0B192C) with soft ice blue / electric teal accents.
  static const VireoColors navy = oceanDark;

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
