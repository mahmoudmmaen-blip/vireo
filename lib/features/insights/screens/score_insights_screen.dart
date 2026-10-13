import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/insights/domain/energy_projection.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/measurements/screens/inbody_scan_screen.dart';
import 'package:vireo/features/measurements/screens/navy_tape_measure_screen.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';

/// Full-screen Score & Smart Insights Screen with pinned summary-first hierarchy.
class ScoreInsightsScreen extends ConsumerWidget {
  const ScoreInsightsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScoreInsightsScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');

    final breakdown = ref.watch(dailyScoreProvider);
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final weeklyDeficit = ref.watch(weeklyDeficitProvider);
    final inbody = ref.watch(latestBodyCompositionProvider);
    final profile = WalkingCalculations.readProfileMetrics();
    final calorieGoal = ref.watch(calorieGoalProvider);

    // Compute projection strictly from COMPLETED days (exclude today; require eaten >= 800)
    final completedRecords = weeklyDeficit.days
        .where((d) => !d.isToday && d.consumed >= 800)
        .map((d) => (eatenKcal: d.consumed, burnedKcal: d.burned))
        .toList();

    final customBmr = inbody?.leanMassKg != null
        ? BodyCompositionMath.katchMcArdleBmr(inbody!.leanMassKg!)
        : inbody?.bmrKcal;

    final projection = EnergyProjectionCalculator.compute(
      dailyRecords: completedRecords,
      currentWeightKg: inbody?.weightKg ?? profile.weightKg,
      goalWeightKg: profile.weightKg > 5 ? profile.weightKg - 5 : null,
      heightCm: profile.heightCm,
      age: 28,
      isFemale: profile.isFemale,
      customBmr: customBmr,
    );

    // Weekly fat loss grams from completed days deficit (7.7 kcal ≈ 1 g fat)
    final weekFatLossGrams = weeklyDeficit.totalNetKcal > 0
        ? (weeklyDeficit.totalNetKcal / 7.7).round()
        : (projection.hasSufficientData ? projection.weeklyFatLossGrams.round() : 0);

    final weeksStr = projection.weeksToGoalWeight != null
        ? projection.weeksToGoalWeight!.toStringAsFixed(1)
        : (projection.hasSufficientData ? '6.0' : '—');

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.scoreInsightsTitle,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── 1. Top Pinned Summary Card (always visible, no scrolling) ──
            _PinnedSummaryCard(
              breakdown: breakdown,
              nutrition: nutrition,
              calorieTarget: calorieGoal.calories,
              weekFatLossGrams: weekFatLossGrams,
              weeksToGoal: weeksStr,
              colors: colors,
              l10n: l10n,
              onActionTap: () => AiScanScreen.open(context, ref),
            ),

            // ── Scrollable Body with strict new order ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // ── 2. Smart Predictions (moved UP, directly under summary) ──
                  _SmartPredictionsCard(
                    projection: projection,
                    l10n: l10n,
                    colors: colors,
                  ),
                  const SizedBox(height: 16),

                  // ── 3. Body Composition Card ──
                  _BodyCompositionInsightsCard(
                    report: inbody,
                    isArabic: isArabic,
                    colors: colors,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 16),

                  // ── 4. Score Breakdown Bars ──
                  _ComponentBarsCard(breakdown: breakdown, colors: colors),
                  const SizedBox(height: 16),

                  // ── 5. Charts (Score trend, Energy balance with x-axis day labels & kcal, macros) ──
                  _ChartsSection(
                    nutrition: nutrition,
                    weeklyDeficit: weeklyDeficit,
                    locale: locale,
                    isArabic: isArabic,
                    l10n: l10n,
                    colors: colors,
                  ),
                  const SizedBox(height: 16),

                  // ── 6. Tips & Actions ──
                  _ActionableTipsSection(
                    l10n: l10n,
                    colors: colors,
                  ),
                  const SizedBox(height: 16),

                  // ── 7. "إزاي حسبناها؟" collapsed at bottom ──
                  _HowWeCalculatedSection(
                    projection: projection,
                    l10n: l10n,
                    colors: colors,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 1. Pinned Summary Card (always visible, no scrolling).
/// Contains the enlarged score ring + 3 one-line facts + 1 main action button.
class _PinnedSummaryCard extends StatelessWidget {
  const _PinnedSummaryCard({
    required this.breakdown,
    required this.nutrition,
    required this.calorieTarget,
    required this.weekFatLossGrams,
    required this.weeksToGoal,
    required this.colors,
    required this.l10n,
    required this.onActionTap,
  });

  final DailyScoreBreakdown breakdown;
  final TodayNutrition nutrition;
  final int calorieTarget;
  final int weekFatLossGrams;
  final String weeksToGoal;
  final VireoColors colors;
  final AppLocalizations l10n;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final progress = (breakdown.totalScore / 100.0).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.line.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Enlarged Score Ring (112 dp)
              SizedBox(
                width: 112,
                height: 112,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 104,
                      height: 104,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 9,
                        backgroundColor: colors.line,
                        valueColor: AlwaysStoppedAnimation<Color>(breakdown.scoreColor),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${breakdown.totalScore}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '/100',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colors.textMute,
                                height: 1.0,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // 3 One-Line Facts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _factRow(
                      Icons.restaurant_rounded,
                      l10n.scoreInsightsTodaySummary(nutrition.eatenKcal, calorieTarget),
                    ),
                    const SizedBox(height: 6),
                    _factRow(
                      Icons.local_fire_department_rounded,
                      l10n.scoreInsightsWeekFatSummary(weekFatLossGrams),
                    ),
                    const SizedBox(height: 6),
                    _factRow(
                      Icons.flag_rounded,
                      l10n.scoreInsightsGoalWeeksSummary(weeksToGoal),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Primary Main Action Button
          FilledButton.icon(
            onPressed: onActionTap,
            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
            label: Text(l10n.scoreInsightsActionLogProtein),
            style: FilledButton.styleFrom(
              backgroundColor: colors.ember,
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _factRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: colors.ember),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

/// 2. Smart Predictions Card (moved UP directly under summary).
class _SmartPredictionsCard extends StatelessWidget {
  const _SmartPredictionsCard({
    required this.projection,
    required this.l10n,
    required this.colors,
  });

  final EnergyProjectionResult projection;
  final AppLocalizations l10n;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_graph_rounded, color: Color(0xFF8B5CF6), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scoreInsightsPredictionsTitle,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    Text(
                      l10n.scoreInsightsPredictionsSubtitle,
                      style: TextStyle(color: colors.textMute, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (!projection.hasSufficientData) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.scoreInsightsNeedData(projection.dataDaysCount),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Projected fat loss & weight metrics
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: l10n.scoreInsightsWeeklyFatLoss,
                    value: '≈ ${projection.weeklyFatLossGrams.round()} جم',
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricTile(
                    title: l10n.scoreInsightsIn4Weeks,
                    value: '${projection.projectedWeight4Weeks} كجم',
                    color: colors.ember,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: l10n.scoreInsightsIn8Weeks,
                    value: '${projection.projectedWeight8Weeks} كجم',
                    color: const Color(0xFF38BDF8),
                  ),
                ),
                if (projection.weeksToGoalWeight != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(
                      title: l10n.scoreInsightsGoalHitIn,
                      value: '≈ ${projection.weeksToGoalWeight} أسبوع',
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ],
            ),

            if (projection.isClampedToSafeLimit) ...[
              const SizedBox(height: 10),
              Text(
                l10n.scoreInsightsClampWarning,
                style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
            if (projection.isDeficitTooAggressive) ...[
              const SizedBox(height: 6),
              Text(
                l10n.scoreInsightsAggressiveDeficitWarning,
                style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// 3. Body Composition Card in Score & Insights
class _BodyCompositionInsightsCard extends StatelessWidget {
  const _BodyCompositionInsightsCard({
    required this.report,
    required this.isArabic,
    required this.colors,
    required this.l10n,
  });

  final BodyCompositionReport? report;
  final bool isArabic;
  final VireoColors colors;
  final AppLocalizations l10n;

  static String _sourceLabel(BodyCompositionSource source, bool isArabic) {
    return switch (source) {
      BodyCompositionSource.inbodyScan => isArabic ? 'تقرير InBody' : 'InBody Scan',
      BodyCompositionSource.navyTape => isArabic ? 'قياس المازورة (Navy)' : 'Tape Measure',
      BodyCompositionSource.healthConnect => 'Health Connect',
      BodyCompositionSource.manual => isArabic ? 'يدوي' : 'Manual',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.line.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.accessibility_new_rounded, color: colors.ember, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.scoreInsightsBodyCompTitle,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              if (report != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _sourceLabel(report!.source, isArabic),
                    style: TextStyle(color: colors.ember, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          if (report != null) ...[
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'نسبة الدهون (%BF)' : 'Body Fat %',
                    value: report!.percentBodyFat != null ? '${report!.percentBodyFat!.toStringAsFixed(1)}%' : '—',
                    color: colors.ember,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'الكتلة العضلية' : 'Lean Mass',
                    value: report!.leanMassKg != null ? '${report!.leanMassKg!.toStringAsFixed(1)} كجم' : '—',
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'كتلة الدهون' : 'Fat Mass',
                    value: report!.bodyFatMassKg != null ? '${report!.bodyFatMassKg!.toStringAsFixed(1)} كجم' : '—',
                    color: const Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'حرق BMR (Katch)' : 'BMR Kcal',
                    value: report!.bmrKcal != null ? '${report!.bmrKcal!.round()} سعرة' : '—',
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => BodyCompositionScreen.open(context),
                icon: const Icon(Icons.show_chart, size: 16),
                label: Text(l10n.scoreInsightsBodyCompNewMeasure),
                style: TextButton.styleFrom(foregroundColor: colors.ember),
              ),
            ),
          ] else ...[
            Text(
              l10n.scoreInsightsBodyCompPrompt,
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => NavyTapeMeasureScreen.open(context),
                    icon: const Icon(Icons.straighten, size: 16),
                    label: Text(isArabic ? 'قياس بالمازورة' : 'Tape Measure'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => InBodyScanScreen.open(context),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                    label: Text(isArabic ? 'مسح InBody' : 'Scan InBody'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 4. Score Breakdown Bars Card
class _ComponentBarsCard extends StatelessWidget {
  const _ComponentBarsCard({
    required this.breakdown,
    required this.colors,
  });

  final DailyScoreBreakdown breakdown;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.line.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'عوامل السكور الـ 6',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: colors.text),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                breakdown.scoreTierLabel,
                style: TextStyle(color: breakdown.scoreColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _componentRow('الخطوات والنشاط', breakdown.stepsScore, 25, '100 خطوة = دقيقة نشاط', colors),
          _componentRow('البروتين المكتمل', breakdown.proteinScore, 20, 'احرص على تقفيل هدف الجرامات', colors),
          _componentRow('توازن السعرات (±10%)', breakdown.caloriesScore, 15, 'سعرات ضمن النطاق الآمن', colors),
          _componentRow('شرب الماء', breakdown.waterScore, 15, 'ترطيب كامل ينشط الحرق', colors),
          _componentRow('التمرين اليومي', breakdown.workoutScore, 15, 'تحفيز العضلات والقلب', colors),
          _componentRow('النوم والتعافي', breakdown.sleepScore, 10, '7+ ساعات لإفراز الهرمونات', colors),
        ],
      ),
    );
  }

  Widget _componentRow(String label, double val, double max, String howTo, VireoColors colors) {
    final frac = (val / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${val.round()}/$max',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: frac,
              backgroundColor: colors.line,
              valueColor: AlwaysStoppedAnimation<Color>(
                frac >= 1.0 ? colors.success : (frac >= 0.5 ? colors.gold : colors.ember),
              ),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 2),
          Text(howTo, style: TextStyle(fontSize: 10, color: colors.textMute)),
        ],
      ),
    );
  }
}

/// 5. Charts Section with x-axis day labels and kcal values on energy balance chart
class _ChartsSection extends StatelessWidget {
  const _ChartsSection({
    required this.nutrition,
    required this.weeklyDeficit,
    required this.locale,
    required this.isArabic,
    required this.l10n,
    required this.colors,
  });

  final TodayNutrition nutrition;
  final WeeklyDeficitSummary weeklyDeficit;
  final String locale;
  final bool isArabic;
  final AppLocalizations l10n;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    final days = weeklyDeficit.days;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.scoreInsightsScoreTrendTitle,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 45),
                      FlSpot(1, 55),
                      FlSpot(2, 60),
                      FlSpot(3, 75),
                      FlSpot(4, 70),
                      FlSpot(5, 82),
                      FlSpot(6, 85),
                    ],
                    isCurved: true,
                    color: colors.ember,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: colors.ember.withValues(alpha: 0.15),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Chart 2: Energy Balance with X-Axis Day Labels & Kcal values
          Text(
            l10n.scoreInsightsEnergyBalanceTitle,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 3000,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: colors.line.withValues(alpha: 0.3),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: 1000,
                      getTitlesWidget: (val, meta) {
                        if (val == 0) return const SizedBox.shrink();
                        return Text(
                          '${(val / 1000).toInt()}k',
                          style: TextStyle(color: colors.textMute, fontSize: 9.5),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final idx = val.toInt();
                        if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                        final d = days[idx];
                        final dayName = DateFormat.E(locale).format(d.date);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            d.isToday ? (isArabic ? 'اليوم' : 'Today') : dayName,
                            style: TextStyle(
                              color: d.isToday ? colors.ember : colors.textMute,
                              fontSize: 9.5,
                              fontWeight: d.isToday ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (var i = 0; i < days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: days[i].consumed.toDouble().clamp(0.0, 3000.0),
                          color: colors.ember,
                          width: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: (days[i].tdee + days[i].burned).toDouble().clamp(0.0, 3000.0),
                          color: const Color(0xFF10B981),
                          width: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, color: colors.ember),
              const SizedBox(width: 4),
              Text(l10n.scoreInsightsEatenKcal, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 16),
              Container(width: 8, height: 8, color: const Color(0xFF10B981)),
              const SizedBox(width: 4),
              Text(l10n.scoreInsightsBurnedKcal, style: const TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Chart 3: Macros Today
          Text(
            l10n.scoreInsightsMacrosTitle,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
          ),
          const SizedBox(height: 10),
          _macroBar('بروتين', nutrition.proteinG, nutrition.proteinTarget.toDouble(), VMacro.protein),
          _macroBar('كارب', nutrition.carbsG, nutrition.carbsTarget.toDouble(), VMacro.carbs),
          _macroBar('دهون', nutrition.fatG, nutrition.fatTarget.toDouble(), VMacro.fat),
        ],
      ),
    );
  }

  Widget _macroBar(String label, double actual, double target, Color color) {
    final frac = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${actual.round()} / ${target.round()} جم', style: const TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: frac,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

/// 6. Actionable Tips Section
class _ActionableTipsSection extends ConsumerWidget {
  const _ActionableTipsSection({
    required this.l10n,
    required this.colors,
  });

  final AppLocalizations l10n;
  final VireoColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.scoreInsightsImmediateActionsTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 8),
        _actionRow(
          icon: Icons.camera_alt_rounded,
          label: l10n.scoreInsightsActionLogProtein,
          onTap: () => AiScanScreen.open(context, ref),
          colors: colors,
        ),
        _actionRow(
          icon: Icons.directions_walk_rounded,
          label: l10n.scoreInsightsActionWalk,
          onTap: () => ref.read(shellTabIndexProvider.notifier).goWalk(),
          colors: colors,
        ),
        _actionRow(
          icon: Icons.water_drop_rounded,
          label: l10n.scoreInsightsActionWater,
          onTap: () => Navigator.of(context).pop(),
          colors: colors,
        ),
      ],
    );
  }

  Widget _actionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required VireoColors colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.line.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              Icon(icon, color: colors.ember, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: colors.textMute, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

/// 7. "إزاي حسبناها؟" collapsed at bottom
class _HowWeCalculatedSection extends StatelessWidget {
  const _HowWeCalculatedSection({
    required this.projection,
    required this.l10n,
    required this.colors,
  });

  final EnergyProjectionResult projection;
  final AppLocalizations l10n;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line.withValues(alpha: 0.5)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          l10n.scoreInsightsHowCalculatedTitle,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: colors.textMute),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${l10n.scoreInsightsHowCalculatedBmr(projection.bmr.toString())}\n'
              '${l10n.scoreInsightsHowCalculatedTdee(projection.tdee.toString())}\n'
              '${l10n.scoreInsightsHowCalculatedFat}',
              style: TextStyle(fontSize: 11.5, color: colors.textMute, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
