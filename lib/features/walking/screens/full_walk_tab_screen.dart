import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/activity/screens/outdoor_live_screen.dart';
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
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إيقاف جولة المشي؟'),
        content: const Text('هل ترغب في حفظ أو إنهاء جولة المشي الحالية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('استمرار'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isSessionActive = false;
              });
            },
            child: const Text('إنهاء الجولة'),
          ),
        ],
      ),
    );
  }

  void _editGoal(int currentGoal) {
    final ctrl = TextEditingController(text: '$currentGoal');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل هدف الخطوات اليومي'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'عدد الخطوات المستهدف',
            suffixText: 'خطوة',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text.trim());
              if (val != null && val >= 1000) {
                ref.read(walkingTrackerProvider.notifier).setDailyGoal(val);
              }
              Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final trackerState = ref.watch(walkingTrackerProvider);
    final notifier = ref.read(walkingTrackerProvider.notifier);
    final live = ref.watch(liveStepsProvider).valueOrNull;

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
    final pct = (progress * 100).round();
    final remaining = (goal - steps).clamp(0, goal);

    final sessionSteps = _isSessionActive ? (steps - _sessionStepsStart).clamp(0, 100000) : 0;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('المشي والنشاط', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            tooltip: 'تشخيص الخطوات',
            icon: const Icon(Icons.settings_suggest_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StepDiagnosticScreen()),
            ),
          ),
          IconButton(
            tooltip: 'تحديث',
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
              // ── HERO: Big Ring with Live Steps & Progress ──
              Center(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 16,
                        backgroundColor: colors.line.withValues(alpha: 0.5),
                        valueColor: const AlwaysStoppedAnimation<Color>(_stepsAccent),
                        strokeCap: StrokeCap.round,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            NumberFormat.decimalPattern().format(steps),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                  height: 1.1,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            remaining > 0 ? 'باقي $remaining خطوة' : 'حققت الهدف! 🎉',
                            style: TextStyle(
                              color: remaining > 0 ? colors.textMute : _stepsAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$pct%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: _stepsAccent,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _editGoal(goal),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.surfaceRaised,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colors.line),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'الهدف: $goal',
                                    style: TextStyle(
                                      color: colors.textMute,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.edit, size: 11, color: colors.textMute),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Session Controls: Start/Pause/Stop session ──
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
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: const Text('ابدأ جولة مشي', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
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
                      child: const Text('إيقاف', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // ── Stat Tiles (Distance, Calories, Fat burned, Active time) ──
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.straighten_rounded,
                      label: 'المسافة',
                      value: '${metrics.distanceKm.toStringAsFixed(2)} كم',
                      color: _stepsCyan,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.local_fire_department_rounded,
                      label: 'السعرات',
                      value: '${metrics.caloriesKcal} ك.ع',
                      color: colors.ember,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.water_drop_outlined,
                      label: 'الدهون',
                      value: '${metrics.fatBurnedGrams.toStringAsFixed(1)} جم',
                      color: colors.gold,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.timer_outlined,
                      label: 'النشاط',
                      value: '${metrics.activeMinutes} د',
                      color: colors.recovery,
                      colors: colors,
                    ),
                  ),
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
                      child: const Text('ابدأ GPS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Segmented Control & Charts (Day / Week / Month) ──
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('سجل الحركة والخطوات', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        SegmentedButton<WalkChartFilter>(
                          segments: const [
                            ButtonSegment(value: WalkChartFilter.day, label: Text('اليوم')),
                            ButtonSegment(value: WalkChartFilter.week, label: Text('أسبوع')),
                            ButtonSegment(value: WalkChartFilter.month, label: Text('شهر')),
                          ],
                          selected: {_filter},
                          onSelectionChanged: (set) {
                            if (set.isNotEmpty) setState(() => _filter = set.first);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _BarChart(
                      days: last7,
                      goal: goal,
                      filter: _filter,
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
                    const Text('الإنجازات والأرقام القياسية 🏆', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
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

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: colors.textMute, fontSize: 11)),
        ],
      ),
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

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.days,
    required this.goal,
    required this.filter,
    required this.colors,
    required this.accent,
  });

  final List<DailyStepCount> days;
  final int goal;
  final WalkChartFilter filter;
  final VireoColors colors;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final maxSteps = days.fold<int>(goal, (m, d) => d.steps > m ? d.steps : m);

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (days[i].steps > 0)
                      Text(
                        _compact(days[i].steps),
                        style: TextStyle(color: colors.textMute, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final h = maxSteps > 0
                                ? (days[i].steps / maxSteps * constraints.maxHeight).clamp(4.0, constraints.maxHeight)
                                : 4.0;
                            final hit = goal > 0 && days[i].steps >= goal;
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
                      _dayInitial(days[i].date),
                      style: TextStyle(
                        color: _isToday(days[i].date) ? accent : colors.textMute,
                        fontSize: 10,
                        fontWeight: _isToday(days[i].date) ? FontWeight.w900 : FontWeight.w600,
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
