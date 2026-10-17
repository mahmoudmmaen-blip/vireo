import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/merciful_streak.dart';

/// Builds a [hit] predicate from offsets (0 = today, 1 = yesterday...).
bool Function(DateTime) _hits(DateTime today, Set<int> offsets) {
  final base = DateTime(today.year, today.month, today.day);
  final keys = {
    for (final o in offsets) DateTime(base.year, base.month, base.day - o),
  };
  return (d) => keys.contains(DateTime(d.year, d.month, d.day));
}

void main() {
  final today = DateTime(2026, 10, 16, 15);

  MercifulStreak run(Set<int> offsets) =>
      MercifulStreakEngine.compute(hit: _hits(today, offsets), today: today);

  test('plain streak: today + 4 previous days', () {
    final s = run({0, 1, 2, 3, 4});
    expect(s.days, 5);
    expect(s.usedRestDay, isFalse);
    expect(s.restTokenAvailable, isTrue);
  });

  test('today not hit yet is pending, not a miss', () {
    final s = run({1, 2, 3});
    expect(s.days, 3);
    expect(s.usedRestDay, isFalse);
  });

  test('one miss does not reset: rest day bridges it', () {
    // hit today, MISS yesterday, hit before that
    final s = run({0, 2, 3, 4});
    expect(s.days, 4);
    expect(s.restDays, [DateTime(2026, 10, 15)]);
    expect(s.restTokenAvailable, isFalse);
  });

  test('yesterday missed, today still pending → streak is kept', () {
    final s = run({2, 3, 4});
    expect(s.days, 3);
    expect(s.usedRestDay, isTrue);
  });

  test('two misses in a row end the streak', () {
    final s = run({0, 3, 4, 5});
    expect(s.days, 1);
    expect(s.usedRestDay, isFalse);
  });

  test('token cooldown: second miss within 7 days is NOT forgiven', () {
    // misses at offsets 1 and 4 (3 days apart)
    final s = run({0, 2, 3, 5, 6});
    expect(s.days, 3); // today, 2, 3 ; offset 4 miss can't be bridged
    expect(s.restDays.length, 1);
  });

  test('token comes back after 7 days', () {
    // misses at offsets 1 and 8 (7 apart) → both forgiven
    final hits = {0, ...List.generate(6, (i) => i + 2), ...List.generate(5, (i) => i + 9)};
    final s = run(hits);
    expect(s.restDays.length, 2);
    expect(s.days, hits.length);
  });

  test('no history → 0', () {
    expect(run({}).days, 0);
    expect(MercifulStreak.empty.days, 0);
  });

  test('a miss right before the very first hit is not bridged', () {
    // only today hit, yesterday missed, nothing older
    final s = run({0});
    expect(s.days, 1);
    expect(s.usedRestDay, isFalse);
  });
}
