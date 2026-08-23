import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/workout/widgets/medical_banner.dart';

class WarmUpScreen extends ConsumerStatefulWidget {
  const WarmUpScreen({
    super.key,
    required this.showMedicalBanner,
    required this.onSkip,
    required this.onComplete,
  });

  final bool showMedicalBanner;
  final VoidCallback onSkip;
  final VoidCallback onComplete;

  @override
  ConsumerState<WarmUpScreen> createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends ConsumerState<WarmUpScreen>
    with SingleTickerProviderStateMixin {
  int _stepIndex = 0;
  int _secondsLeft = 30;
  Timer? _timer;
  late final AnimationController _pulse;
  bool _timerStarted = false;
  final Map<int, String> _overrides = {};

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.92,
      upperBound: 1.08,
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_timerStarted) {
      _timerStarted = true;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  List<_WarmUpStep> _baseSteps(AppLocalizations l10n) => [
        _WarmUpStep(l10n.workoutWarmUpStep1, 30, Icons.accessibility_new),
        _WarmUpStep(l10n.workoutWarmUpStep2, 60, Icons.directions_walk),
        _WarmUpStep(l10n.workoutWarmUpStep3, 10, Icons.fitness_center),
      ];

  List<_WarmUpStep> _steps(AppLocalizations l10n) {
    final base = _baseSteps(l10n);
    return [
      for (var i = 0; i < base.length; i++)
        _WarmUpStep(
          _overrides[i] ?? base[i].label,
          base[i].durationSeconds,
          base[i].icon,
        ),
    ];
  }

  void _startTimer() {
    _timer?.cancel();
    final l10n = AppLocalizations.of(context);
    final steps = _steps(l10n);
    _secondsLeft = steps[_stepIndex].durationSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        _advance();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _advance() {
    final l10n = AppLocalizations.of(context);
    final steps = _steps(l10n);
    if (_stepIndex >= steps.length - 1) {
      _timer?.cancel();
      widget.onComplete();
      return;
    }
    setState(() => _stepIndex++);
    _startTimer();
  }

  Future<void> _swapCurrentStep() async {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = ref.read(localeProvider).languageCode;
    final env = ref.read(workoutProfileProvider).env;
    final alts = await ref.read(exerciseRepositoryProvider).fetchWarmUpAlternatives(
          environment: env,
          excludeId: 'warmup-$_stepIndex',
        );
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.workoutSwapWarmUpTitle, style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(l10n.workoutSwapWarmUpSubtitle, style: TextStyle(color: colors.textMute)),
                const SizedBox(height: 12),
                if (alts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.workoutSwapEmpty, textAlign: TextAlign.center),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: alts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final alt = alts[i];
                        return ListTile(
                          title: Text(alt.localizedName(locale)),
                          subtitle: Text(alt.localizedTargetMuscle(locale)),
                          onTap: () {
                            setState(() {
                              _overrides[_stepIndex] = alt.localizedName(locale);
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final steps = _steps(l10n);
    final step = steps[_stepIndex];
    final progress = (_stepIndex + 1) / steps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showMedicalBanner) const MedicalBanner(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  l10n.workoutWarmUpTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.workoutWarmUpSubtitle,
                  style: TextStyle(color: colors.textMute),
                ),
                const SizedBox(height: 24),
                ScaleTransition(
                  scale: _pulse,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: VireoDecorations.emberGradient,
                      boxShadow: VireoDecorations.cardShadow(glow: colors.ember),
                    ),
                    child: Icon(step.icon, size: 48, color: colors.text),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  step.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  '$_secondsLeft',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: colors.ember,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _swapCurrentStep,
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: Text(l10n.workoutSwapWarmUp),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colors.line,
                  color: colors.ember,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: List.generate(steps.length, (i) {
                      final active = i == _stepIndex;
                      final done = i < _stepIndex;
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          done ? Icons.check_circle : steps[i].icon,
                          color: done
                              ? colors.success
                              : active
                                  ? colors.ember
                                  : colors.textMute,
                        ),
                        title: Text(
                          steps[i].label,
                          style: TextStyle(
                            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                            color: active ? colors.text : colors.textMute,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_stepIndex >= steps.length - 1 && _secondsLeft <= 1)
                ElevatedButton(
                  onPressed: widget.onComplete,
                  child: Text(l10n.workoutStartMainWorkout),
                )
              else
                ElevatedButton(
                  onPressed: _advance,
                  child: Text(l10n.continueButton),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onSkip,
                child: Text(l10n.workoutSkipWarmUp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WarmUpStep {
  const _WarmUpStep(this.label, this.durationSeconds, this.icon);

  final String label;
  final int durationSeconds;
  final IconData icon;
}
