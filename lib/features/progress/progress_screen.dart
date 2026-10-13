import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/animated_backgrounds.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/activity/screens/health_hub_screen.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';
import 'package:vireo/features/progress/providers/weekly_deficit_provider.dart';
import 'package:vireo/features/progress/screens/weekly_progress_report_screen.dart';
import 'package:vireo/features/progress/screens/weekly_wrapped_story_screen.dart';
import 'package:vireo/features/progress/widgets/achievements_grid_card.dart';
import 'package:vireo/features/progress/widgets/adherence_bar_chart.dart';
import 'package:vireo/features/progress/widgets/adaptive_calorie_suggestion_card.dart';
import 'package:vireo/features/progress/widgets/body_composition_progress_section.dart';
import 'package:vireo/features/progress/widgets/body_measurements_section.dart';
import 'package:vireo/features/progress/widgets/energy_line_chart.dart';
import 'package:vireo/features/progress/widgets/progress_photos_section.dart';
import 'package:vireo/features/progress/widgets/weekly_deficit_chart.dart';
import 'package:vireo/features/progress/widgets/weight_trend_chart_card.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/vireo_ad_widgets.dart';
import 'package:vireo/features/social/screens/social_hub_screen.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final unit = ref.watch(unitPreferenceProvider);
    final logsAsync = ref.watch(weightLogsProvider);
    final goalAsync = ref.watch(weightGoalProvider);
    final weeksAsync = ref.watch(adherenceWeeksProvider);
    final energyAsync = ref.watch(energyCheckInsProvider);
    final deficit = ref.watch(weeklyDeficitProvider);
    final trendAnalysis = ref.watch(weightTrendAnalysisProvider);
    final showAdaptive = ref.watch(showAdaptiveCalorieCardProvider);

    return GradientMeshBackground(
      child: FeatureScaffold(
        title: l10n.progressTitle,
        transparentBackground: true,
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(weightLogsProvider);
                  ref.invalidate(weightGoalProvider);
                  ref.invalidate(adherenceWeeksProvider);
                  ref.invalidate(energyCheckInsProvider);
                  ref.invalidate(weeklyDeficitProvider);
                  ref.invalidate(weeklyProgressReportDataProvider);
                  await Future<void>.delayed(const Duration(milliseconds: 400));
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // ── Quick Links: Weekly Report, Weekly Wrapped, Health Hub, InBody ──
              Row(
                children: [
                  Expanded(
                    child: VireoCard(
                      onTap: () {
                        if (!FeatureGates.requirePro(context, ref, force: true)) return;
                        WeeklyProgressReportScreen.open(context);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.vireoColors.ember.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.assessment_outlined, color: context.vireoColors.ember),
                          ),
                          const SizedBox(width: VSpace.xs),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.weeklyReportTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  l10n.weeklyReportSubtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.vireoColors.textMute,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: VireoCard(
                      onTap: () => WeeklyWrappedStoryScreen.open(context),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF97316).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🎁', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: VSpace.xs),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Localizations.localeOf(context).languageCode.startsWith('ar') ? 'ملخص الأسبوع' : 'Weekly Wrapped',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  Localizations.localeOf(context).languageCode.startsWith('ar') ? 'شارك إنجازاتك' : 'Share stories',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.vireoColors.textMute,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: VireoCard(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const HealthHubScreen()),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.favorite_outline, color: context.vireoColors.ember, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.healthHubTitle,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  'Metrics & sleep',
                                  style: TextStyle(color: context.vireoColors.textMute, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: VireoCard(
                      onTap: () => BodyCompositionScreen.open(context),
                      child: Row(
                        children: [
                          Icon(Icons.accessibility_new, color: context.vireoColors.ember, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.inbodyBodyTitle,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  'InBody Scan',
                                  style: TextStyle(color: context.vireoColors.textMute, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              VireoCard(
                onTap: () => SocialHubScreen.open(context),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.people_outline, color: Color(0xFF22C55E)),
                    ),
                    const SizedBox(width: VSpace.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.startsWith('ar') ? 'المجتمع والمنافسات' : 'Community & Challenges',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            locale.startsWith('ar')
                                ? 'تنافس بالخطوات مع الأصدقاء والعائلة بأمان تام'
                                : 'Step challenges with friends & family (privacy-first)',
                            style: TextStyle(
                              color: context.vireoColors.textMute,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: context.vireoColors.textMute),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── 2. ADAPTIVE CALORIES (Card if suggestion eligible) ──
              if (showAdaptive) ...[
                const AdaptiveCalorieSuggestionCard(),
                const SizedBox(height: 16),
              ],

              // ── 1. WEIGHT TREND (EMA 0.1, Raw dots, 7d/30d change headline) ──
              logsAsync.when(
                loading: () => const _ChartLoading(),
                error: (_, _) => _ChartError(message: l10n.authErrorGeneric),
                data: (logs) {
                  return WeightTrendChartCard(
                    logs: logs,
                    analysis: trendAnalysis,
                    goalKg: goalAsync.valueOrNull,
                    unit: unit,
                  );
                },
              ),
              const SizedBox(height: 16),

              // ── 5. ACHIEVEMENTS & BADGES ──
              const AchievementsGridCard(),
              const SizedBox(height: 16),

              // ── BODY COMPOSITION ("تحليل الجسم") ──
              const BodyCompositionProgressSection(),
              const SizedBox(height: 16),

              // ── 4. BODY: Circumference Charts (waist, chest, arms, thighs) ──
              const BodyMeasurementsSection(),
              const SizedBox(height: 16),

              // ── 4. BODY: Progress Photos (front/side/back, local-only, side-by-side) ──
              const ProgressPhotosSection(),
              const SizedBox(height: 16),

              // ── Calorie Deficit Balance ──
              _ChartCard(
                title: l10n.weeklyDeficitChartTitle,
                subtitle: l10n.weeklyDeficitSubtitle,
                child: WeeklyDeficitChart(summary: deficit),
              ),
              const SizedBox(height: 16),

              // ── Weekly Adherence ──
              weeksAsync.when(
                loading: () => const _ChartLoading(),
                error: (_, _) => _ChartError(message: l10n.authErrorGeneric),
                data: (weeks) => _ChartCard(
                  title: l10n.progressAdherenceChartTitle,
                  subtitle: l10n.progressAdherenceSubtitle,
                  child: AdherenceBarChart(weeks: weeks),
                ),
              ),
              const SizedBox(height: 16),

              // ── Energy Levels ──
              energyAsync.when(
                loading: () => const _ChartLoading(),
                error: (_, _) => _ChartError(message: l10n.authErrorGeneric),
                data: (checkIns) => _ChartCard(
                  title: l10n.progressEnergyChartTitle,
                  subtitle: l10n.progressEnergySubtitle,
                  child: EnergyLineChart(
                    checkIns: checkIns,
                    energyAxisLabel: l10n.progressAxisEnergy,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const VireoBannerAdWidget(),
    ],
  ),
),
);
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ChartLoading extends StatelessWidget {
  const _ChartLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ChartError extends StatelessWidget {
  const _ChartError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(child: Text(message)),
    );
  }
}
