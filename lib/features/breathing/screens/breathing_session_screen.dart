import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/breathing/screens/breathing_hub_screen.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';

class BreathingSessionScreen extends ConsumerStatefulWidget {
  const BreathingSessionScreen({
    super.key,
    required this.pattern,
    required this.minutes,
  });

  final BreathingPattern pattern;
  final int minutes;

  @override
  ConsumerState<BreathingSessionScreen> createState() =>
      _BreathingSessionScreenState();
}

class _BreathingSessionScreenState extends ConsumerState<BreathingSessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  Timer? _timer;
  int _remaining = 0;
  int _phaseIndex = 0;
  String _phaseLabel = '';

  List<int> get _durations => switch (widget.pattern) {
        BreathingPattern.box => [4, 4, 4, 4],
        BreathingPattern.fourSevenEight => [4, 7, 8, 0],
      };

  List<String> _labels(AppLocalizations l10n) => switch (widget.pattern) {
        BreathingPattern.box => [
            l10n.breathingInhale,
            l10n.breathingHold,
            l10n.breathingExhale,
            l10n.breathingHold,
          ],
        BreathingPattern.fourSevenEight => [
            l10n.breathingInhale,
            l10n.breathingHold,
            l10n.breathingExhale,
            l10n.breathingRest,
          ],
      };

  @override
  void initState() {
    super.initState();
    _remaining = widget.minutes * 60;
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        _nextPhase();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPhase());
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remaining <= 1) {
        t.cancel();
        _finish();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _startPhase() {
    final l10n = AppLocalizations.of(context);
    final labels = _labels(l10n);
    final dur = _durations[_phaseIndex % _durations.length];
    if (dur <= 0) {
      _phaseIndex++;
      _startPhase();
      return;
    }
    setState(() => _phaseLabel = labels[_phaseIndex % labels.length]);
    _ctrl.duration = Duration(seconds: dur);
    if (_phaseIndex % 2 == 0) {
      _ctrl.forward(from: 0);
    } else {
      _ctrl.reverse(from: 1);
    }
    HapticFeedback.lightImpact();
  }

  void _nextPhase() {
    _phaseIndex++;
    if (mounted) _startPhase();
  }

  Future<void> _finish() async {
    await ref.read(vitalityDailyLogProvider.notifier).logBreathingSession();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final min = _remaining ~/ 60;
    final sec = _remaining % 60;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.breathingSessionTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_phaseLabel, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final scale = 0.6 + _ctrl.value * 0.5;
                return Container(
                  width: 180 * scale,
                  height: 180 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.recovery.withValues(alpha: 0.25),
                    border: Border.all(color: colors.recovery, width: 3),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }
}
