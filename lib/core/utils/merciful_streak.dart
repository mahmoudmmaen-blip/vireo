import 'package:flutter/foundation.dart';

/// Result of a merciful streak calculation.
@immutable
class MercifulStreak {
  const MercifulStreak({
    required this.days,
    this.restDays = const [],
    this.restTokenAvailable = true,
  });

  /// Days that were actually "hit" (rest days are bridged, never counted).
  final int days;

  /// Missed days that were forgiven with the "يوم راحة" token.
  final List<DateTime> restDays;

  /// True when a missed day could still be forgiven right now
  /// (no rest token used in the last [MercifulStreakEngine.tokenCooldownDays] days).
  final bool restTokenAvailable;

  bool get usedRestDay => restDays.isNotEmpty;

  static const empty = MercifulStreak(days: 0);

  @override
  bool operator ==(Object other) =>
      other is MercifulStreak &&
      other.days == days &&
      other.restTokenAvailable == restTokenAvailable &&
      listEquals(other.restDays, restDays);

  @override
  int get hashCode => Object.hash(days, restTokenAvailable, Object.hashAll(restDays));
}

/// Streak math with a "يوم راحة" (rest day) token (P40 §7: streaks are merciful).
///
/// Rules:
/// 1. Walk back from today counting days where [hit] is true.
/// 2. Today without a hit is still pending — it never breaks or forgives anything.
/// 3. ONE isolated missed day is forgiven (the streak continues across it, the
///    rest day itself is not counted). The day before the miss must be a hit,
///    so two misses in a row end the streak.
/// 4. The token comes back after [tokenCooldownDays]: two forgiven days must be
///    at least that far apart.
abstract final class MercifulStreakEngine {
  static const int tokenCooldownDays = 7;

  static MercifulStreak compute({
    required bool Function(DateTime day) hit,
    DateTime? today,
    int maxLookbackDays = 365,
  }) {
    final now = today ?? DateTime.now();
    final base = DateTime(now.year, now.month, now.day);
    DateTime dayAt(int back) => DateTime(base.year, base.month, base.day - back);

    var days = 0;
    final rest = <DateTime>[];
    int? lastRestIndex;
    int? mostRecentRestIndex;

    for (var i = 0; i < maxLookbackDays; i++) {
      final day = dayAt(i);
      if (hit(day)) {
        days++;
        continue;
      }
      if (i == 0) continue; // today is still pending

      final tokenReady =
          lastRestIndex == null || i - lastRestIndex >= tokenCooldownDays;
      final olderDayHit = hit(dayAt(i + 1));
      if (tokenReady && olderDayHit) {
        rest.add(day);
        lastRestIndex = i;
        mostRecentRestIndex ??= i;
        continue;
      }
      break;
    }

    final available = mostRecentRestIndex == null ||
        mostRecentRestIndex >= tokenCooldownDays;
    return MercifulStreak(
      days: days,
      restDays: rest,
      restTokenAvailable: available,
    );
  }
}
