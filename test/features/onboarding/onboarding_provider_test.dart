import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/features/onboarding/onboarding_screen.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';

void main() {
  test('OnboardingScreen defines 6 step routes §2.2', () {
    expect(OnboardingScreen.routes.length, OnboardingUiState.stepCount);
    expect(OnboardingUiState.stepCount, 6);
  });

  group('OnboardingNotifier §2.2 navigation', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    OnboardingDraft validStep1Draft() => const OnboardingDraft(
          age: 25,
          heightCm: 175,
          weightKg: 75,
        );

    test('step 1 blocks continue until metrics are valid', () {
      expect(container.read(onboardingProvider).canContinue, isFalse);

      container.read(onboardingProvider.notifier).updateDraft(validStep1Draft());
      expect(container.read(onboardingProvider).canContinue, isTrue);
    });

    test('step 5 blocks continue until consent is accepted', () {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.updateDraft(validStep1Draft());

      for (var i = 0; i < 4; i++) {
        notifier.nextStep();
      }
      expect(container.read(onboardingProvider).step, 4);
      expect(container.read(onboardingProvider).canContinue, isFalse);

      notifier.updateDraft(
        container.read(onboardingProvider).draft.copyWith(consentAccepted: true),
      );
      expect(container.read(onboardingProvider).canContinue, isTrue);
    });

    test('advances through all 6 steps and stops at last step', () {
      final notifier = container.read(onboardingProvider.notifier);

      notifier.updateDraft(validStep1Draft());
      notifier.nextStep(); // health
      notifier.nextStep(); // environment
      notifier.nextStep(); // goal
      expect(container.read(onboardingProvider).step, 3);

      notifier.updateDraft(
        container.read(onboardingProvider).draft.copyWith(consentAccepted: true),
      );
      notifier.nextStep(); // consent
      notifier.nextStep(); // notifications
      expect(container.read(onboardingProvider).step, 5);

      notifier.nextStep();
      expect(container.read(onboardingProvider).step, 5);
    });

    test('previousStep returns to prior step', () {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.updateDraft(validStep1Draft());
      notifier.nextStep();
      expect(container.read(onboardingProvider).step, 1);

      notifier.previousStep();
      expect(container.read(onboardingProvider).step, 0);
    });
  });
}
