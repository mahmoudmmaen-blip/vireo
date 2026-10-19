import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';
import 'package:vireo/features/progress/widgets/weekly_calories_intake_chart.dart';
import 'package:vireo/features/progress/widgets/weekly_steps_fl_chart.dart';
import 'package:vireo/features/progress/widgets/weight_trend_chart_card.dart';
import 'package:vireo/features/walking/data/steps_repository.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

/// P53: weekly steps + calories + weight charts — 1 tap from Home «التفاصيل».
class WeeklyChartsScreen extends ConsumerWidget {
  const WeeklyChartsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const WeeklyChartsScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final deficit = ref.watch(weeklyDeficitProvider);
    final live = ref.watch(liveStepsProvider).valueOrNull;
    final dash = ref.watch(homeDashboardProvider);
    final stepDays = live?.last7Days.isNotEmpty == true
        ? live!.last7Days
        : StepsRepository.last7Days();
    final stepGoal = dash.stepsGoal > 0 ? dash.stepsGoal : 8000;
    final logsAsync = ref.watch(weightLogsProvider);
    final goalAsync = ref.watch(weightGoalProvider);
    final trend = ref.watch(weightTrendAnalysisProvider);
    final unit = ref.watch(unitPreferenceProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isArabic ? 'رسوم الأسبوع' : 'This week'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(VSpace.md, VSpace.sm, VSpace.md, VSpace.xl),
        children: [
          Text(
            isArabic
                ? 'خطواتك وسعراتك ووزنك — نظرة سريعة على الأسبوع'
                : 'Steps, calories, and weight — a quick weekly look',
            style: TextStyle(color: colors.textMute, fontSize: 13.5),
          ),
          const SizedBox(height: VSpace.md),
          _ChartCard(
            child: WeeklyStepsFlChart(days: stepDays, goal: stepGoal),
          ),
          const SizedBox(height: VSpace.md),
          _ChartCard(
            child: WeeklyCaloriesIntakeChart(summary: deficit),
          ),
          const SizedBox(height: VSpace.md),
          logsAsync.when(
            loading: () => _ChartCard(
              child: SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(color: colors.ember),
                ),
              ),
            ),
            error: (_, _) => _ChartCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  isArabic
                      ? 'مقدرناش نقرأ سجل الوزن دلوقتي. جرّب تاني بعد شوية.'
                      : 'Could not load weight logs right now. Try again shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textMute),
                ),
              ),
            ),
            data: (logs) {
              if (logs.isEmpty) {
                return _ChartCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      isArabic
                          ? 'لسه ما سجّلتش وزن. سجّل قراءة وهتشوف اتجاهك هنا.'
                          : 'No weight logs yet. Log a reading to see your trend here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textMute,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                );
              }
              return WeightTrendChartCard(
                logs: logs,
                analysis: trend,
                goalKg: goalAsync.valueOrNull,
                unit: unit,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      padding: const EdgeInsets.all(VSpace.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.lg),
        border: Border.all(color: colors.line),
      ),
      child: child,
    );
  }
}
