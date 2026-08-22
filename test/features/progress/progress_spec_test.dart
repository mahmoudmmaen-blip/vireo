import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/repositories/reassessment_repository.dart';

void main() {
  group('ProgressTab §2.7 segmented tabs', () {
    test('defines weight, adherence, and energy', () {
      expect(ProgressTab.values.length, 3);
      expect(ProgressTab.values, containsAll([
        ProgressTab.weight,
        ProgressTab.adherence,
        ProgressTab.energy,
      ]));
    });
  });

  group('WeightLogEntry §2.7 quick weight log', () {
    test('serializes kg and logged_at for repository cache', () {
      final at = DateTime.utc(2026, 8, 22, 9, 30);
      final entry = WeightLogEntry(
        id: 'w1',
        weightKg: 78.4,
        loggedAt: at,
      );

      final json = entry.toJson();
      expect(json['weight_kg'], 78.4);
      expect(json['logged_at'], at.toIso8601String());

      final parsed = WeightLogEntry.fromJson(json);
      expect(parsed.weightKg, 78.4);
      expect(parsed.loggedAt, at);
    });
  });

  group('ReassessmentRecord §2.7 monthly check-in', () {
    test('fromJson parses phase recalculation flag', () {
      final record = ReassessmentRecord.fromJson({
        'weight_kg': 80,
        'activity_level': 'moderately_active',
        'training_environment': 'gym_full',
        'program_phase': 2,
        'created_at': '2026-08-22T10:00:00.000Z',
        'phase_recalculated': true,
      });

      expect(record.programPhase, 2);
      expect(record.phaseRecalculated, isTrue);
    });
  });

  group('ReassessmentRepository §2.7 monthly background check', () {
    test('minDaysBetween is 28 days', () {
      expect(ReassessmentRepository.minDaysBetween, 28);
    });

    test('isReassessmentDueFor triggers after 28 days', () {
      final last = DateTime(2026, 7, 1);
      final now = DateTime(2026, 8, 1);

      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: last,
          referenceNow: now,
          onboardingComplete: true,
        ),
        isTrue,
      );
    });

    test('isReassessmentDueFor false before 28 days', () {
      final last = DateTime(2026, 8, 1);
      final now = DateTime(2026, 8, 20);

      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: last,
          referenceNow: now,
          onboardingComplete: true,
        ),
        isFalse,
      );
    });

    test('isReassessmentDueFor requires onboarding when no prior check-in', () {
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: null,
          referenceNow: DateTime(2026, 8, 22),
          onboardingComplete: false,
        ),
        isFalse,
      );
      expect(
        ReassessmentRepository.isReassessmentDueFor(
          lastReassessment: null,
          referenceNow: DateTime(2026, 8, 22),
          onboardingComplete: true,
        ),
        isTrue,
      );
    });
  });
}
