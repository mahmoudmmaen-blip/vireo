import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/repositories/reassessment_repository.dart';

void main() {
  group('Reassessment Scheduling Rules (P22a #2)', () {
    test('never shows during the first 7 days after onboarding', () {
      final onboardingDate = DateTime(2026, 10, 1);

      // Day 0 to Day 6
      for (var day = 0; day < 7; day++) {
        final checkDate = onboardingDate.add(Duration(days: day));
        final due = ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: null,
          referenceNow: checkDate,
          onboardingComplete: true,
          onboardingCompletedAt: onboardingDate,
        );
        expect(due, isFalse, reason: 'Should not trigger on day $day after onboarding');
      }
    });

    test('triggers at most once per 30 days after the last completed check-in', () {
      final lastCheckIn = DateTime(2026, 8, 1);

      // Before 30 days: false
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: DateTime(2026, 8, 20), // 19 days
          onboardingComplete: true,
        ),
        isFalse,
      );
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: DateTime(2026, 8, 30), // 29 days
          onboardingComplete: true,
        ),
        isFalse,
      );

      // At 30 days or more: true
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: DateTime(2026, 8, 31), // 30 days
          onboardingComplete: true,
        ),
        isTrue,
      );
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: DateTime(2026, 9, 15), // 45 days
          onboardingComplete: true,
        ),
        isTrue,
      );
    });

    test('snoozing for 3 days suppresses the check-in until snooze expires', () {
      final lastCheckIn = DateTime(2026, 8, 1);
      final checkDate = DateTime(2026, 9, 5); // 35 days after last (would normally be due)

      final snoozedUntil = checkDate.add(const Duration(days: 3));

      // Day 1 of snooze: not due
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: checkDate.add(const Duration(days: 1)),
          onboardingComplete: true,
          snoozedUntil: snoozedUntil,
        ),
        isFalse,
      );

      // Day 2 of snooze: not due
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: checkDate.add(const Duration(days: 2)),
          onboardingComplete: true,
          snoozedUntil: snoozedUntil,
        ),
        isFalse,
      );

      // After 3 days (snooze expired): due again
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: lastCheckIn,
          referenceNow: checkDate.add(const Duration(days: 4)),
          onboardingComplete: true,
          snoozedUntil: snoozedUntil,
        ),
        isTrue,
      );
    });

    test('requires onboarding to be complete', () {
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: null,
          referenceNow: DateTime(2026, 10, 1),
          onboardingComplete: false,
        ),
        isFalse,
      );
    });

    test('first check-in is due 30 days after onboarding completion', () {
      final onboardingDate = DateTime(2026, 1, 1);

      // 15 days after onboarding: not due
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: null,
          referenceNow: DateTime(2026, 1, 16),
          onboardingComplete: true,
          onboardingCompletedAt: onboardingDate,
        ),
        isFalse,
      );

      // 30 days after onboarding: due!
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: null,
          referenceNow: DateTime(2026, 1, 31),
          onboardingComplete: true,
          onboardingCompletedAt: onboardingDate,
        ),
        isTrue,
      );
    });
  });
}
