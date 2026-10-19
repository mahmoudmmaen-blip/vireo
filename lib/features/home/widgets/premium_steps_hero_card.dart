import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme_variant_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';
import 'package:vireo/features/home/living_backgrounds/widgets/living_steps_background.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/step_foreground_service.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

/// Steps hero card matching Leap Step Tracker (leap_step_tracker_home.jpg).
/// Features:
/// - Huge step number with edit goal icon
/// - "/7000 خطوة"
/// - Big Play / Pause button
/// - Thick progress bar
/// - 3 stats: كم (Distance), سعرات (Calories), الوقت (Time)
/// - 7-day circular row with stars on goal reached + daily average
class PremiumStepsHeroCard extends ConsumerStatefulWidget {
  const PremiumStepsHeroCard({
    super.key,
    required this.stepsCurrent,
    required this.stepsGoal,
    required this.onTap,
    this.overrideStage,
  });

  final int stepsCurrent;
  final int stepsGoal;
  final VoidCallback onTap;
  final int? overrideStage;

  static const stepsAccent = Color(0xFF10B981); // Bright Emerald Green
  static const stepsCardBg = Color(0xFF1E293B); // Deep slate blue / Leap style

  @override
  ConsumerState<PremiumStepsHeroCard> createState() => _PremiumStepsHeroCardState();
}

class _PremiumStepsHeroCardState extends ConsumerState<PremiumStepsHeroCard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isSwitching = false;
  DateTime _lastToggleTime = DateTime.fromMillisecondsSinceEpoch(0);
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(isStepCounterRunningProvider.notifier).resync();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleToggle() async {
    final now = DateTime.now();
    if (_isSwitching || now.difference(_lastToggleTime).inMilliseconds < 600) {
      return;
    }
    _lastToggleTime = now;
    HapticFeedback.heavyImpact();

    final runningNotifier = ref.read(isStepCounterRunningProvider.notifier);
    final previousState = ref.read(isStepCounterRunningProvider);
    final targetState = !previousState;

    setState(() => _isSwitching = true);
    // Optimistic UI update
    runningNotifier.setOptimistic(targetState);

    try {
      if (previousState) {
        await StepForegroundService.stop().timeout(const Duration(seconds: 5));
      } else {
        await StepForegroundService.start().timeout(const Duration(seconds: 5));
      }
      // Re-verify real state
      await runningNotifier.resync();
    } catch (e) {
      // Rollback on failure
      runningNotifier.setOptimistic(previousState);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.stepToggleError),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSwitching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final live = ref.watch(liveStepsProvider).valueOrNull;
    // P51: always read today's count from the shared stream (same as Walk tab).
    final stepsCurrent = ref.watch(todayStepsProvider);
    final isRunning = ref.watch(isStepCounterRunningProvider);
    if (isRunning && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!isRunning && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
    final permissionGranted = live?.permissionGranted ?? true;
    final healthConnectDenied = live?.healthConnectDenied ?? false;
    final usingPedometerFallback =
        healthConnectDenied && (live?.sensorAvailable ?? false);

    if (!permissionGranted && stepsCurrent == 0) {
      return Container(
        padding: const EdgeInsets.all(VSpace.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(color: colors.line.withValues(alpha: 0.6)),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: PremiumStepsHeroCard.stepsAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_walk_rounded, color: PremiumStepsHeroCard.stepsAccent, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.stepsHeroTitle,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.stepsPermissionTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMute, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: PremiumStepsHeroCard.stepsAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VRadius.pill)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                HapticFeedback.selectionClick();
                final enable = ref.read(enableStepCountingProvider);
                await enable();
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: Text(
                l10n.stepsEnableButton,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

    final profile = WalkingCalculations.readProfileMetrics();
    final metrics = WalkingCalculations.compute(
      steps: stepsCurrent,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      isFemale: profile.isFemale,
    );
    final effectiveGoal = widget.stepsGoal > 0 ? widget.stepsGoal : 7000;
    final ratio = (stepsCurrent / effectiveGoal).clamp(0.0, 1.0);
    final last7 = (live?.last7Days != null && live!.last7Days.isNotEmpty)
        ? live.last7Days
        : StepCounterService.last7DaysFromHistory(todaySteps: stepsCurrent);

    // Compute weekly daily average
    final totalSteps7 = last7.fold<int>(0, (s, d) => s + d.steps);
    final dailyAvg = last7.isNotEmpty ? (totalSteps7 / last7.length).round() : stepsCurrent;

    // Active minutes calculation: 100 steps ≈ 1 active minute
    final activeMinutes = metrics.activeMinutes > 0
        ? metrics.activeMinutes
        : (stepsCurrent / 100.0).round();

    final stage = widget.overrideStage != null
        ? JourneyStage.fromSteps(widget.overrideStage! * 1000)
        : JourneyStage.fromSteps(stepsCurrent);
    final variant = ref.watch(appThemeVariantProvider);
    final rampColor = stage.ringAccent(variant);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LivingStepsBackground(
          stepsCurrent: stepsCurrent,
          stepsGoal: effectiveGoal,
          overrideStage: widget.overrideStage,
          borderRadius: 20,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (usingPedometerFallback) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      Localizations.localeOf(context).languageCode.startsWith('ar')
                          ? 'من غير الإذن هنستخدم عداد الموبايل بس'
                          : 'Without Health Connect permission we\'ll use the phone pedometer only',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                // Row 1: Big steps number, goal, Distinctive Play/Pause button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Distinctive Play / Pause Circle Button with Label
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: _handleToggle,
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final pulseAlpha = isRunning ? 0.25 + (_pulseController.value * 0.35) : 0.0;
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isRunning
                                  ? PremiumStepsHeroCard.stepsAccent
                                  : const Color(0xFF1E293B),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isRunning
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : Colors.white30,
                                width: isRunning ? 2.2 : 1.5,
                              ),
                              boxShadow: isRunning
                                  ? [
                                      BoxShadow(
                                        color: PremiumStepsHeroCard.stepsAccent.withValues(alpha: pulseAlpha),
                                        blurRadius: 14 + (_pulseController.value * 6),
                                        spreadRadius: 2 + (_pulseController.value * 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: _isSwitching
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      color: isRunning ? const Color(0xFF064E3B) : Colors.white,
                                      size: 32,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isRunning ? 'شغّال' : 'ابدأ',
                      style: TextStyle(
                        color: isRunning ? PremiumStepsHeroCard.stepsAccent : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                // Center / Right: Big step number + goal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit, size: 16, color: Colors.white54),
                            const SizedBox(width: 6),
                            Text(
                              NumberFormat.decimalPattern().format(stepsCurrent),
                              style: const TextStyle(
                                fontSize: 55,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1.2,
                                height: 1.0,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                            if (stage.hasStarBadge) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 30),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '/$effectiveGoal خطوة',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Row 2: Thick progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 18,
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: const Color(0xFF2C3E55),
                  valueColor: AlwaysStoppedAnimation<Color>(rampColor),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Row 3: 3 Stats Columns (كم, سعرات, الوقت)
            Row(
              children: [
                // Distance
                Expanded(
                  child: _LeapStatColumn(
                    icon: Icons.track_changes_rounded,
                    iconColor: const Color(0xFFFBBF24), // Yellow
                    value: metrics.distanceKm.toStringAsFixed(2),
                    label: 'كم',
                  ),
                ),
                // Calories
                Expanded(
                  child: _LeapStatColumn(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: const Color(0xFFF97316), // Orange
                    value: '${metrics.caloriesKcal}',
                    label: 'السعرات',
                  ),
                ),
                // Time (Active Minutes)
                Expanded(
                  child: _LeapStatColumn(
                    icon: Icons.access_time_filled_rounded,
                    iconColor: const Color(0xFF38BDF8), // Cyan
                    value: '${(activeMinutes ~/ 60)}س ${(activeMinutes % 60)}د',
                    label: 'الوقت',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 16),

            // Row 4: Daily average & 7-day circular row
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                'المتوسط اليومي: $dailyAvg',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 7 Days Circles with Star when goal hit + progress ring + Arabic initials
            _Leap7DayRow(
              days: last7,
              goal: effectiveGoal,
              accent: rampColor,
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}

class _LeapStatColumn extends StatelessWidget {
  const _LeapStatColumn({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Leap7DayRow extends StatelessWidget {
  const _Leap7DayRow({
    required this.days,
    required this.goal,
    required this.accent,
  });

  final List<DailyStepCount> days;
  final int goal;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // Generate 7 days ending today
    final list = days.isNotEmpty ? days : _generateFallbackDays();
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < list.length && i < 7; i++)
          _DayCircleItem(
            day: list[i],
            goal: goal,
            accent: accent,
            isArabic: isArabic,
          ),
      ],
    );
  }

  static List<DailyStepCount> _generateFallbackDays() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DailyStepCount(date: d, steps: 0);
    });
  }
}

class _DayCircleItem extends StatelessWidget {
  const _DayCircleItem({
    required this.day,
    required this.goal,
    required this.accent,
    required this.isArabic,
  });

  final DailyStepCount day;
  final int goal;
  final Color accent;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final reached = goal > 0 && day.steps >= goal;
    final progress = goal > 0 ? (day.steps / goal).clamp(0.0, 1.0) : 0.0;
    final initial = _dayInitial(day.date, isArabic);

    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Ring around circle
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 3.0,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  reached ? accent : accent.withValues(alpha: 0.7),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached ? accent : const Color(0xFF223048),
                ),
                alignment: Alignment.center,
                child: reached
                    ? const Icon(Icons.star_rounded, color: Colors.white, size: 20)
                    : (progress > 0.1
                        ? Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          initial,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _dayInitial(DateTime dt, bool arabic) {
    if (arabic) {
      // Arabic weekday initials: السبت س، الأحد ح، الإثنين ن، الثلاثاء ث، الأربعاء ر، الخميس خ، الجمعة ج
      // dt.weekday: 1=Mon(ن), 2=Tue(ث), 3=Wed(ر), 4=Thu(خ), 5=Fri(ج), 6=Sat(س), 7=Sun(ح)
      const arInitials = {
        DateTime.monday: 'ن',
        DateTime.tuesday: 'ث',
        DateTime.wednesday: 'ر',
        DateTime.thursday: 'خ',
        DateTime.friday: 'ج',
        DateTime.saturday: 'س',
        DateTime.sunday: 'ح',
      };
      return arInitials[dt.weekday] ?? 'ي';
    }
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[(dt.weekday - 1) % 7];
  }
}
