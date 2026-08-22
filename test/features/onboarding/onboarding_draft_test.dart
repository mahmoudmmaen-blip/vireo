import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/models/unit_preference.dart';

void main() {
  group('OnboardingDraft §2.2 step 1 — metric storage', () {
    test('isStep1Valid requires age, heightCm, weightKg', () {
      const empty = OnboardingDraft();
      expect(empty.isStep1Valid, isFalse);

      const valid = OnboardingDraft(
        age: 30,
        heightCm: 175,
        weightKg: 78.5,
      );
      expect(valid.isStep1Valid, isTrue);
    });

    test('toUserRow persists kg/cm and activity_level', () {
      const draft = OnboardingDraft(
        age: 28,
        heightCm: 180,
        weightKg: 82,
        activityLevel: ActivityLevel.veryActive,
        dietaryRestrictions: ['halal'],
        unitPreference: UnitPreference.imperial,
      );

      final row = draft.toUserRow('user-1');
      expect(row['height_cm'], 180);
      expect(row['weight_kg'], 82);
      expect(row['activity_level'], 'very_active');
      expect(row['dietary_restrictions'], ['halal']);
      expect(row['unit_preference'], 'imperial');
    });
  });

  group('OnboardingDraft §2.2 step 2 — medical_flag', () {
    test('medical_flag false when all health answers are no', () {
      const draft = OnboardingDraft();
      expect(draft.medicalFlag, isFalse);
      expect(draft.toUserRow('u')['medical_flag'], isFalse);
    });

    test('medical_flag true when any health answer is yes', () {
      const draft = OnboardingDraft(diabetes: true);
      expect(draft.medicalFlag, isTrue);
      expect(draft.toUserRow('u')['medical_flag'], isTrue);
    });
  });

  group('OnboardingDraft §2.2 steps 3–4 — environment & goal values', () {
    test('training_environment serializes spec values', () {
      for (final env in TrainingEnvironment.values) {
        final draft = OnboardingDraft(trainingEnvironment: env);
        expect(draft.toUserRow('u')['training_environment'], env.value);
      }

      expect(TrainingEnvironment.values.map((e) => e.value), containsAll([
        'home_no_equipment',
        'home_light_equipment',
        'gym_full',
        'walking_only',
      ]));
    });

    test('goal serializes spec values', () {
      for (final goal in FitnessGoal.values) {
        final draft = OnboardingDraft(goal: goal);
        expect(draft.toUserRow('u')['goal'], goal.value);
      }

      expect(FitnessGoal.values.map((g) => g.value), containsAll([
        'weight_loss',
        'muscle_gain',
        'general_vitality',
        'all_of_above',
      ]));
    });
  });

  group('OnboardingDraft §2.2 step 5 — consent', () {
    test('isStep5Valid requires consentAccepted', () {
      expect(const OnboardingDraft().isStep5Valid, isFalse);
      expect(
        const OnboardingDraft(consentAccepted: true).isStep5Valid,
        isTrue,
      );
    });

    test('consent_accepted_at included when set', () {
      final at = DateTime.utc(2026, 1, 15, 10);
      final draft = OnboardingDraft(
        consentAccepted: true,
        consentAcceptedAt: at,
      );
      expect(draft.toUserRow('u')['consent_accepted_at'], at.toIso8601String());
    });
  });
}
