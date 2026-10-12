import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/walking/walking_tracker_screen.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';

/// "الخطوة الجاية" — ONE smart contextual next-action card for Home.
/// Examples:
/// - "باقي 40 جم بروتين — سجّل غداك"
/// - "ما شربتش مية من فترة — اشرب كوباية"
/// - "حان وقت تمرين اليوم — ابدأ الآن"
/// - "باقي 2,500 خطوة لتحقيق هدفك اليومي"
class SmartNextActionCard extends ConsumerWidget {
  const SmartNextActionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final score = ref.watch(dailyScoreProvider);
    final nutrition = ref.watch(todayNutritionProvider(isArabic ? 'ar' : 'en'));

    // 1. Check protein deficit
    final proteinDiff = (nutrition.proteinTarget - nutrition.proteinG).round();
    if (proteinDiff > 25) {
      return _ActionCardLayout(
        icon: Icons.restaurant_rounded,
        iconColor: colors.ember,
        title: isArabic ? 'الخطوة الجاية' : 'Next Step',
        headline: isArabic
            ? 'باقي $proteinDiff جم بروتين — سجّل وجبتك'
            : '$proteinDiff g protein remaining — log your meal',
        actionLabel: isArabic ? 'سجّل وجبة' : 'Log meal',
        onTap: () => AiScanScreen.open(context, ref, fromCamera: true),
      );
    }

    // 2. Check workout
    if (score.workoutScore < 15.0) {
      return _ActionCardLayout(
        icon: Icons.fitness_center_rounded,
        iconColor: colors.ember,
        title: isArabic ? 'الخطوة الجاية' : 'Next Step',
        headline: isArabic
            ? 'حان وقت تمرين اليوم — ابدأ جلستك'
            : 'Time for today\'s workout — start now',
        actionLabel: isArabic ? 'ابدأ التمرين' : 'Start workout',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const WorkoutFlowScreen()),
        ),
      );
    }

    // 3. Check water
    if (score.waterScore < 15.0) {
      return _ActionCardLayout(
        icon: Icons.water_drop_rounded,
        iconColor: VMacro.water,
        title: isArabic ? 'الخطوة الجاية' : 'Next Step',
        headline: isArabic
            ? 'روّي جسمك — اشرب كوب ماء (+250 مل)'
            : 'Hydrate your body — drink a glass (+250 ml)',
        actionLabel: isArabic ? '+250 مل' : '+250 ml',
        onTap: () async {
          await ref.read(waterTrackerProvider.notifier).addGlass();
        },
      );
    }

    // 4. Fallback: Movement / steps
    return _ActionCardLayout(
      icon: Icons.directions_walk_rounded,
      iconColor: const Color(0xFF10B981),
      title: isArabic ? 'الخطوة الجاية' : 'Next Step',
      headline: isArabic
          ? 'كمّل خطواتك اليومية لنشاط وحرق أعلى'
          : 'Complete your daily steps for energy & burn',
      actionLabel: isArabic ? 'المشي' : 'Walk',
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const WalkingTrackerScreen()),
      ),
    );
  }
}

class _ActionCardLayout extends StatelessWidget {
  const _ActionCardLayout({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.headline,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String headline;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return VireoCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.sm + 4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textMute,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  headline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
