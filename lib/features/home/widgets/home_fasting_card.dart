import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/fasting/providers/fasting_provider.dart';
import 'package:vireo/features/fasting/screens/fasting_screen.dart';

class HomeFastingCard extends ConsumerWidget {
  const HomeFastingCard({super.key});

  String _formatElapsed(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final fastingState = ref.watch(fastingProvider);
    final session = fastingState.activeSession;
    final isFasting = session != null && session.isActive;

    if (!isFasting) {
      // Clean compact card inviting to fast or showing selected plan
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(VRadius.md),
          border: Border.all(color: colors.line.withValues(alpha: 0.6)),
        ),
        child: InkWell(
          onTap: () => FastingScreen.open(context),
          borderRadius: BorderRadius.circular(VRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.timer_outlined, color: colors.ember, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              isArabic ? 'الصيام المتقطع' : 'Intermittent Fasting',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: colors.surfaceRaised,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              fastingState.selectedPlan.code,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: colors.textMute,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isArabic
                            ? 'اضغط لبدء صيامك أو متابعة خطتك اليومية'
                            : 'Tap to start your fast or view your plan',
                        style: TextStyle(color: colors.textMute, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.textMute),
              ],
            ),
          ),
        ),
      );
    }

    // Active Fasting Card with live stage & countdown
    final stage = session.currentStage;
    final elapsed = session.elapsed;
    final progress = session.progressRatio.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: stage.accentColor.withValues(alpha: 0.5), width: 1.2),
      ),
      child: InkWell(
        onTap: () => FastingScreen.open(context),
        borderRadius: BorderRadius.circular(VRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Mini progress circle
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: colors.line.withValues(alpha: 0.4),
                      color: stage.accentColor,
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: stage.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            isArabic ? 'أنت صائم حالياً' : 'Fasting Active',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: stage.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              stage.shortTitle(isArabic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: stage.accentColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isArabic
                          ? 'مضى ${_formatElapsed(elapsed)} من هدف ${session.targetHours}h'
                          : '${_formatElapsed(elapsed)} of ${session.targetHours}h target',
                      style: TextStyle(color: colors.textMute, fontSize: 11.5, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.textMute),
            ],
          ),
        ),
      ),
    );
  }
}
