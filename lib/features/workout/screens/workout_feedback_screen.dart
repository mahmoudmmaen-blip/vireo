import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

class WorkoutFeedbackScreen extends ConsumerStatefulWidget {
  const WorkoutFeedbackScreen({super.key});

  @override
  ConsumerState<WorkoutFeedbackScreen> createState() =>
      _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends ConsumerState<WorkoutFeedbackScreen> {
  bool _submitting = false;

  Future<void> _submit(WorkoutDifficultyFeedback feedback) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await ref.read(workoutRepositoryProvider).saveWorkoutFeedback(
            sessionId: ref.read(workoutFlowProvider)!.session.id,
            feedback: feedback,
          );
      ref.read(workoutFlowProvider.notifier).completeWorkout();
      ref.read(workoutFlowProvider.notifier).clearSession();
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            l10n.workoutFeedbackTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _FeedbackButton(
            label: l10n.workoutFeedbackEasy,
            color: colors.success,
            enabled: !_submitting,
            onTap: () => _submit(WorkoutDifficultyFeedback.easy),
          ),
          const SizedBox(height: 12),
          _FeedbackButton(
            label: l10n.workoutFeedbackJustRight,
            color: colors.ember,
            enabled: !_submitting,
            onTap: () => _submit(WorkoutDifficultyFeedback.justRight),
          ),
          const SizedBox(height: 12),
          _FeedbackButton(
            label: l10n.workoutFeedbackHard,
            color: colors.danger,
            enabled: !_submitting,
            onTap: () => _submit(WorkoutDifficultyFeedback.hard),
          ),
          if (_submitting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.label,
    required this.color,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: color),
        foregroundColor: color,
      ),
      onPressed: enabled ? onTap : null,
      child: Text(label),
    );
  }
}
