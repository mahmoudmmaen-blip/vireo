import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/features/progress/domain/weekly_progress_report_data.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';

class WeeklyProgressReportScreen extends ConsumerStatefulWidget {
  const WeeklyProgressReportScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const WeeklyProgressReportScreen()),
    );
  }

  @override
  ConsumerState<WeeklyProgressReportScreen> createState() => _WeeklyProgressReportScreenState();
}

class _WeeklyProgressReportScreenState extends ConsumerState<WeeklyProgressReportScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isArabic = true;

  Future<void> _exportAndShareImage() async {
    try {
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/vireo_weekly_report_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: Text(
            _isArabic
                ? 'تم حفظ بطاقة التقرير! جاهزة للمشاركة على واتساب أو إنستجرام (${file.path})'
                : 'Report card image generated! Ready to share (${file.path})',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not generate share image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final reportAsync = ref.watch(weeklyProgressReportDataProvider);

    final deficitSummary = ref.watch(weeklyDeficitProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.weeklyReportTitle),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.language, size: 18),
            label: Text(_isArabic ? 'English' : 'عربي'),
            onPressed: () => setState(() => _isArabic = !_isArabic),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: l10n.weeklyReportShareCta,
            onPressed: _exportAndShareImage,
          ),
        ],
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(l10n.authErrorGeneric)),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // RepaintBoundary for high-res social card export
                RepaintBoundary(
                  key: _cardKey,
                  child: _ReportShareableCard(
                    data: data,
                    isArabic: _isArabic,
                    deficitSummary: deficitSummary,
                  ),
                ),
                if (deficitSummary.totalNetKcal > 0) ...[
                  const SizedBox(height: 16),
                  FatEquivalentBadge(
                    customText: l10n.fatEquivalentThisWeek(
                      FatEquivalent.formatAmount(
                        FatEquivalent.gramsFromKcal(deficitSummary.totalNetKcal),
                        languageCode: Localizations.localeOf(context).languageCode,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.ember,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _exportAndShareImage,
                  icon: const Icon(Icons.share),
                  label: Text(
                    _isArabic
                        ? 'مشاركة التقرير عبر واتساب / إنستجرام'
                        : 'Share card on WhatsApp / Instagram',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReportShareableCard extends StatelessWidget {
  const _ReportShareableCard({
    required this.data,
    required this.isArabic,
    required this.deficitSummary,
  });

  final WeeklyProgressReportData data;
  final bool isArabic;
  final WeeklyDeficitSummary deficitSummary;

  @override
  Widget build(BuildContext context) {
    final rangeStr =
        '${DateFormat.MMMd().format(data.weekStartDate)} - ${DateFormat.MMMd().format(data.weekEndDate)}';
    final weightDeltaStr =
        '${data.trendWeightChangeKg >= 0 ? '+' : ''}${data.trendWeightChangeKg.toStringAsFixed(1)} kg';

    return Directionality(
      textDirection: localeTextDirection(Locale(isArabic ? 'ar' : 'en')),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF18181B), Color(0xFF0F0F12), Color(0xFF1E1010)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEF5350).withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top branding
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF5350),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VIREO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isArabic ? 'تقرير التقدم الأسبوعي' : 'Weekly Progress Report',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  rangeStr,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12),
            const SizedBox(height: 14),

            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'متوسط السعرات' : 'Avg Calories',
                    value: '${data.avgCalories}',
                    sub: isArabic ? 'الهدف: ${data.targetCalories}' : 'Target: ${data.targetCalories}',
                    icon: Icons.local_fire_department_outlined,
                    color: const Color(0xFFF97316),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'متوسط البروتين' : 'Avg Protein',
                    value: '${data.avgProteinG} g',
                    sub: isArabic ? 'الهدف: ${data.targetProteinG} g' : 'Target: ${data.targetProteinG} g',
                    icon: Icons.fitness_center,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'أيام تسجيل الأكل' : 'Days Logged',
                    value: '${data.daysFoodLogged} / 7',
                    sub: isArabic ? 'التزام التغذية' : 'Consistency',
                    icon: Icons.restaurant_menu_outlined,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'التمارين المكتملة' : 'Workouts',
                    value: '${data.totalWorkoutsCompleted}',
                    sub: isArabic ? 'حصص تدريبية' : 'Sessions done',
                    icon: Icons.sports_gymnastics,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'متوسط الخطوات' : 'Steps Avg',
                    value: '${data.avgDailySteps}',
                    sub: isArabic ? 'خطوة/يوم' : 'steps/day',
                    icon: Icons.directions_walk,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'متوسط الماء' : 'Water Avg',
                    value: '${data.avgDailyWaterMl} ml',
                    sub: isArabic ? 'ترطيب ممتاز' : 'Daily intake',
                    icon: Icons.water_drop_outlined,
                    color: const Color(0xFF06B6D4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'متوسط النوم' : 'Sleep Avg',
                    value: '${data.avgSleepHours.toStringAsFixed(1)} h',
                    sub: isArabic ? 'ساعات راحة' : 'hours/night',
                    icon: Icons.bedtime_outlined,
                    color: const Color(0xFFA855F7),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    title: isArabic ? 'تغير اتجاه الوزن' : 'Trend Weight',
                    value: weightDeltaStr,
                    sub: isArabic ? 'معدل التغير' : 'Over 7 days',
                    icon: Icons.monitor_weight_outlined,
                    color: const Color(0xFFEC4899),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Best Day
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Text('🌟', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${isArabic ? 'أفضل يوم: ' : 'Best day: '}${data.bestDayTitle}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            if (deficitSummary.totalNetKcal > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'عجز الأسبوع ≈ ${FatEquivalent.formatAmount(FatEquivalent.gramsFromKcal(deficitSummary.totalNetKcal), languageCode: 'ar')} دهون'
                            : 'This week\'s deficit ≈ ${FatEquivalent.formatAmount(FatEquivalent.gramsFromKcal(deficitSummary.totalNetKcal), languageCode: 'en')} fat',
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // AI Coach Tip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEF5350).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEF5350).withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🤖', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'نصيحة المدرب الذكي' : 'AI Coach Tip',
                          style: const TextStyle(
                            color: Color(0xFFEF5350),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.aiCoachTip,
                          style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ),
              Icon(icon, color: color, size: 14),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
          ),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color.withValues(alpha: 0.9), fontSize: 9),
          ),
        ],
      ),
    );
  }
}
