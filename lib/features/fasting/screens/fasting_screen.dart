import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/fasting/domain/fasting_plan.dart';
import 'package:vireo/features/fasting/domain/fasting_session.dart';
import 'package:vireo/features/fasting/domain/fasting_stage.dart';
import 'package:vireo/features/fasting/providers/fasting_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class FastingScreen extends ConsumerStatefulWidget {
  const FastingScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FastingScreen()),
    );
  }

  @override
  ConsumerState<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends ConsumerState<FastingScreen> with SingleTickerProviderStateMixin {
  Timer? _ticker;
  bool _isOptimisticActionRunning = false;

  @override
  void initState() {
    super.initState();
    // Ticker updates timer display once every second
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _handleStartFast(bool isArabic) async {
    final state = ref.read(fastingProvider);
    final safety = state.safety;

    // Safety contraindications warning
    if (safety.hasContraindications) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(isArabic ? 'تنبيه صحي هام ⚠️' : 'Health Warning ⚠️'),
          content: Text(safety.getWarningMessage(isArabic)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isArabic ? 'المتابعة على مسؤوليتي' : 'Proceed Anyway'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    if (!mounted) return;

    // Custom fast > 24 hours confirmation
    final targetH = state.selectedPlan == FastingPlanType.custom
        ? state.customHours
        : state.selectedPlan.defaultFastHours;

    if (targetH > 24 && !safety.confirmedLongFastDoctorAdvice) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(isArabic ? 'استشر طبيبك أولاً 🩺' : 'Consult Your Doctor 🩺'),
          content: Text(
            isArabic
                ? 'الصيام المستمر لأكثر من 24 ساعة يتطلب متابعة طبية للتأكد من توازن الأملاح والسوائل وصحة الكلى. هل استشرت طبيبك؟'
                : 'Fasting beyond 24 consecutive hours requires medical supervision. Have you consulted a physician?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isArabic ? 'نعم، أؤكد المتابعة' : 'Yes, Confirm'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() => _isOptimisticActionRunning = true);
    HapticFeedback.mediumImpact();
    await ref.read(fastingProvider.notifier).startFast(isArabic: isArabic);
    if (mounted) setState(() => _isOptimisticActionRunning = false);
  }

  Future<void> _handleEndFast(bool isArabic) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'إنهاء الصيام؟' : 'End Fast?'),
        content: Text(
          isArabic
              ? 'هل ترغب في إنهاء الصيام الآن وبدء نافذة تناول الطعام؟'
              : 'Do you want to end your fast now and begin your eating window?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(isArabic ? 'متابعة الصيام' : 'Keep Fasting'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(isArabic ? 'إنهاء الصيام' : 'End Fast'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isOptimisticActionRunning = true);
    HapticFeedback.heavyImpact();
    final coins = await ref.read(fastingProvider.notifier).endFast(isArabic: isArabic);
    if (mounted) {
      setState(() => _isOptimisticActionRunning = false);
      if (coins > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: VBridge.cFF10B981,
            content: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'مبروك! أتممت الصيام وحصلت على +$coins عملة 🪙'
                        : 'Great job! Fast completed, +$coins coins awarded 🪙',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleEditStartTime(BuildContext context, FastingSession session, bool isArabic) async {
    final now = DateTime.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(session.startTime),
      helpText: isArabic ? 'اختر وقت بدء الصيام الفعلي' : 'Select actual fast start time',
    );

    if (pickedTime == null) return;

    var newStart = DateTime(
      session.startTime.year,
      session.startTime.month,
      session.startTime.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // If selected time is in future compared to now, assume it was yesterday
    if (newStart.isAfter(now)) {
      newStart = newStart.subtract(const Duration(days: 1));
    }

    HapticFeedback.selectionClick();
    await ref.read(fastingProvider.notifier).editStartTime(newStart, isArabic: isArabic);
  }

  void _showPlanPicker(BuildContext context, bool isArabic) {
    final colors = context.vireoColors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(fastingProvider);
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.line,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isArabic ? 'اختر خطة الصيام المتقطع' : 'Select Fasting Plan',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.ember.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isArabic ? 'علمي وموثق' : 'Evidence-based',
                          style: TextStyle(
                            color: colors.ember,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (final plan in FastingPlanType.values) ...[
                    InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(fastingProvider.notifier).selectPlan(plan);
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: state.selectedPlan == plan
                              ? colors.ember.withValues(alpha: 0.12)
                              : colors.surfaceRaised,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: state.selectedPlan == plan ? colors.ember : colors.line,
                            width: state.selectedPlan == plan ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: plan.isBeginner
                                    ? VBridge.cFF10B981.withValues(alpha: 0.2)
                                    : colors.surface,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                plan.code,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: plan.isBeginner ? VBridge.cFF10B981 : colors.text,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        plan.displayName(isArabic),
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                      ),
                                      if (plan.isBeginner) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: VBridge.cFF10B981.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isArabic ? 'موصى به للمبتدئين' : 'Recommended',
                                            style: const TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700,
                                              color: VBridge.cFF10B981,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isArabic ? plan.descriptionAr : plan.nameEn,
                                    style: TextStyle(
                                      color: colors.textMute,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.selectedPlan == plan)
                              Icon(Icons.check_circle_rounded, color: colors.ember, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final state = ref.watch(fastingProvider);
    final session = state.activeSession;
    final isFasting = session != null && session.isActive;

    final elapsed = isFasting ? session.elapsed : Duration.zero;
    final remaining = isFasting ? session.remaining : Duration(hours: state.selectedPlan.defaultFastHours);
    final progress = isFasting ? session.progressRatio : 0.0;
    final stage = isFasting ? session.currentStage : FastingStage.anabolic;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isArabic ? 'مؤقت الصيام المتقطع' : 'Intermittent Fasting'),
        actions: [
          IconButton(
            tooltip: isArabic ? 'تغيير الخطة' : 'Change Plan',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showPlanPicker(context, isArabic),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Ramadan Sync Banner (if active)
              if (state.isRamadanSync) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.success.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.nights_stay_rounded, color: colors.success, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'متزامن تلقائياً مع مواقيت الفجر والمغرب في رمضان 🌙'
                              : 'Auto-synced with Ramadan Fajr & Maghrib schedule 🌙',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Safety warning banner (if any)
              if (state.safety.hasContraindications) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.danger.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.danger.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: colors.danger, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.safety.getWarningMessage(isArabic),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Plan badge & Selector Trigger
              InkWell(
                onTap: () => _showPlanPicker(context, isArabic),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_filled_rounded, size: 15, color: colors.ember),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          state.selectedPlan.displayName(isArabic),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── BIG CIRCULAR TIMER ──
              SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(250, 250),
                      painter: _FastingRingPainter(
                        progress: progress,
                        stageColor: stage.accentColor,
                        bgColor: colors.line.withValues(alpha: 0.4),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isFasting ? (isArabic ? 'وقت الصيام المار' : 'Elapsed Time') : (isArabic ? 'الهدف' : 'Target'),
                          style: TextStyle(
                            color: colors.textMute,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isFasting
                              ? _formatDuration(elapsed)
                              : '${state.selectedPlan.defaultFastHours}h 00m',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: isFasting ? colors.text : colors.textMute,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isFasting) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: stage.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              stage.title(isArabic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: stage.accentColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic
                                ? (remaining > Duration.zero
                                    ? 'متبقي: ${_formatDuration(remaining)}'
                                    : 'أكملت الهدف بنجاح! 🎉')
                                : (remaining > Duration.zero
                                    ? 'Remaining: ${_formatDuration(remaining)}'
                                    : 'Goal reached! 🎉'),
                            style: TextStyle(
                              color: colors.textMute,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ] else ...[
                          Text(
                            isArabic ? 'جاهز للبدء' : 'Ready to start',
                            style: TextStyle(color: colors.textMute, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── PRIMARY ACTION BUTTON (Start / End Fast) ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: isFasting ? VBridge.cFFEF4444 : colors.ember,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _isOptimisticActionRunning
                      ? null
                      : () => isFasting ? _handleEndFast(isArabic) : _handleStartFast(isArabic),
                  icon: Icon(isFasting ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 24),
                  label: Text(
                    isFasting
                        ? (isArabic ? 'إنهاء الصيام' : 'End Fast')
                        : (isArabic ? 'بدء الصيام الآن' : 'Start Fasting Now'),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),

              // "تعديل وقت البدء" button
              if (isFasting) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _handleEditStartTime(context, session, isArabic),
                  icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                  label: Text(
                    isArabic ? 'تعديل وقت البدء (بدأت من ساعتين مثلاً)' : 'Edit Start Time',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // ── SCIENTIFIC STAGE DETAIL CARD ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.line.withValues(alpha: 0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: stage.accentColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.biotech_rounded, color: stage.accentColor, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'مرحلة الجسم الحالية (علمياً)' : 'Current Biological Stage',
                                style: TextStyle(
                                  color: colors.textMute,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                stage.title(isArabic),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  color: stage.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.surfaceRaised,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            stage.badgeLabel(isArabic),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      stage.science(isArabic),
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: colors.text,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── STAGES TIMELINE OVERVIEW ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final st in FastingStage.values)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: st == stage
                              ? st.accentColor.withValues(alpha: 0.2)
                              : colors.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: st == stage ? st.accentColor : colors.line,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${st.startHour}h',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: st == stage ? st.accentColor : colors.textMute,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: st == stage ? st.accentColor : colors.line,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // ── STATS & HISTORY HEADER ──
              Row(
                children: [
                  Expanded(
                    child: _FastingStatCard(
                      title: isArabic ? 'السلسلة الحالية' : 'Streak',
                      value: '${state.currentStreak} 🔥',
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FastingStatCard(
                      title: isArabic ? 'صيام مكتمل' : 'Completed',
                      value: '${state.completedCount} ⭐',
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FastingStatCard(
                      title: isArabic ? 'أطول صيام' : 'Longest',
                      value: '${state.longestFastHours.toStringAsFixed(1)}h',
                      colors: colors,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Weekly History Chart
              _FastingWeeklyChart(
                history: state.history,
                isArabic: isArabic,
                colors: colors,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FastingRingPainter extends CustomPainter {
  const _FastingRingPainter({
    required this.progress,
    required this.stageColor,
    required this.bgColor,
  });

  final double progress;
  final Color stageColor;
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = stageColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweep = 2 * math.pi * progress.clamp(0.0, 1.0);
    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweep,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FastingRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.stageColor != stageColor;
  }
}

class _FastingStatCard extends StatelessWidget {
  const _FastingStatCard({
    required this.title,
    required this.value,
    required this.colors,
  });

  final String title;
  final String value;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.5, color: colors.textMute, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _FastingWeeklyChart extends StatelessWidget {
  const _FastingWeeklyChart({
    required this.history,
    required this.isArabic,
    required this.colors,
  });

  final List<FastingSession> history;
  final bool isArabic;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayNamesAr = ['إث', 'ثل', 'أر', 'خم', 'جم', 'سب', 'أح'];
    final dayNamesEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Map last 7 days hours
    final weekData = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      final completed = history.where((s) =>
          s.isCompleted &&
          s.startTime.year == d.year &&
          s.startTime.month == d.month &&
          s.startTime.day == d.day);
      final hours = completed.fold<double>(0.0, (sum, s) => sum + (s.elapsed.inMinutes / 60.0));
      return (d, hours);
    });

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  isArabic ? 'سجل الصيام الأسبوعي' : 'Weekly Fasting Log',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Builder(
                  builder: (context) {
                    final item = weekData[i];
                    final hours = item.$2;
                    final height = (hours / 24.0 * 80).clamp(4.0, 80.0);
                    final isToday = i == 6;
                    final dayLabel = isArabic
                        ? dayNamesAr[(item.$1.weekday - 1) % 7]
                        : dayNamesEn[(item.$1.weekday - 1) % 7];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hours > 0)
                          Text(
                            '${hours.round()}h',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: colors.ember,
                            ),
                          )
                        else
                          const SizedBox(height: 12),
                        const SizedBox(height: 4),
                        Container(
                          width: 18,
                          height: height,
                          decoration: BoxDecoration(
                            color: hours >= 12
                                ? colors.ember
                                : (hours > 0 ? colors.ember.withValues(alpha: 0.4) : colors.line),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dayLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                            color: isToday ? colors.text : colors.textMute,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
