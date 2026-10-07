import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';
import 'package:vireo/features/vitality/presentation/widgets/vitality_score_ring.dart';
import 'package:vireo/features/vitality/providers/vitality_progress_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/vitality/screens/article_detail_screen.dart';
import 'package:vireo/features/vitality/widgets/daily_vitality_checklist.dart';
import 'package:vireo/features/vitality_program/widgets/vitality_program_card.dart';

class VitalityHubScreen extends ConsumerWidget {
  const VitalityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final articles = ref.watch(vitalityContentRepositoryProvider).getArticles();
    final log = ref.watch(vitalityDailyLogProvider);

    final grouped = <VitalityCategory, List<VitalityArticle>>{};
    for (final article in articles) {
      grouped.putIfAbsent(article.category, () => []).add(article);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.vitalityHubTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            l10n.vitalityHubSubtitle,
            style: TextStyle(color: colors.textMute, height: 1.35),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.vitalityArticleCount(articles.length),
            style: TextStyle(
              color: colors.recovery,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.gold.withValues(alpha: 0.3)),
            ),
            child: Text(
              l10n.vitalityArticleDisclaimer,
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.vitality12WeekProgram,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const VitalityProgramCard(),
          const SizedBox(height: 20),
          const VitalityScoreSection(),
          const SizedBox(height: 20),
          Text(l10n.vitalityDailyChecklistTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const DailyVitalityChecklistExpanded(),
          const SizedBox(height: 20),
          Text(l10n.vitalityLogSection,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          _LogTile(
            icon: Icons.bedtime_outlined,
            label: l10n.vitalitySleepLog,
            value: log.sleepHours != null
                ? l10n.vitalitySleepHours(log.sleepHours!)
                : l10n.vitalityNotLogged,
            onTap: () => _showSleepSheet(context, ref),
          ),
          _LogTile(
            icon: Icons.self_improvement_outlined,
            label: l10n.vitalityBreathingLog,
            value: l10n.vitalityBreathingCount(log.breathingSessions),
            onTap: () =>
                ref.read(vitalityDailyLogProvider.notifier).logBreathingSession(),
          ),
          _LogTile(
            icon: Icons.fitness_center_outlined,
            label: l10n.vitalityWorkoutLog,
            value: log.workoutCompleted
                ? l10n.vitalityWorkoutDone
                : l10n.vitalityWorkoutPending,
            onTap: () =>
                ref.read(vitalityDailyLogProvider.notifier).markWorkoutCompleted(),
          ),
          const SizedBox(height: 24),
          Text(l10n.vitalityArticlesSection,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final entry in grouped.entries) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                _categoryLabel(l10n, entry.key),
                style: TextStyle(
                  color: colors.ember,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...entry.value.map(
              (article) => _ArticleTile(article: article, locale: locale),
            ),
          ],
        ],
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, VitalityCategory category) {
    return switch (category) {
      VitalityCategory.nutrition => l10n.vitalityCategoryNutrition,
      VitalityCategory.training => l10n.vitalityCategoryTraining,
      VitalityCategory.lifestyle => l10n.vitalityCategoryLifestyle,
      VitalityCategory.environmental => l10n.vitalityCategoryEnvironmental,
      VitalityCategory.advanced => l10n.vitalityCategoryAdvanced,
    };
  }

  Future<void> _showSleepSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: ref.read(vitalityDailyLogProvider).sleepHours?.toStringAsFixed(1) ??
          '8',
    );
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.vitalitySleepLog),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: l10n.vitalitySleepHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.deleteAccountCancel),
          ),
          TextButton(
            onPressed: () {
              final v = double.tryParse(controller.text.trim());
              Navigator.pop(ctx, v);
            },
            child: Text(l10n.progressSaveWeight),
          ),
        ],
      ),
    );
    if (result != null && context.mounted) {
      await ref.read(vitalityDailyLogProvider.notifier).setSleepHours(result);
    }
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: colors.recovery),
      title: Text(label),
      subtitle: Text(value, style: TextStyle(color: colors.textMute)),
      trailing: onTap != null ? const Icon(Icons.edit_outlined, size: 18) : null,
      onTap: onTap,
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({required this.article, required this.locale});

  final VitalityArticle article;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(vitalityCategoryIcon(article.category), color: colors.recovery),
        title: Text(
          article.titleFor(locale),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${l10n.vitalityReadingTime(article.readingTimeMinutes)} · ${article.summaryFor(locale)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: colors.textMute, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => openVitalityArticle(context, article.id),
      ),
    );
  }
}
