import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/app_theme_variant_provider.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';
import 'package:vireo/features/home/living_backgrounds/domain/milestone_tracker.dart';
import 'package:vireo/features/home/living_backgrounds/painters/particle_burst_painter.dart';
import 'package:vireo/features/home/living_backgrounds/painters/step_journey_painter.dart';
import 'package:vireo/features/home/living_backgrounds/providers/living_background_settings_provider.dart';

class LivingStepsBackground extends ConsumerStatefulWidget {
  const LivingStepsBackground({
    super.key,
    required this.stepsCurrent,
    required this.stepsGoal,
    required this.child,
    this.borderRadius = 20.0,
    this.overrideStage,
  });

  final int stepsCurrent;
  final int stepsGoal;
  final Widget child;
  final double borderRadius;
  final int? overrideStage;

  @override
  ConsumerState<LivingStepsBackground> createState() => _LivingStepsBackgroundState();
}

class _LivingStepsBackgroundState extends ConsumerState<LivingStepsBackground>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _burstController;
  late JourneyStage _currentStage;
  JourneyStage? _previousStage;

  @override
  void initState() {
    super.initState();
    _currentStage = widget.overrideStage != null
        ? JourneyStage.fromSteps(widget.overrideStage! * 1000)
        : JourneyStage.fromSteps(widget.stepsCurrent);

    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    // Initial milestone check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkMilestone(widget.stepsCurrent);
    });
  }

  @override
  void didUpdateWidget(covariant LivingStepsBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newStage = widget.overrideStage != null
        ? JourneyStage.fromSteps(widget.overrideStage! * 1000)
        : JourneyStage.fromSteps(widget.stepsCurrent);

    if (newStage.index != _currentStage.index) {
      _previousStage = _currentStage;
      _currentStage = newStage;

      final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (!reduceMotion && mounted) {
        _morphController.forward(from: 0.0);
      }
    }

    if (oldWidget.stepsCurrent != widget.stepsCurrent) {
      _checkMilestone(widget.stepsCurrent);
    }
  }

  Future<void> _checkMilestone(int steps) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final isFemale = ref.read(isFemaleUserProvider);

    final result = await MilestoneTracker.checkAndTriggerMilestone(
      stepsCurrent: steps,
      stepsGoal: widget.stepsGoal,
      l10n: l10n,
      isFemale: isFemale,
    );

    if (result != null && mounted) {
      final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (!reduceMotion) {
        _burstController.forward(from: 0.0);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pack = ref.watch(activeScenePackProvider);
    final variant = ref.watch(appThemeVariantProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // 1. Procedural Living Journey Landscape wrapped in RepaintBoundary for 60fps performance
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _morphController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: StepJourneyPainter(
                      stage: _currentStage,
                      previousStage: _previousStage,
                      pack: pack,
                      variant: variant,
                      morphProgress: _morphController.value,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Main Hero Content (Numbers, Goal, Ring, Stats)
          widget.child,

          // 3. Celebratory Particle Burst Overlay when milestone is hit
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _burstController,
                builder: (context, _) {
                  if (_burstController.value <= 0.0 || _burstController.value >= 1.0) {
                    return const SizedBox.shrink();
                  }
                  return CustomPaint(
                    painter: ParticleBurstPainter(
                      progress: _burstController.value,
                      accentColor: variant.primaryAccent,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
