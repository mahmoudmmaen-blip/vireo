import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';
import 'package:vireo/features/workout/screens/active_exercise_screen.dart';
import 'package:vireo/features/workout/screens/mobility_phase_screen.dart';
import 'package:vireo/features/workout/screens/warm_up_screen.dart';
import 'package:vireo/features/workout/screens/workout_feedback_screen.dart';
import 'package:vireo/features/workout/widgets/pause_overlay.dart';
import 'package:vireo/features/workout/widgets/rest_timer_overlay.dart';

class WorkoutFlowScreen extends ConsumerWidget {
  const WorkoutFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(workoutFlowProvider);
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    if (flow == null || flow.phase == WorkoutFlowPhase.complete) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final profile = ref.watch(userProfileProvider);
    final showMedical = profile.maybeWhen(
      data: (p) => p.medicalFlag,
      orElse: () => false,
    );

    final showPause = flow.phase == WorkoutFlowPhase.active ||
        flow.phase == WorkoutFlowPhase.warmUp ||
        flow.phase == WorkoutFlowPhase.coolDown;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        ref.read(workoutFlowProvider.notifier).togglePause(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: Text(_titleForPhase(l10n, flow.phase)),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () =>
                ref.read(workoutFlowProvider.notifier).togglePause(true),
          ),
          actions: [
            if (showPause)
              IconButton(
                icon: const Icon(Icons.pause_circle_outline),
                onPressed: () =>
                    ref.read(workoutFlowProvider.notifier).togglePause(true),
              ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _PhaseBody(flow: flow, showMedical: showMedical),
            const RestTimerOverlay(),
            const PauseOverlay(),
          ],
        ),
      ),
    );
  }

  String _titleForPhase(AppLocalizations l10n, WorkoutFlowPhase phase) {
    switch (phase) {
      case WorkoutFlowPhase.warmUp:
        return l10n.workoutWarmUpTitle;
      case WorkoutFlowPhase.active:
        return l10n.workoutActiveTitle;
      case WorkoutFlowPhase.coolDown:
        return l10n.workoutCoolDownTitle;
      case WorkoutFlowPhase.feedback:
        return l10n.workoutFeedbackTitle;
      case WorkoutFlowPhase.complete:
        return l10n.workoutTitle;
    }
  }
}

class _PhaseBody extends ConsumerWidget {
  const _PhaseBody({required this.flow, required this.showMedical});

  final WorkoutFlowState flow;
  final bool showMedical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(workoutFlowProvider.notifier);

    switch (flow.phase) {
      case WorkoutFlowPhase.warmUp:
        return WarmUpScreen(
          showMedicalBanner: showMedical,
          onSkip: notifier.beginActivePhase,
          onComplete: notifier.beginActivePhase,
        );
      case WorkoutFlowPhase.active:
        if (flow.exercises.isEmpty) {
          return _EmptyWorkout(onContinue: notifier.beginCoolDownPhase);
        }
        return ActiveExerciseScreen(showMedicalBanner: showMedical);
      case WorkoutFlowPhase.coolDown:
        return MobilityPhaseScreen(
          title: l10n.workoutCoolDownTitle,
          subtitle: l10n.workoutCoolDownSubtitle,
          exercises: flow.session.coolDown,
          continueLabel: l10n.workoutFinishCoolDown,
          onContinue: notifier.beginFeedbackPhase,
          showMedicalBanner: showMedical,
        );
      case WorkoutFlowPhase.feedback:
        return const WorkoutFeedbackScreen();
      case WorkoutFlowPhase.complete:
        return const SizedBox.shrink();
    }
  }
}

class _EmptyWorkout extends StatelessWidget {
  const _EmptyWorkout({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.workoutEmptyProgram),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onContinue,
              child: Text(l10n.continueButton),
            ),
          ],
        ),
      ),
    );
  }
}
