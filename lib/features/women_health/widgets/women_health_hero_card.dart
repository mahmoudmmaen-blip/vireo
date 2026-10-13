import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/women_health/models/cycle_data.dart';
import 'package:vireo/features/women_health/providers/women_health_provider.dart';
import 'package:vireo/features/women_health/screens/women_health_screen.dart';

class WomenHealthHeroCard extends ConsumerWidget {
  const WomenHealthHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final mode = ref.watch(womenHealthModeProvider);
    final trimester = ref.watch(pregnancyTrimesterProvider);
    final currentPhase = ref.watch(currentCyclePhaseProvider);
    final daysUntilNext = ref.watch(daysUntilNextPeriodProvider);
    final latestEntry = ref.watch(latestCycleEntryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Pressable(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const WomenHealthScreen()),
          );
        },
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
              // Header Row: Icon + Title + Status chip
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      color: Color(0xFFF43F5E),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'صحتك' : 'Women\'s Health',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          mode == WomenMode.pregnant
                              ? (isArabic ? 'وضع الحمل' : 'Pregnancy mode')
                              : mode == WomenMode.breastfeeding
                                  ? (isArabic ? 'وضع الرضاعة' : 'Breastfeeding mode')
                                  : (currentPhase?.displayNameAr ??
                                      (isArabic ? 'متابعة الدورة الشهرية' : 'Cycle Tracking')),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMute,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mode Specific Content
              if (mode == WomenMode.pregnant) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.child_care_rounded, color: colors.gold, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic
                              ? '${trimester.displayNameAr} · تم إلغاء عجز السعرات (+${trimester.surplusKcal} سعرة). استشيري طبيبتك دائماً.'
                              : '${trimester.name} trimester · Calorie deficit disabled (+${trimester.surplusKcal} kcal). Consult your doctor.',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (mode == WomenMode.breastfeeding) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.favorite_rounded, color: colors.ember, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'وضع الرضاعة الطبيعية · تم ضبط +350 سعرة لدعم الرضاعة وصحتك. استشيري طبيبتك.'
                              : 'Breastfeeding mode · Added +350 kcal for milk supply. Consult your doctor.',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (latestEntry != null && currentPhase != null) ...[
                // Cycle phase guidance
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isArabic ? currentPhase.displayNameAr : currentPhase.displayNameEn,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF43F5E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (daysUntilNext != null)
                      Text(
                        isArabic
                            ? 'باقي $daysUntilNext يوم على الدورة القادمة'
                            : '$daysUntilNext days to next cycle',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMute,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Phase-aware tip
                Text(
                  _phaseTip(currentPhase, isArabic),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: colors.text,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),
                // Nutrient chips: Iron, Calcium, Folate
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _NutrientChip(label: isArabic ? 'حديد: سبانخ وعدس' : 'Iron', icon: Icons.grass_rounded),
                    _NutrientChip(label: isArabic ? 'كالسيوم: لبن وسمسم' : 'Calcium', icon: Icons.local_drink_rounded),
                    _NutrientChip(label: isArabic ? 'فولات: خضار ورقي' : 'Folate', icon: Icons.energy_savings_leaf_rounded),
                  ],
                ),
              ] else ...[
                Text(
                  isArabic
                      ? 'سجّلي موعد دورتك لمتابعة مراحل الهرمونات، نصائح التغذية الذكية، وضبط الميزان بخصوصية تامة محلياً.'
                      : 'Track your cycle to get hormone phase tips, smart nutrition, and private scale tracking.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: colors.textMute,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      isArabic ? 'سجّلي الآن ←' : 'Log now →',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: colors.ember,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _phaseTip(CyclePhase phase, bool isArabic) =>
      isArabic ? phase.tipBodyAr : phase.tipBodyEn;
}

class _NutrientChip extends StatelessWidget {
  const _NutrientChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colors.ember),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.textMute),
          ),
        ],
      ),
    );
  }
}
