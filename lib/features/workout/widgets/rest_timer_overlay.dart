import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/rest_alert_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

import 'package:vireo/core/services/workout_tts_service.dart';

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
    final total = flow.totalRestSeconds > 0 ? flow.totalRestSeconds : remaining;
    final progress = total > 0 ? (remaining / total).clamp(0.0, 1.0) : 0.0;
    final lang = Localizations.localeOf(context).languageCode;

    if (_lastRemaining != remaining) {
      _lastRemaining = remaining;
      RestAlertService.onTick(remaining);
      _checkTtsCue(remaining, lang);
    }

    return Material(
      color: colors.background.withValues(alpha: 0.94),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.workoutRestTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: colors.surfaceRaised,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.ember),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(remaining),
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w800,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'ar' ? 'ثانية راحة' : 'seconds rest',
                          style: TextStyle(color: colors.textMute, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        RestAlertService.resetAlerts();
                        WorkoutTtsService.instance.stop();
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

  void _checkTtsCue(int secondsRemaining, String lang) {
    if (secondsRemaining == 3) {
      WorkoutTtsService.instance.speak(lang == 'ar' ? 'ثلاثة' : 'Three', languageCode: lang);
    } else if (secondsRemaining == 2) {
      WorkoutTtsService.instance.speak(lang == 'ar' ? 'اثنان' : 'Two', languageCode: lang);
    } else if (secondsRemaining == 1) {
      WorkoutTtsService.instance.speak(lang == 'ar' ? 'واحد' : 'One', languageCode: lang);
    } else if (secondsRemaining == 0) {
      WorkoutTtsService.instance.speak(lang == 'ar' ? 'ابدأ المجموعة التالية' : 'Start your next set', languageCode: lang);
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
