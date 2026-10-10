import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/home/domain/today_plan_item.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/home/providers/today_plan_checks_provider.dart';
import 'package:vireo/features/home/providers/today_plan_provider.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/activity/screens/activity_hub_screen.dart';
import 'package:vireo/features/breathing/screens/breathing_hub_screen.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';

class TodayPlanSection extends ConsumerStatefulWidget {
  const TodayPlanSection({super.key});

  @override
  ConsumerState<TodayPlanSection> createState() => _TodayPlanSectionState();
}

class _TodayPlanSectionState extends ConsumerState<TodayPlanSection>
    with SingleTickerProviderStateMixin {
  bool _celebrated = false;
  OverlayEntry? _confettiEntry;
  late AnimationController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
  }

  @override
  void dispose() {
    _confettiEntry?.remove();
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _maybeCelebrate(TodayPlanSnapshot plan) {
    if (_celebrated || plan.totalCount == 0) return;
    if (plan.completedCount < plan.totalCount) return;
    _celebrated = true;
    HapticFeedback.heavyImpact();
    _showConfetti();
  }

  void _showConfetti() {
    _confettiEntry?.remove();
    _confettiCtrl.reset();
    final overlay = Overlay.of(context);
    _confettiEntry = OverlayEntry(
      builder: (ctx) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _confettiCtrl,
          builder: (_, __) => CustomPaint(
            painter: _ConfettiPainter(_confettiCtrl.value),
            size: MediaQuery.sizeOf(ctx),
          ),
        ),
      ),
    );
    overlay.insert(_confettiEntry!);
    _confettiCtrl.forward().whenComplete(() {
      _confettiEntry?.remove();
      _confettiEntry = null;
    });
  }

  Future<void> _onTapItem(TodayPlanItem item, bool complete) async {
    if (item.isPro && !requirePremiumAccess(context, ref)) return;

    switch (item.kind) {
      case TodayPlanKind.meal:
        final type = item.mealType;
        if (type != null) {
          ref.read(shellTabIndexProvider.notifier).goNutrition(mealTab: type);
        }
        return;
      case TodayPlanKind.workout:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const WorkoutFlowScreen()),
        );
        return;
      case TodayPlanKind.steps:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ActivityHubScreen()),
        );
        return;
      case TodayPlanKind.waterReminder:
        await ref.read(waterTrackerProvider.notifier).addGlass();
        return;
      case TodayPlanKind.vitalitySun:
        await ref.read(vitalityDailyLogProvider.notifier).toggleSunlightDone(true);
        return;
      case TodayPlanKind.vitalityBreathing:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const BreathingHubScreen()),
        );
        return;
      case TodayPlanKind.vitalityZinc:
        await ref.read(vitalityDailyLogProvider.notifier).toggleZincVitDDone(true);
        return;
      case TodayPlanKind.protocolPro:
      case TodayPlanKind.aiSuggestionPro:
        if (!complete) {
          await ref.read(todayPlanChecksProvider.notifier).toggle(item.id, value: true);
        }
        return;
      case TodayPlanKind.fastingOpen:
      case TodayPlanKind.fastingClose:
      case TodayPlanKind.sleepBedtime:
        await ref
            .read(todayPlanChecksProvider.notifier)
            .toggle(item.id, value: !complete);
        return;
      case TodayPlanKind.vitalitySleep:
      case TodayPlanKind.vitalityProtein:
        ref.read(shellTabIndexProvider.notifier).goNutrition();
        return;
    }
  }

  Future<void> _onCheck(TodayPlanItem item, bool complete) async {
    if (item.isPro && !complete && !requirePremiumAccess(context, ref)) return;

    if (item.kind == TodayPlanKind.meal && item.mealType != null) {
      final type = item.mealType!;
      if (!complete) {
        ref.read(confirmedMealsProvider.notifier).update((s) => {...s, type});
      } else {
        ref.read(confirmedMealsProvider.notifier).update((s) {
          final next = {...s};
          next.remove(type);
          return next;
        });
      }
      HapticFeedback.selectionClick();
      return;
    }

    if (item.autoComplete) return;

    await ref
        .read(todayPlanChecksProvider.notifier)
        .toggle(item.id, value: !complete);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final colors = context.vireoColors;
    final buildPlan = ref.watch(todayPlanProvider);
    final plan = buildPlan(l10n, locale);
    if (plan.completedCount < plan.totalCount) {
      _celebrated = false;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _maybeCelebrate(plan);
      });
    }

    final pct = (plan.progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, VSpace.sm, 4, VSpace.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.todayPlanTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              RingProgress(
                progress: plan.progress,
                size: 44,
                stroke: 5,
                color: colors.ember,
                child: Text(
                  '$pct%',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, VSpace.sm),
          child: Text(
            l10n.todayPlanProgressSummary(pct, plan.completedCount, plan.totalCount),
            style: TextStyle(color: colors.textMute, fontSize: 13),
          ),
        ),
        VireoCard(
          padding: const EdgeInsets.symmetric(vertical: VSpace.sm, horizontal: VSpace.md),
          child: Column(
            children: [
              for (var i = 0; i < plan.items.length; i++)
                _TimelineRow(
                  item: plan.items[i],
                  isFirst: i == 0,
                  isLast: i == plan.items.length - 1,
                  isNow: plan.items[i].id == plan.nowItemId,
                  complete: plan.isComplete(plan.items[i].id),
                  timeLabel: _formatTime(plan.items[i].minutesOfDay),
                  nowLabel: l10n.todayPlanNow,
                  proLabel: l10n.todayPlanPro,
                  onTap: () => _onTapItem(
                    plan.items[i],
                    plan.isComplete(plan.items[i].id),
                  ),
                  onCheck: () => _onCheck(
                    plan.items[i],
                    plan.isComplete(plan.items[i].id),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(int minutesOfDay) {
    final h = minutesOfDay ~/ 60;
    final m = minutesOfDay % 60;
    final dt = DateTime(2020, 1, 1, h, m);
    return DateFormat.jm().format(dt);
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.isNow,
    required this.complete,
    required this.timeLabel,
    required this.nowLabel,
    required this.proLabel,
    required this.onTap,
    required this.onCheck,
  });

  final TodayPlanItem item;
  final bool isFirst;
  final bool isLast;
  final bool isNow;
  final bool complete;
  final String timeLabel;
  final String nowLabel;
  final String proLabel;
  final VoidCallback onTap;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final highlight = isNow && !complete;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(width: 2, color: colors.line),
                  ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: highlight
                        ? colors.ember.withValues(alpha: 0.15)
                        : colors.surfaceRaised,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: highlight ? colors.ember : colors.line,
                    ),
                  ),
                  child: Icon(item.icon, size: 18, color: colors.text),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: colors.line),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Pressable(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(bottom: VSpace.sm, top: 2),
                child: Container(
                  padding: const EdgeInsets.all(VSpace.sm),
                  decoration: BoxDecoration(
                    color: highlight
                        ? colors.ember.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(VRadius.md),
                    border: highlight
                        ? Border.all(color: colors.ember.withValues(alpha: 0.35))
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  timeLabel,
                                  style: TextStyle(
                                    color: colors.textMute,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (highlight) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.ember,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      nowLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                if (item.isPro) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.gold.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      proLabel,
                                      style: TextStyle(
                                        color: colors.gold,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            if (item.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: TextStyle(
                                  color: colors.textMute,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: onCheck,
                        icon: Icon(
                          complete
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: complete ? colors.success : colors.textMute,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);
  final double progress;

  static final _rand = math.Random(7);
  static final _particles = List.generate(48, (_) {
    return (
      x: _rand.nextDouble(),
      y: _rand.nextDouble(),
      color: Color.fromARGB(
        255,
        200 + _rand.nextInt(55),
        80 + _rand.nextInt(120),
        _rand.nextInt(80),
      ),
      speed: 0.4 + _rand.nextDouble() * 0.8,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in _particles) {
      final dy = (p.y + progress * p.speed) % 1.0;
      paint.color = p.color.withValues(alpha: (1 - progress).clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(p.x * size.width, dy * size.height),
        4 + progress * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
