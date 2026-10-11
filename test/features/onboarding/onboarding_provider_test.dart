import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/features/onboarding/onboarding_screen.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';

void main() {
  test('OnboardingScreen defines 9 step routes §P13', () {
    expect(OnboardingScreen.routes.length, OnboardingUiState.stepCount);
    expect(OnboardingUiState.stepCount, 9);
  });

  group('OnboardingNotifier §P13 navigation', () {
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

    test('step 2 (body) validates metrics', () {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.goToStep(2);
      expect(container.read(onboardingProvider).canContinue, isFalse);

      notifier.updateDraft(validStep1Draft());
      expect(container.read(onboardingProvider).canContinue, isTrue);
    });

    test('advances through all 9 steps and stops at last step', () {
      final notifier = container.read(onboardingProvider.notifier);

      for (var i = 0; i < 12; i++) {
        notifier.nextStep();
      }
      expect(container.read(onboardingProvider).step, 8);
    });

    test('previousStep returns to prior step', () {
      final notifier = container.read(onboardingProvider.notifier);
      notifier.nextStep();
      expect(container.read(onboardingProvider).step, 1);

      notifier.previousStep();
      expect(container.read(onboardingProvider).step, 0);
    });
  });
}
