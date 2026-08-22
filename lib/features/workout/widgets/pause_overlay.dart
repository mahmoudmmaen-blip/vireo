import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

class PauseOverlay extends ConsumerWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(workoutFlowProvider);
    if (flow == null || !flow.isPaused) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final notifier = ref.read(workoutFlowProvider.notifier);

    return Material(
      color: colors.background.withValues(alpha: 0.94),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.workoutPausedTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => notifier.togglePause(false),
                    child: Text(l10n.workoutResume),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      final end = await _confirmEnd(context, l10n);
                      if (end && context.mounted) {
                        notifier.clearSession();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(l10n.workoutEndWorkout),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => notifier.restartWorkout(),
                    child: Text(l10n.workoutRestart),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmEnd(BuildContext context, AppLocalizations l10n) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.workoutEndConfirmTitle),
        content: Text(l10n.workoutEndConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.deleteAccountCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.workoutEndWorkout),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
