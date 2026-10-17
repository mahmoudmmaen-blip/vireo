import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/notifications/domain/notification_settings.dart';
import 'package:vireo/features/notifications/domain/nurture_plan.dart';
import 'package:vireo/features/notifications/services/nurture_scheduler.dart';

final _install = DateTime(2026, 10, 10, 18, 0);

NurtureContext _ctx({
  DateTime? now,
  bool goalHit = false,
  bool isFemale = false,
  int max = 2,
  int regular = 0,
  bool ramadan = false,
  int? iftar,
  int? lunch,
  int? dinner,
  String locale = 'ar',
  int quietStartHour = 23,
  int quietEndHour = 7,
}) {
  return NurtureContext(
    installDate: _install,
    now: now ?? DateTime(2026, 10, 10, 19),
    localeCode: locale,
    isFemale: isFemale,
    goalHit: goalHit,
    maxDailyNotifications: max,
    regularDailyCount: regular,
    quietStartHour: quietStartHour,
    quietEndHour: quietEndHour,
    isRamadan: ramadan,
    iftarMinutes: iftar,
    usualLunchLogMinutes: lunch,
    usualDinnerLogMinutes: dinner,
  );
}

class _FakeSink implements NurtureNotificationSink {
  final scheduled = <NurtureSlot>[];
  int cancelCalls = 0;

  @override
  Future<void> cancelNurture() async {
    cancelCalls++;
    scheduled.clear();
  }

  @override
  Future<void> schedule(NurtureSlot slot) async => scheduled.add(slot);
}

void main() {
  group('defaults', () {
    test('maxDailyNotifications defaults to 2', () {
      expect(const NotificationSettings().maxDailyNotifications, 2);
      expect(
        NotificationSettings.fromStorageMap(
          const {},
          hasWorkoutToday: false,
        ).maxDailyNotifications,
        2,
      );
    });
  });

  group('NurturePlan copy', () {
    test('has days 1..7, ids 7001..7007', () {
      expect(NurturePlan.steps.map((s) => s.day), [1, 2, 3, 4, 5, 6, 7]);
      expect(NurturePlan.notificationId(1), 7001);
      expect(NurturePlan.isNurtureId(7007), isTrue);
      expect(NurturePlan.isNurtureId(6000), isFalse);
    });

    test('Arabic copy is gender-aware where it addresses the user', () {
      final d1 = NurturePlan.forDay(1)!;
      final m = NurturePlan.resolve(d1, localeCode: 'ar', isFemale: false);
      final f = NurturePlan.resolve(d1, localeCode: 'ar', isFemale: true);
      expect(m.title, contains('يا بطل'));
      expect(f.title, contains('يا بطلة'));
      expect(m.body, isNot(f.body));
    });

    test('Arabic copy has no blame words and no Latin letters', () {
      final latin = RegExp('[A-Za-z]');
      for (final s in NurturePlan.steps) {
        for (final female in [false, true]) {
          final t = NurturePlan.resolve(s, localeCode: 'ar', isFemale: female);
          for (final text in [t.title, t.body]) {
            expect(text, isNot(contains('عقاب')));
            expect(text, isNot(contains('فشلت')));
            expect(text, isNot(contains('غلطت')));
            expect(latin.hasMatch(text), isFalse, reason: text);
          }
        }
      }
    });

    test('D4 switches to the Ramadan copy in Ramadan mode', () {
      final d4 = NurturePlan.forDay(4)!;
      final normal = NurturePlan.resolve(d4, localeCode: 'ar', isFemale: false);
      final ram = NurturePlan.resolve(d4, localeCode: 'ar', isFemale: false, isRamadan: true);
      expect(ram.title, contains('رمضان'));
      expect(normal.title, isNot(contains('رمضان')));
    });

    test('non-Arabic locales get English', () {
      final t = NurturePlan.resolve(NurturePlan.forDay(2)!, localeCode: 'en', isFemale: false);
      expect(t.title, 'Save your time 😊');
    });
  });

  group('timing', () {
    test('adaptive: D2 follows the usual lunch log, clamped', () {
      final d2 = NurturePlan.forDay(2)!;
      expect(NurturePlan.preferredMinutes(d2), 12 * 60 + 40);
      expect(NurturePlan.preferredMinutes(d2, usualLunchLogMinutes: 14 * 60), 13 * 60 + 40);
      expect(NurturePlan.preferredMinutes(d2, usualLunchLogMinutes: 9 * 60), 10 * 60);
    });

    test('Ramadan: D4 goes out 30 min before iftar', () {
      final d4 = NurturePlan.forDay(4)!;
      expect(
        NurturePlan.preferredMinutes(d4, isRamadan: true, iftarMinutes: 17 * 60 + 40),
        17 * 60 + 10,
      );
    });

    test('quiet hours push a message just after they end', () {
      final m = NurturePlan.avoidQuietHours(
        5 * 60,
        startHour: 23,
        startMinute: 0,
        endHour: 7,
        endMinute: 0,
      );
      expect(m, 7 * 60 + 30);
    });

    test('quiet hours: late evening pulls the message before they start', () {
      final m = NurturePlan.avoidQuietHours(
        23 * 60 + 15,
        startHour: 23,
        startMinute: 0,
        endHour: 7,
        endMinute: 0,
      );
      expect(m, 22 * 60 + 30);
    });

    test('times outside quiet hours are untouched', () {
      expect(
        NurturePlan.avoidQuietHours(
          12 * 60,
          startHour: 23,
          startMinute: 0,
          endHour: 7,
          endMinute: 0,
        ),
        12 * 60,
      );
    });
  });

  group('NurturePlanner', () {
    test('install day 18:00, now 19:00: D1-D5 + D7 (no D6 without goal)', () {
      final slots = NurturePlanner.plan(_ctx());
      expect(slots.map((s) => s.day), [1, 2, 3, 4, 5, 7]);
    });

    test('D6 only when a goal was hit', () {
      final withGoal = NurturePlanner.plan(_ctx(goalHit: true));
      expect(withGoal.map((s) => s.day), contains(6));
      final without = NurturePlanner.plan(_ctx(goalHit: false));
      expect(without.map((s) => s.day), isNot(contains(6)));
    });

    test('max 2 per day: at most ONE nurture message per calendar day', () {
      final slots = NurturePlanner.plan(_ctx(goalHit: true));
      final perDay = <String, int>{};
      for (final s in slots) {
        final k = '${s.when.year}-${s.when.month}-${s.when.day}';
        perDay[k] = (perDay[k] ?? 0) + 1;
      }
      expect(perDay.values.every((c) => c <= 1), isTrue);
    });

    test('cap respected: nothing scheduled when regular reminders fill the cap', () {
      expect(NurturePlanner.plan(_ctx(max: 2, regular: 2)), isEmpty);
      expect(NurturePlanner.plan(_ctx(max: 0)), isEmpty);
      expect(NurturePlanner.plan(_ctx(max: 2, regular: 1)), isNotEmpty);
    });

    test('never inside quiet hours', () {
      final slots = NurturePlanner.plan(
        _ctx(goalHit: true, quietStartHour: 8, quietEndHour: 13),
      );
      for (final s in slots) {
        final m = s.when.hour * 60 + s.when.minute;
        expect(m >= 8 * 60 && m < 13 * 60, isFalse, reason: '${s.day} at ${s.when}');
      }
    });

    test('past slots are skipped (safe to re-run)', () {
      // D3 was due 2026-10-13 17:30 → already past; D4 is 2026-10-14 11:00.
      final slots = NurturePlanner.plan(_ctx(now: DateTime(2026, 10, 14, 10)));
      expect(slots.map((s) => s.day), [4, 5, 7]);
      final later = NurturePlanner.plan(_ctx(now: DateTime(2026, 10, 14, 12)));
      expect(later.map((s) => s.day), [5, 7]);
    });

    test('dates are install day + N at the planned time', () {
      final d1 = NurturePlanner.plan(_ctx()).first;
      expect(d1.when, DateTime(2026, 10, 11, 8, 30));
      expect(d1.payload, 'vireo://progress/weight');
    });

    test('month boundary', () {
      final slots = NurturePlanner.plan(
        NurtureContext(
          installDate: DateTime(2026, 10, 30),
          now: DateTime(2026, 10, 30, 20),
          localeCode: 'ar',
          isFemale: false,
          goalHit: false,
          maxDailyNotifications: 2,
        ),
      );
      expect(slots.first.when.month, 10);
      expect(slots.first.when.day, 31);
      expect(slots[1].when.month, 11);
      expect(slots[1].when.day, 1);
    });

    test('usualLogMinutes needs enough samples and uses the median', () {
      DateTime t(int h, int m) => DateTime(2026, 10, 10, h, m);
      expect(
        NurturePlanner.usualLogMinutes([t(13, 0), t(14, 0)], fromHour: 10, toHour: 16),
        isNull,
      );
      expect(
        NurturePlanner.usualLogMinutes(
          [t(13, 0), t(15, 0), t(14, 0), t(20, 0)],
          fromHour: 10,
          toHour: 16,
        ),
        14 * 60,
      );
    });
  });

  group('NurtureScheduler', () {
    test('cancels old nurture notifications, then schedules the plan', () async {
      final sink = _FakeSink();
      final scheduler = NurtureScheduler(
        sink: sink,
        readContext: () => _ctx(),
        canNotify: () async => true,
      );
      final slots = await scheduler.reschedule();
      expect(sink.cancelCalls, 1);
      expect(sink.scheduled.length, slots.length);
      expect(slots, isNotEmpty);
    });

    test('schedules nothing without permission / reminders', () async {
      final sink = _FakeSink();
      final scheduler = NurtureScheduler(
        sink: sink,
        readContext: () => _ctx(),
        canNotify: () async => false,
      );
      expect(await scheduler.reschedule(), isEmpty);
      expect(sink.scheduled, isEmpty);
      expect(sink.cancelCalls, 1);
    });

    test('schedules nothing when the context is unavailable', () async {
      final sink = _FakeSink();
      final scheduler = NurtureScheduler(
        sink: sink,
        readContext: () => null,
        canNotify: () async => true,
      );
      expect(await scheduler.reschedule(), isEmpty);
    });
  });
}
