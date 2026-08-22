import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/rest_alert_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

class RestTimerOverlay extends ConsumerStatefulWidget {
  const RestTimerOverlay({super.key});

  @override
  ConsumerState<RestTimerOverlay> createState() => _RestTimerOverlayState();
}

class _RestTimerOverlayState extends ConsumerState<RestTimerOverlay> {
  int? _lastRemaining;

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(workoutFlowProvider);
    if (flow == null || !flow.isRestActive) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final remaining = flow.restSecondsRemaining;

    if (_lastRemaining != remaining) {
      _lastRemaining = remaining;
      RestAlertService.onTick(remaining);
    }

    return Material(
      color: colors.background.withValues(alpha: 0.92),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.workoutRestTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Text(
                  _formatTime(remaining),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: colors.ember,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        RestAlertService.resetAlerts();
                        ref.read(workoutFlowProvider.notifier).skipRest();
                      },
                      child: Text(l10n.workoutRestSkip),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(workoutFlowProvider.notifier).addRestTime(15),
                      child: Text(l10n.workoutRestAdd15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
