import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/insights/domain/energy_projection.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';

/// Full-screen Score & Smart Insights Screen replacing the old bottom sheet.
class ScoreInsightsScreen extends ConsumerWidget {
  const ScoreInsightsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScoreInsightsScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final breakdown = ref.watch(dailyScoreProvider);
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final profile = WalkingCalculations.readProfileMetrics();

    // Mock/derived daily history for 7-day trends and projection calculation
    final records = <({int eatenKcal, int burnedKcal})>[
      (eatenKcal: (nutrition.eatenKcal * 0.9).round(), burnedKcal: 420),
      (eatenKcal: (nutrition.eatenKcal * 1.05).round(), burnedKcal: 480),
      (eatenKcal: nutrition.eatenKcal, burnedKcal: nutrition.burnedKcal > 0 ? nutrition.burnedKcal : 400),
    ];

    final projection = EnergyProjectionCalculator.compute(
      dailyRecords: records,
      currentWeightKg: profile.weightKg,
      goalWeightKg: profile.weightKg > 5 ? profile.weightKg - 5 : null,
      heightCm: profile.heightCm,
      age: 28,
      isFemale: profile.isFemale,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'السكور والتوقعات الذكية 🎯' : 'Score & Smart Insights 🎯',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ── Section 1: Header Ring + 6 Component Bars ──
            _HeaderScoreBreakdownCard(breakdown: breakdown, isArabic: isArabic),
            const SizedBox(height: 16),

            // ── Section 2: Charts (7-day trend, Energy balance, Today's Macros) ──
            _ChartsSection(nutrition: nutrition, isArabic: isArabic),
            const SizedBox(height: 16),

            // ── Section 3: Smart Predictions ("توقعات ذكية") ──
            _SmartPredictionsCard(
              projection: projection,
              currentWeight: profile.weightKg,
              isArabic: isArabic,
            ),
            const SizedBox(height: 16),

            // ── Section 4: Actionable Tips List ──
            _ActionableTipsSection(breakdown: breakdown, isArabic: isArabic),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _HeaderScoreBreakdownCard extends StatelessWidget {
  const _HeaderScoreBreakdownCard({
    required this.breakdown,
    required this.isArabic,
  });

  final DailyScoreBreakdown breakdown;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

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
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: breakdown.totalScore / 100.0,
                      strokeWidth: 8,
                      backgroundColor: colors.line,
                      valueColor: AlwaysStoppedAnimation<Color>(breakdown.scoreColor),
                      strokeCap: StrokeCap.round,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${breakdown.totalScore}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '/100',
                          style: TextStyle(fontSize: 9, color: colors.textMute, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'سكور اليوم التراكمي' : 'Today\'s Cumulative Score',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      breakdown.scoreTierLabel,
                      style: TextStyle(color: breakdown.scoreColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? 'يتكون من 6 عوامل أساسية لصحة مستدامة' : 'Composed of 6 key pillars for health',
                      style: TextStyle(color: colors.textMute, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
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

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({
    required this.nutrition,
    required this.isArabic,
  });

  final TodayNutrition nutrition;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

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
            isArabic ? 'التحليلات والرسوم البيانية' : 'Analytics & Charts',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 14),

          // Chart 1: 7-day Score Trend
          Text(
            isArabic ? 'مسار السكور خلال 7 أيام' : '7-Day Score Trend',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
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

          // Chart 2: 7-day Energy Balance Bars (eaten vs burned)
          Text(
            isArabic ? 'توازن الطاقة (المأكول مقابل المحروق)' : 'Energy Balance (Eaten vs Burned)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2600,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (var i = 0; i < 7; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: 1800.0 + (i * 50),
                          color: colors.ember,
                          width: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: 2150.0 + (i * 20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, color: colors.ember),
              const SizedBox(width: 4),
              Text(isArabic ? 'سعرات أكل' : 'Eaten', style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 16),
              Container(width: 8, height: 8, color: const Color(0xFF10B981)),
              const SizedBox(width: 4),
              Text(isArabic ? 'حرق ونشاط' : 'Burned', style: const TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Chart 3: Macros Today (Target vs Eaten stacked bar)
          Text(
            isArabic ? 'توزيع الماكروز اليوم (الهدف vs المأكول)' : 'Today\'s Macros (Target vs Actual)',
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

class _SmartPredictionsCard extends StatelessWidget {
  const _SmartPredictionsCard({
    required this.projection,
    required this.currentWeight,
    required this.isArabic,
  });

  final EnergyProjectionResult projection;
  final double currentWeight;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

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
                      isArabic ? 'توقعات ذكية (تقديري 🔮)' : 'Smart Predictions (Estimated 🔮)',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    Text(
                      isArabic ? 'مبنية على عجز السعرات ومعدل الحرق' : 'Based on calorie deficit and metabolic rate',
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
                      isArabic
                          ? 'محتاجين 3 أيام بيانات عشان التوقع يبقى دقيق (سجلت ${projection.dataDaysCount} يوم)'
                          : 'Need at least 3 days of logs for precise projection (${projection.dataDaysCount} logged)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Projected fat loss & weight
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'دهون مفقودة أسبوعياً' : 'Weekly Fat Loss',
                    value: '≈ ${projection.weeklyFatLossGrams.round()} جم',
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'بعد 4 أسابيع' : 'In 4 Weeks',
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
                    title: isArabic ? 'بعد 8 أسابيع' : 'In 8 Weeks',
                    value: '${projection.projectedWeight8Weeks} كجم',
                    color: const Color(0xFF38BDF8),
                  ),
                ),
                if (projection.weeksToGoalWeight != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(
                      title: isArabic ? 'الوصول للهدف في' : 'Goal Hit In',
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
                isArabic
                    ? '⚠️ تم ضبط معدل النزول بما لا يتعدى 1% من وزن الجسم أسبوعياً لحماية صحتك وعضلاتك.'
                    : '⚠️ Projected loss clamped to ≤1% body weight per week for muscle safety.',
                style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
            if (projection.isDeficitTooAggressive) ...[
              const SizedBox(height: 6),
              Text(
                isArabic
                    ? '⚠️ عجز السعرات أعلى من 1,000 سعرة/يوم. ننصح بزيادة السعرات قليلاً لتجنب تباطؤ الحرق.'
                    : '⚠️ Deficit exceeds 1,000 kcal/day. Consider eating slightly more to preserve BMR.',
                style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ],

          const SizedBox(height: 12),
          // Formula Expandable
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              isArabic ? 'إزاي حسبناها؟ (معادلة Mifflin-St Jeor)' : 'How was this calculated? (Mifflin-St Jeor)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textMute),
            ),
            children: [
              Text(
                isArabic
                    ? '• معدل الأيض الأساسي (BMR): ${projection.bmr} سعرة\n'
                      '• معدل الحرق اليومي الكامل (TDEE): ${projection.tdee} سعرة\n'
                      '• كل 7,700 سعرة عجز تساوي حرق 1 كجم من دهون الجسم تقريباً.'
                    : '• BMR: ${projection.bmr} kcal\n'
                      '• TDEE: ${projection.tdee} kcal\n'
                      '• 7,700 kcal deficit ≈ 1 kg fat loss.',
                style: TextStyle(fontSize: 11.5, color: colors.textMute, height: 1.5),
              ),
            ],
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

class _ActionableTipsSection extends ConsumerWidget {
  const _ActionableTipsSection({
    required this.breakdown,
    required this.isArabic,
  });

  final DailyScoreBreakdown breakdown;
  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isArabic ? 'نصائح وإجراءات فورية لرفع السكور:' : 'Actionable Tips to Boost Score:',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 8),
        _actionRow(
          icon: Icons.camera_alt_rounded,
          label: isArabic ? 'سجّل وجبة غنية بالبروتين' : 'Log a high-protein meal',
          onTap: () => AiScanScreen.open(context, ref),
          colors: colors,
        ),
        _actionRow(
          icon: Icons.directions_walk_rounded,
          label: isArabic ? 'ابدأ مشي وأكمل خطواتك' : 'Start walking towards goal',
          onTap: () => ref.read(shellTabIndexProvider.notifier).goWalk(),
          colors: colors,
        ),
        _actionRow(
          icon: Icons.water_drop_rounded,
          label: isArabic ? 'اشرب كوب ماء الآن' : 'Log water glass now',
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
