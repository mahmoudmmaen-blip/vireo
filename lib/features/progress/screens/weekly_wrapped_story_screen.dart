import 'dart:io';
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/features/progress/domain/weekly_progress_report_data.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';

class WeeklyWrappedStoryScreen extends ConsumerStatefulWidget {
  const WeeklyWrappedStoryScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const WeeklyWrappedStoryScreen()),
    );
  }

  @override
  ConsumerState<WeeklyWrappedStoryScreen> createState() => _WeeklyWrappedStoryScreenState();
}

class _WeeklyWrappedStoryScreenState extends ConsumerState<WeeklyWrappedStoryScreen> {
  final PageController _pageController = PageController();
  final GlobalKey _shareCardKey = GlobalKey();
  int _currentIndex = 0;
  bool _includeMealsAndWeight = false;
  bool _isSharing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getFunStepComparison(int totalSteps, String lang) {
    // 1 step ≈ 0.75 meters
    final totalMeters = totalSteps * 0.75;
    final isAr = lang.startsWith('ar');

    if (lang.contains('EG') || (isAr && !lang.contains('SA') && !lang.contains('AE'))) {
      // Great Pyramid of Giza height = 138.5 meters
      final pyramidTimes = (totalMeters / 138.5).round();
      // Qasr El Nil bridge length = 382 meters
      final bridgeTimes = (totalMeters / 382).round();
      if (pyramidTimes >= 3) {
        return isAr
            ? 'مشيت $totalSteps خطوة = $pyramidTimes مرات طول الهرم الأكبر 🏛️!'
            : 'You walked $totalSteps steps = $pyramidTimes times the Great Pyramid 🏛️!';
      }
      return isAr
          ? 'مشيت $totalSteps خطوة = $bridgeTimes مرات بطول كوبري قصر النيل 🌉!'
          : 'You walked $totalSteps steps = $bridgeTimes times Qasr El Nil Bridge 🌉!';
    } else if (lang.contains('SA') || lang.contains('AE') || lang.contains('gulf')) {
      // Burj Khalifa height = 828 meters
      final burjTimes = (totalMeters / 828).toStringAsFixed(1);
      return isAr
          ? 'مشيت $totalSteps خطوة = $burjTimes مرات ارتفاع برج خليفة 🏙️!'
          : 'You walked $totalSteps steps = $burjTimes times Burj Khalifa 🏙️!';
    } else {
      // Football pitches: 105 meters
      final pitchCount = (totalMeters / 105).round();
      return isAr
          ? 'مشيت $totalSteps خطوة = مسافة $pitchCount ملعب كرة قدم ⚽!'
          : 'You walked $totalSteps steps = $pitchCount football pitches ⚽!';
    }
  }

  Future<void> _shareWrappedCard() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    HapticFeedback.mediumImpact();

    try {
      final boundary = _shareCardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/vireo_wrapped_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: isAr ? 'ملخص إنجازاتي هذا الأسبوع مع تطبيق Vireo 🎁✨' : 'My Weekly Wrapped on Vireo 🎁✨',
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشلت مشاركة البطاقة، يرجى المحاولة لاحقاً')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).toString();
    final isAr = locale.startsWith('ar');
    final reportAsync = ref.watch(weeklyProgressReportDataProvider);
    final deficitSummary = ref.watch(weeklyDeficitProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => Center(
          child: Text(
            isAr ? 'تعذر تحميل التقرير الأسبوعي' : 'Failed to load report',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (data) {
          final totalBurned = deficitSummary.totalNetKcal > 0 ? deficitSummary.totalNetKcal : (data.avgCalories * 7);
          final fatGramsBurned = FatEquivalent.gramsFromKcal(totalBurned).toDouble();
          final funComparison = _getFunStepComparison(data.totalWeeklySteps, locale);

          final stories = [
            // Slide 1: Intro
            _WrappedStoryPage(
              gradient: const [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              emoji: '🎁',
              title: isAr ? 'ملخص أسبوعك جاهز!' : 'Your Weekly Wrapped!',
              subtitle: isAr ? 'إليك أبرز إنجازاتك الرياضية والصحية هذا الأسبوع' : 'Here are your fitness & health highlights from this week.',
            ),

            // Slide 2: Steps + Fun Comparison
            _WrappedStoryPage(
              gradient: const [Color(0xFF064E3B), Color(0xFF022C22)],
              emoji: '🚶‍♂️',
              title: isAr ? 'إجمالي الخطوات' : 'Total Steps',
              metricValue: '${data.totalWeeklySteps}',
              metricUnit: isAr ? 'خطوة هذا الأسبوع' : 'steps this week',
              subtitle: funComparison,
            ),

            // Slide 3: Calories Burned & Fat Equivalent
            _WrappedStoryPage(
              gradient: const [Color(0xFF7C2D12), Color(0xFF451A03)],
              emoji: '🔥',
              title: isAr ? 'السعرات المحروقة' : 'Calories Burned',
              metricValue: '$totalBurned',
              metricUnit: isAr ? 'سعرة حرارية صافية' : 'net kcal',
              subtitle: isAr
                  ? 'تعادل حرق حوالي ${fatGramsBurned.toStringAsFixed(1)} جم من دهون الجسم!'
                  : 'Equivalent to burning ~${fatGramsBurned.toStringAsFixed(1)}g of body fat!',
            ),

            // Slide 4: Best Day & Streak
            _WrappedStoryPage(
              gradient: const [Color(0xFF581C87), Color(0xFF3B0764)],
              emoji: '⚡',
              title: isAr ? 'أفضل يوم واستمرارية' : 'Best Day & Streak',
              metricValue: '${data.streakDays}',
              metricUnit: isAr ? 'أيام متتالية من الالتزام 🔥' : 'day streak 🔥',
              subtitle: isAr
                  ? 'أفضل أداء لك كان: ${data.bestDayTitle}'
                  : 'Your peak day was: ${data.bestDayTitle}',
            ),

            // Slide 5: Workouts & Protein Goals
            _WrappedStoryPage(
              gradient: const [Color(0xFF1E293B), Color(0xFF0F172A)],
              emoji: '💪',
              title: isAr ? 'التمارين والبروتين' : 'Workouts & Protein',
              metricValue: '${data.totalWorkoutsCompleted}',
              metricUnit: isAr ? 'تمارين تم إنجازها' : 'workouts crushed',
              subtitle: isAr
                  ? 'حققت هدف البروتين في ${data.proteinGoalDays} أيام من أصل 7 أيام!'
                  : 'Hit your protein target on ${data.proteinGoalDays} out of 7 days!',
            ),
          ];

          return SafeArea(
            child: Stack(
              children: [
                // Story Swipe View
                PageView.builder(
                  controller: _pageController,
                  itemCount: stories.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (ctx, i) => stories[i],
                ),

                // Top Progress Indicators
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: List.generate(stories.length, (idx) {
                      return Expanded(
                        child: Container(
                          height: 3.5,
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          decoration: BoxDecoration(
                            color: idx <= _currentIndex ? Colors.white : Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Top Close Button
                Positioned(
                  top: 24,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // Bottom Controls & Share Sheet CTA
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Privacy toggle: Include Meals/Weight
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white60),
                            child: Checkbox(
                              value: _includeMealsAndWeight,
                              activeColor: colors.ember,
                              onChanged: (val) => setState(() => _includeMealsAndWeight = val ?? false),
                            ),
                          ),
                          Text(
                            isAr ? 'تضمين السعرات والوزن في بطاقة المشاركة' : 'Include meals & weight on share card',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.ember,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _isSharing ? null : _shareWrappedCard,
                        icon: _isSharing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.share_rounded),
                        label: Text(
                          isAr ? 'مشاركة بطاقة الإنجاز 🎁' : 'Share Wrapped Card 🎁',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),

                // Offscreen Shareable Card Rendered for 1080x1920 Export
                Positioned(
                  left: -9999,
                  child: RepaintBoundary(
                    key: _shareCardKey,
                    child: _Wrapped1080x1920Card(
                      data: data,
                      totalBurned: totalBurned,
                      fatGramsBurned: fatGramsBurned,
                      funComparison: funComparison,
                      includeMealsAndWeight: _includeMealsAndWeight,
                      isArabic: isAr,
                    ),
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

class _WrappedStoryPage extends StatelessWidget {
  const _WrappedStoryPage({
    required this.gradient,
    required this.emoji,
    required this.title,
    this.metricValue,
    this.metricUnit,
    required this.subtitle,
  });

  final List<Color> gradient;
  final String emoji;
  final String title;
  final String? metricValue;
  final String? metricUnit;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          if (metricValue != null) ...[
            const SizedBox(height: 16),
            Text(
              metricValue!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 54,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (metricUnit != null)
              Text(
                metricUnit!,
                style: const TextStyle(
                  color: Color(0xFFF97316),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standalone 1080×1920 aspect ratio card rendered for sharing
class _Wrapped1080x1920Card extends StatelessWidget {
  const _Wrapped1080x1920Card({
    required this.data,
    required this.totalBurned,
    required this.fatGramsBurned,
    required this.funComparison,
    required this.includeMealsAndWeight,
    required this.isArabic,
  });

  final WeeklyProgressReportData data;
  final int totalBurned;
  final double fatGramsBurned;
  final String funComparison;
  final bool includeMealsAndWeight;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 710, // ~ 9:16 aspect ratio
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF020617), Color(0xFF1E1010)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Branding
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
                  const Text(
                    'VIREO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isArabic ? 'ملخص الأسبوع 🎁' : 'Weekly Wrapped 🎁',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total Steps & fun comparison
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'إجمالي الخطوات' : 'Total Steps',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.totalWeeklySteps}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  funComparison,
                  style: const TextStyle(color: Color(0xFF34D399), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Workouts & Streak
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isArabic ? 'التمارين' : 'Workouts', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${data.totalWorkoutsCompleted}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      Text(isArabic ? 'تم إنجازها' : 'completed', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isArabic ? 'الاستمرارية' : 'Streak', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${data.streakDays}🔥', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      Text(isArabic ? 'أيام متتالية' : 'days streak', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Optional: Calories & Weight (if toggled)
          if (includeMealsAndWeight) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF7C2D12).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF97316).withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isArabic ? 'السعرات المحروقة' : 'Burned', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('$totalBurned kcal', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(isArabic ? 'تغير الوزن' : 'Weight Trend', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('${data.trendWeightChangeKg >= 0 ? '+' : ''}${data.trendWeightChangeKg.toStringAsFixed(1)} kg', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Footer Coach Motto
          const Spacer(),
          Center(
            child: Text(
              isArabic ? 'تطبيق Vireo — شريكك نحو حياة صحية أفضل' : 'Vireo — Your AI Health & Fitness Partner',
              style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}
