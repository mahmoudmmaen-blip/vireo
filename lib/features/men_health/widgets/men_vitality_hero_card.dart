import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/men_health/providers/men_vitality_provider.dart';

class MenVitalityHeroCard extends ConsumerWidget {
  const MenVitalityHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final habits = ref.watch(menVitalityHabitsProvider);
    final score = ref.watch(menVitalityScoreProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(color: colors.line.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + Weekly Score Badge
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: colors.ember,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'صحة الرجل والحيوية' : 'Men\'s Health & Vitality',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        isArabic ? 'عادات يومية تدعم النشاط والهرمونات الطبيعية' : 'Daily habits for natural vitality',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMute,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: colors.ember,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'نقطة' : 'pts',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.textMute,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Habits grid / chips row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _VitalityHabitPill(
                  label: isArabic ? 'نوم ٧-٩ س' : 'Sleep 7-9h',
                  done: habits.isSleepOptimal,
                  icon: Icons.bedtime_rounded,
                ),
                _VitalityHabitPill(
                  label: isArabic ? 'مقاومة ٣x/أسبوع' : 'Lift 3x/wk',
                  done: habits.isResistanceOptimal,
                  icon: Icons.fitness_center_rounded,
                ),
                _VitalityHabitPill(
                  label: isArabic ? 'شمس ١٥ د' : 'Sun 15m',
                  done: habits.isSunlightOptimal,
                  icon: Icons.wb_sunny_rounded,
                ),
                _VitalityHabitPill(
                  label: isArabic ? 'زنك ود 🥦' : 'Zinc & Vit D',
                  done: habits.zincVitDLogged,
                  icon: Icons.restaurant_rounded,
                ),
                _VitalityHabitPill(
                  label: isArabic ? 'بروتين كامل 💪' : 'Protein Met',
                  done: habits.proteinTargetMet,
                  icon: Icons.shield_rounded,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Food DB suggestion note
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.line.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: colors.gold, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'أطعمة غنية بالزنك وفيتامين د: بيض كامل، لحم بقري، بذور القرع، سلمون وسردين.'
                          : 'Rich in zinc & vit D: whole eggs, lean beef, pumpkin seeds, salmon.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.textMute,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Medical Disclaimer
            Text(
              isArabic
                  ? 'إرشادات عامة لنمط حياة صحي يدعم الحيوية، وليست نصيحة طبية أو علاجاً لنقص الهرمونات.'
                  : 'General lifestyle coaching for natural vitality. Not medical advice or hormone treatment.',
              style: TextStyle(
                fontSize: 10.5,
                color: colors.textMute.withValues(alpha: 0.75),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalityHabitPill extends StatelessWidget {
  const _VitalityHabitPill({
    required this.label,
    required this.done,
    required this.icon,
  });

  final String label;
  final bool done;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final activeColor = done ? colors.ember : colors.textMute;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: done ? colors.ember.withValues(alpha: 0.12) : colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: done ? colors.ember.withValues(alpha: 0.4) : colors.line.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: activeColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: done ? FontWeight.w800 : FontWeight.w600,
              color: done ? colors.text : colors.textMute,
            ),
          ),
          if (done) ...[
            const SizedBox(width: 4),
            Icon(Icons.check_circle_rounded, size: 12, color: colors.ember),
          ],
        ],
      ),
    );
  }
}
