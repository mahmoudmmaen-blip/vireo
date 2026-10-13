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
import 'package:vireo/features/activity/screens/activity_hub_screen.dart';
import 'package:vireo/features/breathing/screens/breathing_hub_screen.dart';
import 'package:vireo/features/home/domain/today_plan_item.dart';
import 'package:vireo/features/home/providers/today_plan_checks_provider.dart';
import 'package:vireo/features/home/providers/today_plan_provider.dart';
import 'package:vireo/features/home/widgets/sleep_log_sheet.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/core/widgets/rewarded_unlock_sheet.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/engagement/domain/daily_coin_task.dart';
import 'package:vireo/features/engagement/providers/coins_provider.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';

class TodayPlanSection extends ConsumerStatefulWidget {
  const TodayPlanSection({super.key});

  @override
  ConsumerState<TodayPlanSection> createState() => _TodayPlanSectionState();
}

class _TodayPlanSectionState extends ConsumerState<TodayPlanSection>
    with SingleTickerProviderStateMixin {
  bool _celebrated = false;
  bool _isExpanded = false;
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
          builder: (context, child) => CustomPaint(
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
    if (item.isPro && !ref.read(isProUserProvider)) {
      if (item.kind == TodayPlanKind.protocolPro || item.kind == TodayPlanKind.aiSuggestionPro) {
        if (!FeatureGates.isVitalityRewardedUnlocked()) {
          final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
          await showRewardedUnlockSheet(
            context: context,
            featureTitle: isArabic ? 'فتح مهمة البروتوكول لليوم' : 'Unlock Today\'s Pro Task',
            featureDescription: isArabic
                ? 'شاهد إعلان قصير لفتح بند بروتوكول العافية المتقدم لليوم، أو اشترك في Pro للوصول الشامل.'
                : 'Watch a short ad to unlock today\'s vitality protocol task, or subscribe to Pro.',
            onUnlockGranted: () async {
              await FeatureGates.grantRewardedVitalityItem();
              setState(() {});
            },
          );
          return;
        }
      } else {
        if (!requirePremiumAccess(context, ref)) return;
      }
    }

    switch (item.kind) {
      case TodayPlanKind.meal:
        final type = item.mealType;
        if (type != null) {
          ref.read(shellTabIndexProvider.notifier).goNutrition(mealTab: type);
        } else {
          ref.read(shellTabIndexProvider.notifier).goNutrition();
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
        await ref.read(vitalityDailyLogProvider.notifier).toggleSunlightDone(!complete);
        return;
      case TodayPlanKind.vitalityBreathing:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const BreathingHubScreen()),
        );
        return;
      case TodayPlanKind.vitalityZinc:
        await ref.read(vitalityDailyLogProvider.notifier).toggleZincVitDDone(!complete);
        return;
      case TodayPlanKind.vitalitySleep:
      case TodayPlanKind.sleepBedtime:
        await showSleepLogSheet(context, ref);
        return;
      case TodayPlanKind.protocolPro:
      case TodayPlanKind.aiSuggestionPro:
        await ref.read(todayPlanChecksProvider.notifier).toggle(item.id, value: !complete);
        return;
      case TodayPlanKind.fastingOpen:
      case TodayPlanKind.fastingClose:
        await ref
            .read(todayPlanChecksProvider.notifier)
            .toggle(item.id, value: !complete);
        return;
      case TodayPlanKind.vitalityProtein:
        ref.read(shellTabIndexProvider.notifier).goNutrition();
        return;
    }
  }

  Future<void> _onCheck(TodayPlanItem item, bool complete) async {
    if (item.isPro && !complete && !ref.read(isProUserProvider)) {
      if (item.kind == TodayPlanKind.protocolPro || item.kind == TodayPlanKind.aiSuggestionPro) {
        if (!FeatureGates.isVitalityRewardedUnlocked()) {
          final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
          await showRewardedUnlockSheet(
            context: context,
            featureTitle: isArabic ? 'فتح مهمة البروتوكول لليوم' : 'Unlock Today\'s Pro Task',
            featureDescription: isArabic
                ? 'شاهد إعلان قصير لفتح بند بروتوكول العافية المتقدم لليوم، أو اشترك في Pro للوصول الشامل.'
                : 'Watch a short ad to unlock today\'s vitality protocol task, or subscribe to Pro.',
            onUnlockGranted: () async {
              await FeatureGates.grantRewardedVitalityItem();
              setState(() {});
            },
          );
          return;
        }
      } else {
        if (!requirePremiumAccess(context, ref)) return;
      }
    }

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

    if (item.kind == TodayPlanKind.vitalitySun) {
      await ref.read(vitalityDailyLogProvider.notifier).toggleSunlightDone(!complete);
      HapticFeedback.selectionClick();
      return;
    }

    if (item.kind == TodayPlanKind.vitalityZinc) {
      await ref.read(vitalityDailyLogProvider.notifier).toggleZincVitDDone(!complete);
      HapticFeedback.selectionClick();
      return;
    }

    if (item.kind == TodayPlanKind.vitalitySleep || item.kind == TodayPlanKind.sleepBedtime) {
      await showSleepLogSheet(context, ref);
      return;
    }

    if (!complete) {
      final coinTask = switch (item.kind) {
        TodayPlanKind.meal => DailyCoinTask.meal,
        TodayPlanKind.workout => DailyCoinTask.workout,
        TodayPlanKind.steps => DailyCoinTask.walk,
        TodayPlanKind.waterReminder => DailyCoinTask.water,
        _ => DailyCoinTask.moodCheck,
      };
      await ref.read(coinsBalanceProvider.notifier).awardTask(coinTask);
    }

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
                  locale.startsWith('ar') ? 'رحلة اليوم' : 'Daily Journey',
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

        // ── Single Water Card with Ring & Quick Add ──
        if (plan.waterItem != null) ...[
          _WaterHighlightCard(
            item: plan.waterItem!,
            onTap: () => _onTapItem(plan.waterItem!, plan.isComplete(plan.waterItem!.id)),
            onQuickAdd: () async {
              HapticFeedback.selectionClick();
              await ref.read(waterTrackerProvider.notifier).addGlass();
            },
          ),
          const SizedBox(height: VSpace.sm),
        ],

        // ── Plan Items (Progressive Disclosure: Next 3 items collapsed, expandable on tap) ──
        Builder(
          builder: (context) {
            final allItems = plan.items;
            final displayedItems = _isExpanded ? allItems : allItems.take(3).toList();
            final isArabic = locale.startsWith('ar');

            return VireoCard(
              padding: const EdgeInsets.symmetric(vertical: VSpace.sm, horizontal: VSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < displayedItems.length; i++)
                    _PlanRow(
                      item: displayedItems[i],
                      isNow: displayedItems[i].id == plan.nowItemId,
                      complete: plan.isComplete(displayedItems[i].id),
                      timeLabel: _formatTime(displayedItems[i].minutesOfDay),
                      nowLabel: l10n.todayPlanNow,
                      proLabel: l10n.todayPlanPro,
                      onTap: () => _onTapItem(
                        displayedItems[i],
                        plan.isComplete(displayedItems[i].id),
                      ),
                      onCheck: () => _onCheck(
                        displayedItems[i],
                        plan.isComplete(displayedItems[i].id),
                      ),
                    ),
                  if (allItems.length > 3) ...[
                    const Divider(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() => _isExpanded = !_isExpanded);
                      },
                      icon: Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _isExpanded
                            ? (isArabic ? 'إخفاء التفاصيل' : 'Show less')
                            : (isArabic ? 'عرض الكل (${allItems.length - 3} مهام إضافية)' : 'Show all (${allItems.length - 3} more)'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
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

class _WaterHighlightCard extends StatelessWidget {
  const _WaterHighlightCard({
    required this.item,
    required this.onTap,
    required this.onQuickAdd,
  });

  final TodayPlanItem item;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final ratio = item.progress ?? 0.0;

    return VireoCard(
      padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.sm + 2),
      onTap: onTap,
      child: Row(
        children: [
          RingProgress(
            progress: ratio,
            size: 40,
            stroke: 4.5,
            color: VMacro.water,
            child: Icon(Icons.water_drop_rounded, size: 18, color: VMacro.water),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (item.progressLabel != null)
                  Text(
                    item.progressLabel!,
                    style: TextStyle(
                      color: colors.textMute,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: VMacro.water.withValues(alpha: 0.12),
              foregroundColor: VMacro.water,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(VRadius.pill),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 32),
            ),
            onPressed: onQuickAdd,
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              item.quickActionLabel ?? '+250 ml',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}


class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.item,
    required this.isNow,
    required this.complete,
    required this.timeLabel,
    required this.nowLabel,
    required this.proLabel,
    required this.onTap,
    required this.onCheck,
  });

  final TodayPlanItem item;
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

    return Pressable(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (item.stepNumber != null) ...[
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: complete ? colors.success.withValues(alpha: 0.15) : colors.surfaceRaised,
                  shape: BoxShape.circle,
                  border: Border.all(color: complete ? colors.success : colors.line),
                ),
                child: Text(
                  '${item.stepNumber}',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: complete ? colors.success : colors.textMute,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: complete
                    ? colors.success.withValues(alpha: 0.12)
                    : (highlight
                        ? colors.ember.withValues(alpha: 0.15)
                        : colors.surfaceRaised),
                shape: BoxShape.circle,
                border: Border.all(
                  color: complete
                      ? colors.success
                      : (highlight ? colors.ember : colors.line),
                ),
              ),
              child: Icon(
                item.icon,
                size: 17,
                color: complete
                    ? colors.success
                    : (highlight ? colors.ember : colors.text),
              ),
            ),
            const SizedBox(width: 12),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (highlight) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: colors.ember,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            nowLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (item.isPro) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
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
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: complete ? colors.textMute : colors.text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      decoration: complete ? TextDecoration.lineThrough : null,
                    ),
                    child: Text(item.title),
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textMute,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(right: 2, left: 2),
              decoration: BoxDecoration(
                color: colors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded, size: 12, color: colors.gold),
                  const SizedBox(width: 2),
                  Text(
                    '+${item.points}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: colors.gold,
                    ),
                  ),
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
