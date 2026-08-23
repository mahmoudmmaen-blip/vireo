import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/onboarding_calorie_sync.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/data/models/unit_preference.dart';
import 'package:vireo/data/repositories/onboarding_repository.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';

class OnboardingUiState {
  const OnboardingUiState({
    required this.step,
    required this.draft,
    this.isSubmitting = false,
    this.errorMessage,
  });

  static const stepCount = 6;

  final int step;
  final OnboardingDraft draft;
  final bool isSubmitting;
  final String? errorMessage;

  bool get canContinue {
    switch (step) {
      case 0:
        return draft.isStep1Valid;
      case 1:
      case 2:
      case 3:
        return true;
      case 4:
        return draft.isStep5Valid;
      case 5:
        return true;
      default:
        return false;
    }
  }

  OnboardingUiState copyWith({
    int? step,
    OnboardingDraft? draft,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return OnboardingUiState(
      step: step ?? this.step,
      draft: draft ?? this.draft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingUiState> {
  @override
  OnboardingUiState build() {
    final locale = ref.watch(localeProvider);
    return OnboardingUiState(
      step: 0,
      draft: OnboardingDraft(
        unitPreference: UnitPreference.fromLocale(locale.countryCode),
      ),
    );
  }

  void updateDraft(OnboardingDraft draft) {
    state = state.copyWith(draft: draft, errorMessage: null);
    if (draft.isStep1Valid) {
      OnboardingCalorieSync.syncFromDraft(draft).then((_) {
        ref.invalidate(calorieGoalProvider);
      });
    }
  }

  void nextStep() {
    if (!state.canContinue || state.step >= OnboardingUiState.stepCount - 1) {
      return;
    }
    state = state.copyWith(step: state.step + 1);
  }

  void previousStep() {
    if (state.step <= 0) return;
    state = state.copyWith(step: state.step - 1);
  }

  Future<bool> complete({String? userId}) async {
    if (state.isSubmitting) return false;
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final repo = ref.read(onboardingRepositoryProvider);
      await repo.completeOnboarding(userId: userId, draft: state.draft);
      await OnboardingCalorieSync.syncFromDraft(state.draft);
      ref.invalidate(onboardingCompleteProvider);
      ref.invalidate(calorieGoalProvider);
      ref.invalidate(todayWorkoutProvider);
      ref.invalidate(allExercisesProvider);
      ref.invalidate(effectiveTodayMealsProvider);
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> skipNotificationsAndComplete({String? userId}) async {
    return complete(userId: userId);
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => const OnboardingRepository(),
);

final onboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(onboardingRepositoryProvider).isOnboardingComplete;
});

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingUiState>(
  OnboardingNotifier.new,
);
