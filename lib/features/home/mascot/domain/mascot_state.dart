import 'package:flutter/foundation.dart';

/// Fill / colour / expression state for the calorie mascot wave.
enum MascotFillColorState {
  /// Under 85% of target — theme accent (calm).
  calm,

  /// 85–105% — green "تمام".
  onTrack,

  /// Over 105% — soft amber "زيادة شوية" (never alarming red).
  over,
}

enum MascotExpression {
  hungry,
  happy,
  satisfied,
  full,
  sleepy,
}

/// Emoji shown on the home-screen widget for the current mascot mood.
String mascotExpressionEmoji(MascotExpression expression) {
  return switch (expression) {
    MascotExpression.hungry => '😋',
    MascotExpression.happy => '😊',
    MascotExpression.satisfied => '😌',
    MascotExpression.full => '🤰',
    MascotExpression.sleepy => '😴',
  };
}

@immutable
class MascotFillMath {
  const MascotFillMath({
    required this.consumedKcal,
    required this.targetKcal,
  });

  final int consumedKcal;
  final int targetKcal;

  /// Raw ratio (may exceed 1.0).
  double get rawRatio {
    if (targetKcal <= 0) return 0;
    return consumedKcal / targetKcal;
  }

  /// Visual fill clamped to 0..1. Over-target still fills the body fully;
  /// callers show an "over" badge when [rawRatio] > 1.05.
  double get visualFill => rawRatio.clamp(0.0, 1.0);

  bool get showOverBadge => rawRatio > 1.05;

  int get remainingKcal {
    if (targetKcal <= 0) return 0;
    return (targetKcal - consumedKcal).clamp(0, targetKcal);
  }

  MascotFillColorState get colorState {
    final r = rawRatio;
    if (r > 1.05) return MascotFillColorState.over;
    if (r >= 0.85) return MascotFillColorState.onTrack;
    return MascotFillColorState.calm;
  }

  /// Expression from fill + clock. Night (after 23:00) wins unless overfull.
  MascotExpression expressionAt(DateTime now) {
    final hour = now.hour;
    if (hour >= 23 || hour < 5) {
      if (rawRatio > 1.05) return MascotExpression.full;
      return MascotExpression.sleepy;
    }
    if (rawRatio > 1.05) return MascotExpression.full;
    if (rawRatio >= 0.90) return MascotExpression.satisfied;
    if (rawRatio >= 0.35) return MascotExpression.happy;
    // Morning / empty → hungry
    if (hour < 11 && rawRatio < 0.25) return MascotExpression.hungry;
    if (rawRatio < 0.15) return MascotExpression.hungry;
    return MascotExpression.happy;
  }
}

/// Builds the Egyptian caption under the mascot (ICU gender via caller).
String mascotCaptionAr({
  required int remainingKcal,
  required bool isOver,
  required bool isFemale,
}) {
  if (isOver) {
    return isFemale
        ? 'زدتي شوية عن الهدف — براحتك، عدّلي بكرة'
        : 'زودت شوية عن الهدف — براحتك، عدّل بكرة';
  }
  final formatted = _formatKcal(remainingKcal);
  return isFemale
      ? 'فاضلكِ $formatted سعرة — كُلي براحتك'
      : 'فاضلك $formatted سعرة — كُل براحتك';
}

String mascotCaptionEn({
  required int remainingKcal,
  required bool isOver,
}) {
  if (isOver) return 'A bit over target — ease up tomorrow';
  return '$remainingKcal kcal left — eat freely';
}

String _formatKcal(int n) {
  final s = n.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
  }
  return buf.toString();
}
