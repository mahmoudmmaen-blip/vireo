import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step6Notifications extends ConsumerWidget {
  const Step6Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final authState = ref.watch(authProvider).valueOrNull;
    final userId = authState is AppAuthAuthenticated ? authState.user.id : null;

    Future<void> finish() async {
      final ok = await ref.read(onboardingProvider.notifier).complete(
            userId: userId,
          );
      if (!ok && context.mounted) return;
    }

    return OnboardingStepShell(
      stepIndex: 5,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep6Title,
      subtitle: l10n.onboardingStep6Subtitle,
      canContinue: !state.isSubmitting,
      isLoading: state.isSubmitting,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onContinue: finish,
      secondaryLabel: l10n.skipButton,
      onSecondary: state.isSubmitting
          ? null
          : () => ref.read(onboardingProvider.notifier).skipNotificationsAndComplete(
                userId: userId,
              ),
      continueLabel: l10n.finishButton,
      child: Column(
        children: [
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                state.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.notificationWorkoutTime),
            subtitle: Text(
              draft.preferredWorkoutTime != null
                  ? TimeOfDay.fromDateTime(draft.preferredWorkoutTime!).format(context)
                  : l10n.notificationNotSet,
            ),
            trailing: const Icon(Icons.schedule),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time == null) return;
              final now = DateTime.now();
              final picked = DateTime(
                now.year,
                now.month,
                now.day,
                time.hour,
                time.minute,
              );
              ref.read(onboardingProvider.notifier).updateDraft(
                    draft.copyWith(preferredWorkoutTime: picked),
                  );
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.notificationWalkingReminder),
            value: draft.walkingReminderEnabled,
            onChanged: (v) => ref.read(onboardingProvider.notifier).updateDraft(
                  draft.copyWith(walkingReminderEnabled: v),
                ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.notificationWeeklyCheckIn),
            value: draft.weeklyCheckInReminderEnabled,
            onChanged: (v) => ref.read(onboardingProvider.notifier).updateDraft(
                  draft.copyWith(weeklyCheckInReminderEnabled: v),
                ),
          ),
        ],
      ),
    );
  }
}
