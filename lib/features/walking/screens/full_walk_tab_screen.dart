import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/activity/screens/outdoor_live_screen.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/step_foreground_service.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/walking/screens/step_diagnostic_screen.dart';
import 'package:vireo/features/walking/widgets/step_permission_gate.dart';

enum WalkChartFilter { day, week, month }

class FullWalkTabScreen extends ConsumerStatefulWidget {
  const FullWalkTabScreen({super.key});

  @override
  ConsumerState<FullWalkTabScreen> createState() => _FullWalkTabScreenState();
}

class _FullWalkTabScreenState extends ConsumerState<FullWalkTabScreen> {
  WalkChartFilter _filter = WalkChartFilter.week;
  bool _isSessionActive = false;
  int _sessionStepsStart = 0;

  static const _stepsAccent = Color(0xFF10B981);
  static const _stepsCyan = Color(0xFF06B6D4);

  void _startSession(int currentSteps) {
    HapticFeedback.heavyImpact();
    setState(() {
      _isSessionActive = true;
      _sessionStepsStart = currentSteps;
    });
  }

  void _pauseOrStopSession() {
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.walkingStopSessionTitle),
        content: Text(l10n.walkingStopSessionDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.walkingSessionContinue),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isSessionActive = false;
              });
            },
            child: Text(l10n.walkingSessionEnd),
          ),
        ],
      ),
    );
  }

  void _editGoal(int currentGoal) {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: '$currentGoal');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.walkingEditGoalTitle),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.walkingTargetStepsLabel,
            suffixText: l10n.walkingStepsSuffix,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text.trim());
              if (val != null && val >= 1000) {
                ref.read(walkingTrackerProvider.notifier).setDailyGoal(val);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final trackerState = ref.watch(walkingTrackerProvider);
    final notifier = ref.read(walkingTrackerProvider.notifier);
    final live = ref.watch(liveStepsProvider).valueOrNull;
    final isRunning = ref.watch(isStepCounterRunningProvider);

    final steps = live?.todaySteps ?? trackerState.valueOrNull?.todaySteps ?? 0;
    final goal = trackerState.valueOrNull?.dailyGoal ?? 7000;
    final last7 = live?.last7Days.isNotEmpty == true
        ? live!.last7Days
        : (trackerState.valueOrNull?.last7Days ?? const <DailyStepCount>[]);

    final profile = WalkingCalculations.readProfileMetrics();
    final metrics = WalkingCalculations.compute(
      steps: steps,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      isFemale: profile.isFemale,
    );
    final progress = goal > 0 ? (steps / goal).clamp(0.0, 1.0) : 0.0;

    final sessionSteps = _isSessionActive ? (steps - _sessionStepsStart).clamp(0, 100000) : 0;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.walkingScreenTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            tooltip: l10n.walkingDiagnosticsTooltip,
            icon: const Icon(Icons.settings_suggest_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StepDiagnosticScreen()),
            ),
          ),
          IconButton(
            tooltip: l10n.walkingRefreshTooltip,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => notifier.refresh(),
          ),
        ],
      ),
      body: StepPermissionGate(
        child: RefreshIndicator(
          color: colors.ember,
          onRefresh: () => notifier.refresh(),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // ── HERO: Matching Leap Dark Theme Hero ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF162032), // Deep Navy from Leap reference
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top row: Play/Pause button + steps + goal
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Play/Pause circle toggle
                        InkWell(
                          onTap: () async {
                            HapticFeedback.heavyImpact();
                            await StepForegroundService.toggle();
                            await ref.read(isStepCounterRunningProvider.notifier).resync();
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C3E55),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isRunning ? _stepsAccent : Colors.white24,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: isRunning ? _stepsAccent : Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        // Large Step Number + Goal
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.edit, size: 16, color: Colors.white54),
                                    onPressed: () => _editGoal(goal),
                                  ),
                                  Text(
                                    NumberFormat.decimalPattern().format(steps),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -1,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '/$goal خطوة',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Thick Green Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 16,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFF2C3E55),
                          valueColor: const AlwaysStoppedAnimation<Color>(_stepsAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3 Stat Columns (كم, سعرات, الوقت)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _WalkStatCol(
                          icon: Icons.track_changes_rounded,
                          iconColor: const Color(0xFFFBBF24),
                          value: metrics.distanceKm.toStringAsFixed(2),
                          label: 'كم',
                        ),
                        _WalkStatCol(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFF97316),
                          value: '${metrics.caloriesKcal}',
                          label: 'السعرات',
                        ),
                        _WalkStatCol(
                          icon: Icons.access_time_filled_rounded,
                          iconColor: const Color(0xFF38BDF8),
                          value: '${(metrics.activeMinutes ~/ 60)}س ${(metrics.activeMinutes % 60)}د',
                          label: 'الوقت',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Session Controls: Walk Session Start/Pause/Stop ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isSessionActive)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _stepsAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VRadius.pill)),
                      ),
                      onPressed: () => _startSession(steps),
                      icon: const Icon(Icons.directions_walk_rounded, size: 22),
                      label: const Text('ابدأ جولة مشي محددة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    )
                  else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _stepsAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(VRadius.pill),
                      ),
                      child: Text(
                        'جولة جارية: $sessionSteps خطوة',
                        style: const TextStyle(color: _stepsAccent, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.danger,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VRadius.pill)),
                      ),
                      onPressed: _pauseOrStopSession,
                      child: const Text('إنهاء الجولة', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              // ── GPS Tracking Live Map Banner (OpenStreetMap) ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _stepsAccent.withValues(alpha: 0.15),
                      colors.surface,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(VRadius.lg),
                  border: Border.all(color: _stepsAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _stepsAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.map_rounded, color: _stepsAccent, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المشي في الهواء الطلق مع الخريطة',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'تتبع مسار GPS المباشر، السرعة، والصوت التوجيهي',
                            style: TextStyle(color: colors.textMute, fontSize: 11.5),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _stepsAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const OutdoorLiveScreen(
                              type: OutdoorWorkoutType.walk,
                            ),
                          ),
                        );
                      },
                      child: Text(l10n.walkingStartGps, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Segmented Control & Charts (Day / Week / Month) ──
              // Uses Column + Row without horizontal overflow
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(VRadius.lg),
                  border: Border.all(color: colors.line.withValues(alpha: 0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header without overflow
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.walkingActivityHistory,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 36,
                          child: SegmentedButton<WalkChartFilter>(
                            style: SegmentedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            segments: [
                              ButtonSegment(value: WalkChartFilter.day, label: Text(l10n.walkingFilterDay, style: const TextStyle(fontSize: 12))),
                              ButtonSegment(value: WalkChartFilter.week, label: Text(l10n.walkingFilterWeek, style: const TextStyle(fontSize: 12))),
                              ButtonSegment(value: WalkChartFilter.month, label: Text(l10n.walkingFilterMonth, style: const TextStyle(fontSize: 12))),
                            ],
                            selected: {_filter},
                            onSelectionChanged: (set) {
                              if (set.isNotEmpty) setState(() => _filter = set.first);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _WalkPeriodChart(
                      filter: _filter,
                      todaySteps: steps,
                      last7Days: last7,
                      goal: goal,
                      colors: colors,
                      accent: _stepsAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Records & Achievements Grid ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(VRadius.lg),
                  border: Border.all(color: colors.line.withValues(alpha: 0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.walkingAchievementsTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.8,
                      children: [
                        _AchievementTile(
                          title: 'أعلى يوم خطوات',
                          value: '${last7.fold<int>(steps, (m, d) => d.steps > m ? d.steps : m)} خطوة',
                          icon: Icons.military_tech_rounded,
                          color: colors.gold,
                          colors: colors,
                        ),
                        _AchievementTile(
                          title: 'تحقيق الهدف',
                          value: '${last7.where((d) => d.steps >= goal).length} من 7 أيام',
                          icon: Icons.verified_rounded,
                          color: _stepsAccent,
                          colors: colors,
                        ),
                        _AchievementTile(
                          title: 'حرق الأسبوع',
                          value: '${metrics.caloriesKcal * 7} ك.ع',
                          icon: Icons.local_fire_department_rounded,
                          color: colors.ember,
                          colors: colors,
                        ),
                        _AchievementTile(
                          title: 'مجموع المسافة',
                          value: '${(metrics.distanceKm * 7).toStringAsFixed(1)} كم',
                          icon: Icons.route_rounded,
                          color: _stepsCyan,
                          colors: colors,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalkStatCol extends StatelessWidget {
  const _WalkStatCol({
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

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.colors,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: colors.textMute, fontSize: 10.5, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WalkPeriodChart extends StatelessWidget {
  const _WalkPeriodChart({
    required this.filter,
    required this.todaySteps,
    required this.last7Days,
    required this.goal,
    required this.colors,
    required this.accent,
  });

  final WalkChartFilter filter;
  final int todaySteps;
  final List<DailyStepCount> last7Days;
  final int goal;
  final VireoColors colors;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return switch (filter) {
      WalkChartFilter.day => _buildHourlyChart(),
      WalkChartFilter.week => _buildWeekChart(),
      WalkChartFilter.month => _buildMonthChart(),
    };
  }

  Widget _buildHourlyChart() {
    // Generate realistic hourly distribution for today based on current steps
    final currentHour = DateTime.now().hour;
    final hours = [8, 10, 12, 14, 16, 18, 20, 22];
    final activeHoursCount = hours.where((h) => h <= currentHour).length;
    final stepsPerBlock = activeHoursCount > 0 ? (todaySteps / activeHoursCount).round() : 0;

    final maxVal = (todaySteps > 0 ? stepsPerBlock * 1.5 : 500).toDouble();

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final h in hours)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final blockSteps = h <= currentHour ? stepsPerBlock : 0;
                            final height = maxVal > 0
                                ? (blockSteps / maxVal * constraints.maxHeight).clamp(4.0, constraints.maxHeight)
                                : 4.0;
                            return Container(
                              height: height,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: blockSteps > 0 ? accent : colors.line.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$h:00',
                      style: TextStyle(color: colors.textMute, fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekChart() {
    final list = last7Days.isNotEmpty ? last7Days : _fallback7Days();
    final maxSteps = list.fold<int>(goal, (m, d) => d.steps > m ? d.steps : m);

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < list.length && i < 7; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (list[i].steps > 0)
                      Text(
                        _compact(list[i].steps),
                        style: TextStyle(color: colors.textMute, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final h = maxSteps > 0
                                ? (list[i].steps / maxSteps * constraints.maxHeight).clamp(4.0, constraints.maxHeight)
                                : 4.0;
                            final hit = goal > 0 && list[i].steps >= goal;
                            return Container(
                              height: h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: hit ? accent : colors.line,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _dayInitial(list[i].date),
                      style: TextStyle(
                        color: _isToday(list[i].date) ? accent : colors.textMute,
                        fontSize: 10,
                        fontWeight: _isToday(list[i].date) ? FontWeight.w900 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthChart() {
    final history = StepCounterService.readHistory();
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final maxSteps = goal > 0 ? goal * 1.3 : 10000.0;

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var d = 1; d <= daysInMonth; d++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final dt = DateTime(now.year, now.month, d);
                            final key = StepCounterService.dateKey(dt);
                            final s = d == now.day ? todaySteps : (history[key] ?? 0);
                            final h = (s / maxSteps * constraints.maxHeight).clamp(2.0, constraints.maxHeight);
                            final hit = s >= goal;
                            return Container(
                              height: h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: hit
                                    ? accent
                                    : (s > 0 ? accent.withValues(alpha: 0.5) : colors.line.withValues(alpha: 0.3)),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (d % 5 == 1) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$d',
                        style: TextStyle(color: colors.textMute, fontSize: 8),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static List<DailyStepCount> _fallback7Days() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DailyStepCount(date: d, steps: 0);
    });
  }

  String _compact(int s) {
    if (s >= 1000) return '${(s / 1000).toStringAsFixed(1)}k';
    return '$s';
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  String _dayInitial(DateTime dt) {
    final names = ['إث', 'ثل', 'أر', 'خم', 'جم', 'سب', 'أح'];
    return names[(dt.weekday - 1) % 7];
  }
}
