import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';
import 'package:vireo/core/widgets/language_picker_screen.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/ai_coach/screens/ai_coach_screen.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_quick_relog_row.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/cardio/screens/cardio_activity_screen.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/diet_programs/data/diet_plan_storage.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/diet_programs/screens/diet_programs_screen.dart';
import 'package:vireo/features/diet_programs/screens/diet_quiz_screen.dart';
import 'package:vireo/features/diet_programs/widgets/fasting_window_card.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/home/widgets/recovery_breakdown_sheet.dart';
import 'package:vireo/features/progress/providers/weekly_checkin_provider.dart';
import 'package:vireo/features/progress/screens/weekly_checkin_screen.dart';
import 'package:vireo/features/walking/walking_tracker_screen.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/activity/screens/health_hub_screen.dart';
import 'package:vireo/features/home/widgets/steps_hero_card.dart';
import 'package:vireo/features/home/widgets/today_plan_section.dart';
import 'package:vireo/features/auth/services/save_progress_prompt.dart';

const _headerPad = EdgeInsets.fromLTRB(4, VSpace.sm, 4, 0);

class HomeDashboardBody extends ConsumerWidget {
  const HomeDashboardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final auth = ref.watch(authProvider).valueOrNull;
    final isGuest = auth?.isGuest == true;
    final dash = ref.watch(homeDashboardProvider);
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final weeklyDue = ref.watch(weeklyCheckInDueProvider);
    final activeDiet = ref.watch(activeDietProgramProvider);
    final fasting = ref.watch(fastingWindowStatusProvider);

    void push(Widget screen) => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => screen),
        );

    final sections = <Widget>[
      _HomeHeader(
        name: homeDisplayName(l10n, dash, isGuest),
        streakDays: dash.streakDays,
        subtitle: dash.hasProgram
            ? l10n.homeProgramDay(dash.programDay, dash.programTotalDays)
            : l10n.homeDayPhase(dash.programDay, homePhaseName(l10n, dash, locale)),
      ),
      const SaveProgressPromptHost(),
      VireoCard(
        onTap: () => AiScanScreen.open(context, ref, fromCamera: true),
        padding: const EdgeInsets.symmetric(vertical: VSpace.md, horizontal: VSpace.md),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.vireoColors.ember.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.camera_alt_rounded, color: context.vireoColors.ember),
            ),
            const SizedBox(width: VSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mealScanHeroTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    l10n.mealScanHeroSubtitle,
                    style: TextStyle(
                      color: context.vireoColors.textMute,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.vireoColors.textMute),
          ],
        ),
      ),
      TodayHeroCard(
        data: nutrition,
        onTap: () => ref.read(shellTabIndexProvider.notifier).goNutrition(),
        onBurnedTap: () => push(const CardioActivityScreen()),
      ),
      StepsHeroCard(
        stepsCurrent: dash.stepsToday,
        stepsGoal: dash.stepsGoal,
        onTap: () => push(const WalkingTrackerScreen()),
      ),
      const TodayPlanSection(),
      _QuickActions(
        onWater: () => _addWater(context, ref),
        onWorkout: () => ref.read(shellTabIndexProvider.notifier).goWorkout(),
        onCoach: () => push(const AiCoachScreen()),
      ),
      const MealQuickRelogRow(),
      if (activeDiet == null)
        ChooseDietPlanCard(
          onTap: () {
            final screened = HiveService.isInitialized &&
                HiveService.settingsBox.containsKey(
                  DietPlanStorage.preferencesKey,
                );
            push(
              screened
                  ? const DietProgramsScreen()
                  : const DietQuizScreen(),
            );
          },
        ),
      if (fasting != null) const FastingWindowCard(),
      VireoCard(
        onTap: () => push(const HealthHubScreen()),
        padding: const EdgeInsets.all(VSpace.sm + 2),
        child: Row(
          children: [
            Icon(Icons.monitor_heart_outlined, color: context.vireoColors.ember),
            const SizedBox(width: VSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.activityHealthHomeCardTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    l10n.activityHealthHomeCardSubtitle,
                    style: TextStyle(
                      color: context.vireoColors.textMute,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.vireoColors.textMute),
          ],
        ),
      ),
      if (dash.showCheckIn || weeklyDue)
        _CheckInBanner(onTap: () => push(const WeeklyCheckInScreen())),
      SectionHeader(title: l10n.uxSectionThisWeek, padding: _headerPad),
      _WeekStrip(completedDays: dash.weeklyCompletedDays),
      _RecoveryCard(
        score: dash.recoveryScore,
        onInfo: () => showRecoveryBreakdownSheet(context, dash.recovery),
      ),
      SectionHeader(
        title: l10n.uxSectionTodayLog,
        padding: _headerPad,
      ),
      _TodayLog(
        items: nutrition.items,
        onScan: () => AiScanScreen.open(context, ref, fromCamera: true),
        onRemoveAi: (id) {
          ref.read(aiMealLogProvider.notifier).remove(id);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 3),
                persist: false,
                content: Text(l10n.uxMealRemoved),
              ),
            );
        },
      ),
    ];

    return NoScrollbarScrollConfiguration(
      child: RefreshIndicator(
        color: context.vireoColors.ember,
        onRefresh: () async {
          HapticFeedback.lightImpact();
          ref.invalidate(todayWorkoutProvider);
          ref.invalidate(todayMealsProvider);
          await Future<void>.delayed(const Duration(milliseconds: 450));
        },
        child: ListView.builder(
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            VSpace.md,
            VSpace.xs,
            VSpace.md,
            VSpace.xxl,
          ),
          itemCount: sections.length,
          itemBuilder: (context, i) => FadeSlideIn(
            index: i,
            onceId: 'home_$i',
            child: Padding(
              padding: const EdgeInsets.only(bottom: VSpace.sm),
              child: sections[i],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _addWater(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final added = await ref.read(waterTrackerProvider.notifier).addGlass();
  if (!context.mounted) return;
  final ml = ref.read(waterTrackerProvider);
  // Brief confirmation only — undo lives on the Water card.
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        persist: false,
        duration: const Duration(seconds: 3),
        content: Text(
          added
              ? l10n.uxWaterAdded((ml / 1000).toStringAsFixed(2))
              : l10n.uxWaterGoalDone,
        ),
      ),
    );
}

// ───────────────────────────── Header ─────────────────────────────

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader({
    required this.name,
    required this.streakDays,
    required this.subtitle,
  });

  final String name;
  final int streakDays;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final localeCode = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final date = DateFormat.MMMMEEEEd(localeCode).format(now);
    final hour = now.hour;
    final greeting = hour < 12
        ? l10n.uxGoodMorning(name)
        : hour < 18
            ? l10n.uxGoodAfternoon(name)
            : l10n.uxGoodEvening(name);
    final initial = name.trim().isEmpty ? 'V' : name.trim().characters.first.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, VSpace.xs, 0, VSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: VType.overline(context)),
                const SizedBox(height: 4),
                Text(
                  greeting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.textMute, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: VSpace.xs),
          Tooltip(
            message: l10n.homeStreakDays(streakDays),
            child: VireoPill(
              icon: Icons.local_fire_department_rounded,
              label: '$streakDays',
              color: colors.ember,
            ),
          ),
          const SizedBox(width: 6),
          _CircleIconButton(
            icon: Icons.translate_rounded,
            tooltip: ref.watch(activeAppLanguageProvider).languageLabel,
            onTap: () => Navigator.of(context).push(
              LanguagePickerScreen.route(isInitial: false),
            ),
          ),
          const SizedBox(width: 6),
          Tooltip(
            message: l10n.profileTitle,
            child: Pressable(
              onTap: () => ref.read(shellTabIndexProvider.notifier).goProfile(),
              semanticLabel: l10n.profileTitle,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.ember, width: 2),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.ember.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        initial,
                        style: TextStyle(
                          color: colors.ember,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors.ember,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.background, width: 1.5),
                        ),
                        child: const Icon(Icons.person, size: 9, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Tooltip(
      message: tooltip,
      child: Pressable(
        onTap: onTap,
        semanticLabel: tooltip,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface,
            border: Border.all(color: colors.line),
          ),
          child: Icon(icon, size: 19, color: colors.text),
        ),
      ),
    );
  }
}

// ───────────────────────────── Today hero ─────────────────────────────

class TodayHeroCard extends StatelessWidget {
  const TodayHeroCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.onBurnedTap,
  });

  final TodayNutrition data;
  final VoidCallback onTap;
  final VoidCallback onBurnedTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final over = data.isOver;
    final ringColor = over ? colors.danger : colors.ember;

    return VireoCard(
      onTap: onTap,
      semanticLabel: l10n.uxCaloriesLeft,
      glow: colors.ember,
      padding: const EdgeInsets.fromLTRB(VSpace.md, VSpace.md, VSpace.md, VSpace.sm),
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [
          Color.alphaBlend(colors.ember.withValues(alpha: 0.10), colors.surface),
          colors.surface,
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(l10n.uxTodayOverline, style: VType.overline(context)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: colors.textMute, size: 20),
            ],
          ),
          const SizedBox(height: VSpace.sm),
          Row(
            children: [
              RingProgress(
                progress: data.progress,
                size: 142,
                stroke: 13,
                color: ringColor,
                secondaryColor: over ? ringColor : colors.gold,
                trackColor: colors.line.withValues(alpha: 0.55),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedCount(
                      value: data.remainingKcal.abs(),
                      style: VType.number(size: 30, weight: FontWeight.w800, color: colors.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      over ? l10n.uxCaloriesOver : l10n.uxCaloriesLeft,
                      style: TextStyle(
                        color: over ? colors.danger : colors.textMute,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: VSpace.lg),
              Expanded(
                child: Column(
                  children: [
                    MacroBar(
                      label: l10n.uxProtein,
                      value: data.proteinG,
                      target: data.proteinTarget.toDouble(),
                      color: VMacro.protein,
                    ),
                    const SizedBox(height: VSpace.sm),
                    MacroBar(
                      label: l10n.uxCarbs,
                      value: data.carbsG,
                      target: data.carbsTarget.toDouble(),
                      color: VMacro.carbs,
                    ),
                    const SizedBox(height: VSpace.sm),
                    MacroBar(
                      label: l10n.uxFat,
                      value: data.fatG,
                      target: data.fatTarget.toDouble(),
                      color: VMacro.fat,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: VSpace.md),
          Container(
            padding: const EdgeInsets.symmetric(vertical: VSpace.xs),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(VRadius.sm),
            ),
            child: Row(
              children: [
                _HeroStat(
                  icon: Icons.flag_rounded,
                  label: l10n.uxGoal,
                  value: data.goalKcal,
                  color: colors.textMute,
                ),
                _HeroStat(
                  icon: Icons.restaurant_rounded,
                  label: l10n.uxEaten,
                  value: data.eatenKcal,
                  color: colors.ember,
                ),
                _HeroStat(
                  icon: Icons.local_fire_department_rounded,
                  label: l10n.uxBurned,
                  value: data.burnedKcal,
                  color: VMacro.steps,
                  onTap: onBurnedTap,
                ),
              ],
            ),
          ),
          if (data.remainingKcal > 0 && FatEquivalent.hasEquivalent(data.remainingKcal)) ...[
            const SizedBox(height: VSpace.xs + 2),
            Center(
              child: FatEquivalentBadge(
                kcal: data.remainingKcal,
                customText: l10n.fatEquivalentTodayDeficit(
                  FatEquivalent.formatAmount(
                    FatEquivalent.gramsFromKcal(data.remainingKcal),
                    languageCode: Localizations.localeOf(context).languageCode,
                  ),
                ),
                style: TextStyle(
                  color: colors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ] else if (data.remainingKcal < 0) ...[
            const SizedBox(height: VSpace.xs + 2),
            Center(
              child: Text(
                l10n.fatEquivalentTodaySurplus(data.remainingKcal.abs()),
                style: TextStyle(
                  color: colors.textMute,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final content = Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: colors.textMute, fontSize: 11.5)),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedCount(
          value: value,
          style: VType.number(size: 16, color: colors.text),
        ),
      ],
    );
    return Expanded(
      child: onTap == null ? content : Pressable(onTap: onTap, child: content),
    );
  }
}

// ───────────────────────────── Quick actions ─────────────────────────────

class _QuickActions extends ConsumerWidget {
  const _QuickActions({
    required this.onWater,
    required this.onWorkout,
    required this.onCoach,
  });

  final VoidCallback onWater;
  final VoidCallback onWorkout;
  final VoidCallback onCoach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final waterMl = ref.watch(waterTrackerProvider);

    return Row(
      children: [
        _QuickAction(
          icon: Icons.water_drop_rounded,
          label: '${(waterMl / 1000).toStringAsFixed(1)}L',
          color: VMacro.water,
          onTap: onWater,
          badge: Icons.add_rounded,
          highlighted: true,
        ),
        _QuickAction(
          icon: Icons.fitness_center_rounded,
          label: l10n.uxActionTrain,
          color: VMacro.steps,
          onTap: onWorkout,
        ),
        _QuickAction(
          icon: Icons.auto_awesome_rounded,
          label: l10n.uxActionCoach,
          color: VMacro.ai,
          onTap: onCoach,
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.highlighted = false,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool highlighted;
  final IconData? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Expanded(
      child: Pressable(
        onTap: onTap,
        semanticLabel: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: VSpace.xs),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(VRadius.md),
                      color: highlighted ? null : color.withValues(alpha: 0.14),
                      gradient: highlighted
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color.lerp(color, Colors.white, 0.15)!, color],
                            )
                          : null,
                      border: highlighted
                          ? null
                          : Border.all(color: color.withValues(alpha: 0.25)),
                      boxShadow: highlighted
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 16,
                                spreadRadius: -4,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      icon,
                      color: highlighted ? Colors.white : color,
                      size: 26,
                    ),
                  ),
                  if (badge != null)
                    PositionedDirectional(
                      end: -4,
                      top: -4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.background, width: 2),
                        ),
                        child: Icon(badge, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ───────────────────────────── Week ─────────────────────────────

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.completedDays});

  final int completedDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final localeCode = Localizations.localeOf(context).languageCode;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    // Week starts Saturday in Arabic, Monday in English.
    final startWeekday = localeCode == 'ar' ? DateTime.saturday : DateTime.monday;
    final offset = (todayDate.weekday - startWeekday) % 7;
    final weekStart = todayDate.subtract(Duration(days: offset));
    final days = List<DateTime>.generate(7, (i) => weekStart.add(Duration(days: i)));
    final dayFmt = DateFormat.E(localeCode);
    // Mark the most recent [completedDays] days up to today as done.
    final doneFrom = offset - completedDays.clamp(0, offset + 1) + 1;

    return VireoCard(
      padding: const EdgeInsets.fromLTRB(VSpace.sm, VSpace.md, VSpace.sm, VSpace.sm),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _DayDot(
                    label: dayFmt.format(days[i]),
                    dayNumber: days[i].day,
                    isToday: i == offset,
                    isDone: i >= doneFrom && i <= offset,
                    isFuture: i > offset,
                  ),
                ),
            ],
          ),
          const SizedBox(height: VSpace.sm),
          Text(
            l10n.homeWeeklyProgress(completedDays),
            style: TextStyle(color: colors.textMute, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.label,
    required this.dayNumber,
    required this.isToday,
    required this.isDone,
    required this.isFuture,
  });

  final String label;
  final int dayNumber;
  final bool isToday;
  final bool isDone;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Column(
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: isToday ? colors.ember : colors.textMute,
            fontSize: 10.5,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: VMotion.base,
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? colors.ember
                : isFuture
                    ? Colors.transparent
                    : colors.surfaceRaised,
            border: isToday && !isDone
                ? Border.all(color: colors.ember, width: 2)
                : isFuture
                    ? Border.all(color: colors.line)
                    : null,
          ),
          child: isDone
              ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
              : Text(
                  '$dayNumber',
                  style: VType.number(
                    size: 13,
                    weight: FontWeight.w600,
                    color: isFuture ? colors.textMute : colors.text,
                  ),
                ),
        ),
      ],
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  const _RecoveryCard({required this.score, required this.onInfo});

  final int score;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final c = score >= 70
        ? colors.success
        : score >= 45
            ? colors.gold
            : colors.danger;

    return VireoCard(
      onTap: onInfo,
      semanticLabel: l10n.homeRecoveryScore,
      child: Row(
        children: [
          RingProgress(
            progress: score / 100,
            size: 60,
            stroke: 7,
            color: c,
            secondaryColor: colors.recovery,
            child: Text('$score', style: VType.number(size: 17, color: colors.text)),
          ),
          const SizedBox(width: VSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeRecoveryScore,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homeRecoveryReady,
                  style: TextStyle(color: colors.textMute, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.info_outline_rounded, size: 20, color: colors.textMute),
        ],
      ),
    );
  }
}

class _CheckInBanner extends StatelessWidget {
  const _CheckInBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return VireoCard(
      onTap: onTap,
      color: colors.gold.withValues(alpha: 0.12),
      borderColor: colors.gold.withValues(alpha: 0.4),
      padding: const EdgeInsets.all(VSpace.md - 2),
      child: Row(
        children: [
          Icon(Icons.event_available_rounded, color: colors.gold),
          const SizedBox(width: VSpace.sm),
          Expanded(
            child: Text(
              l10n.weeklyCheckInBanner,
              style: TextStyle(color: colors.text, fontWeight: FontWeight.w700),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: colors.gold),
        ],
      ),
    );
  }
}

// ───────────────────────────── Today's log ─────────────────────────────

class _TodayLog extends StatelessWidget {
  const _TodayLog({
    required this.items,
    required this.onScan,
    required this.onRemoveAi,
  });

  final List<TodayLogItem> items;
  final VoidCallback onScan;
  final ValueChanged<String> onRemoveAi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    if (items.isEmpty) {
      return VireoCard(
        onTap: onScan,
        padding: const EdgeInsets.all(VSpace.lg),
        borderColor: colors.ember.withValues(alpha: 0.35),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.ember.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.photo_camera_rounded, color: colors.ember, size: 26),
            ),
            const SizedBox(height: VSpace.sm),
            Text(
              l10n.uxLogEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.uxLogEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMute, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final visible = items.take(8).toList();
    return VireoCard(
      padding: const EdgeInsets.symmetric(vertical: VSpace.xxs),
      child: Column(
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: VSpace.md,
                endIndent: VSpace.md,
                color: colors.line.withValues(alpha: 0.5),
              ),
            visible[i].isAi
                ? Dismissible(
                    key: ValueKey<String>(visible[i].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => onRemoveAi(visible[i].id),
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsetsDirectional.only(end: VSpace.lg),
                      color: colors.danger.withValues(alpha: 0.15),
                      child: Icon(Icons.delete_outline_rounded, color: colors.danger),
                    ),
                    child: _LogRow(item: visible[i]),
                  )
                : _LogRow(item: visible[i]),
          ],
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.item});

  final TodayLogItem item;

  String _subtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (item.isAi && item.loggedAt != null) {
      final time = DateFormat.jm(Localizations.localeOf(context).languageCode)
          .format(item.loggedAt!);
      return '${l10n.uxAiScanned} · $time';
    }
    return switch (item.mealType) {
      MealType.breakfast => l10n.nutritionTabBreakfast,
      MealType.lunch => l10n.nutritionTabLunch,
      MealType.dinner => l10n.nutritionTabDinner,
      MealType.snack => l10n.nutritionTabSnack,
      null => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final accent = item.isAi ? VMacro.ai : colors.ember;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(VRadius.sm),
            ),
            child: Icon(
              item.isAi ? Icons.auto_awesome_rounded : Icons.restaurant_rounded,
              size: 20,
              color: accent,
            ),
          ),
          const SizedBox(width: VSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: VSpace.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.calories}', style: VType.number(size: 16, color: colors.text)),
              const SizedBox(height: 2),
              Text(
                'P ${item.protein.round()}g',
                style: TextStyle(color: VMacro.protein, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


