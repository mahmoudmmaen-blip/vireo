import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/core/widgets/rewarded_unlock_sheet.dart';
import 'package:vireo/core/widgets/vireo_ad_widgets.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/diet_programs/screens/diet_program_detail_screen.dart';
import 'package:vireo/features/diet_programs/screens/diet_quiz_screen.dart';
import 'package:vireo/features/diet_programs/domain/cuisine_type.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

class DietProgramsScreen extends ConsumerWidget {
  const DietProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final colors = context.vireoColors;
    final ranked = ref.watch(rankedProgramsProvider);
    final active = ref.watch(activeDietProgramProvider);
    final isPro = ref.watch(isProUserProvider);

    return FeatureScaffold(
      title: l10n.dietProgramsTitle,
      actions: [
        IconButton(
          tooltip: l10n.cuisineSettingTitle,
          icon: const Icon(Icons.restaurant_menu_rounded),
          onPressed: () => _showCuisineSelector(context, ref, l10n),
        ),
        IconButton(
          tooltip: l10n.dietQuizTitle,
          icon: const Icon(Icons.quiz_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DietQuizScreen()),
          ),
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(VSpace.md, VSpace.sm, VSpace.md, VSpace.xxl),
              itemCount: ranked.length,
        itemBuilder: (context, i) {
          final item = ranked[i];
          final p = item.program;
          final isActive = active?.id == p.id;
          final isUnlocked = FeatureGates.isDietProgramUnlocked(p.id, isPro: isPro);

          return FadeSlideIn(
            index: i,
            onceId: 'diet_$i',
            child: Padding(
              padding: const EdgeInsets.only(bottom: VSpace.sm),
              child: VireoCard(
                onTap: () async {
                  if (!isUnlocked) {
                    final isArabic = lang.startsWith('ar');
                    await showRewardedUnlockSheet(
                      context: context,
                      featureTitle: isArabic ? 'فتح برنامج ${p.name.of(lang)}' : 'Unlock ${p.name.of(lang)}',
                      featureDescription: isArabic
                          ? 'شاهد إعلان قصير لتجربة هذا النظام الغذائي لمدة 24 ساعة، أو اشترك في Pro للوصول الدائم.'
                          : 'Watch a short ad to unlock this diet program for 24 hours, or subscribe to Pro.',
                      onUnlockGranted: () async {
                        await FeatureGates.grantRewardedDietProgram(p.id);
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DietProgramDetailScreen(programId: p.id),
                            ),
                          );
                        }
                      },
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DietProgramDetailScreen(programId: p.id),
                    ),
                  );
                },
                glow: item.isRecommended ? colors.ember : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(p.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: VSpace.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name.of(lang),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                p.tagline.of(lang),
                                style: TextStyle(
                                  color: colors.textMute,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isActive)
                          VireoPill(
                            label: l10n.dietActiveBadge,
                            color: colors.success,
                            filled: true,
                          )
                        else if (!isUnlocked)
                          VireoPill(
                            label: 'PRO',
                            icon: Icons.lock_outline,
                            color: colors.gold,
                            filled: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: VSpace.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (item.isRecommended)
                          VireoPill(
                            label: l10n.dietRecommendedBadge,
                            icon: Icons.star_rounded,
                            color: colors.ember,
                          ),
                        _DifficultyDots(level: p.difficulty, colors: colors),
                        VireoPill(
                          label: l10n.dietCardMacros(
                            item.targets.calories,
                            item.targets.proteinG,
                          ),
                          color: colors.textMute,
                        ),
                        VireoPill(
                          label: l10n.dietProgramFitReason(_fitReason(p.id, lang)),
                          icon: Icons.check_circle_outline_rounded,
                          color: colors.success,
                        ),
                        if (item.targets.deficitKcal > 0 || item.targets.weeklyLossKg > 0)
                          FatEquivalentBadge(
                            customText: FatEquivalent.dietPlanRateText(
                              dailyDeficitKcal: item.targets.deficitKcal,
                              weeklyLossKg: item.targets.weeklyLossKg,
                              l10n: l10n,
                              lang: lang,
                            ),
                            style: TextStyle(
                              color: isActive ? colors.success : colors.ember,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                            showIcon: false,
                          ),
                        if (item.eligibility.status ==
                            EligibilityStatus.doctorRequired)
                          VireoPill(
                            label: l10n.dietNeedsDoctor,
                            icon: Icons.lock_outline,
                            color: colors.danger,
                          ),
                        if (item.eligibility.status == EligibilityStatus.caution)
                          VireoPill(
                            label: l10n.dietReadWarning,
                            icon: Icons.warning_amber_rounded,
                            color: colors.gold,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
    const VireoBannerAdWidget(),
  ],
),
);
  }
}

class _DifficultyDots extends StatelessWidget {
  const _DifficultyDots({required this.level, required this.colors});

  final int level;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsetsDirectional.only(end: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < level ? colors.ember : colors.line,
          ),
        );
      }),
    );
  }
}

String _fitReason(DietProgramId id, String lang) {
  final isAr = lang.startsWith('ar');
  return switch (id) {
    DietProgramId.balancedDeficit =>
      isAr ? 'خسارة دهون مستدامة بأقل حرمان' : 'Sustainable fat loss with flexibility',
    DietProgramId.highProtein =>
      isAr ? 'حرق الدهون وبناء ونحت العضلات' : 'Maximum muscle retention & satiety',
    DietProgramId.intermittentFasting =>
      isAr ? 'تنظيم الهرمونات والتحكم في الشهية' : 'Appetite control & metabolic rhythm',
    DietProgramId.lowCarb =>
      isAr ? 'تقليل احتباس السوائل وسرعة النزول' : 'Reduced water retention & steady energy',
    DietProgramId.keto =>
      isAr ? 'حرق مخزون الدهون العنيدة بكفاءة' : 'Deep nutritional ketosis',
    DietProgramId.fastingLowCarb =>
      isAr ? 'مضاعفة حرق الدهون وتنظيم الأنسولين' : 'Accelerated fat mobilization',
    DietProgramId.egyptianClean =>
      isAr ? 'أكلات بيتك المصرية بأسلوب صحي محسوب' : 'Wholesome local Egyptian cuisine',
  };
}

void _showCuisineSelector(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
  final colors = context.vireoColors;
  final current = ref.read(cuisineProvider);

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  l10n.cuisineSettingTitle,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: CuisineType.values.map((c) {
                    final selected = c == current;
                    return ListTile(
                      title: Text(
                        c.localizedName(l10n),
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: selected ? colors.ember : colors.text,
                        ),
                      ),
                      trailing: selected
                          ? Icon(Icons.check_rounded, color: colors.ember)
                          : null,
                      onTap: () {
                        ref.read(cuisineProvider.notifier).setCuisine(c);
                        Navigator.of(ctx).pop();
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
