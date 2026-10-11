import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';
import 'package:vireo/features/vitality/domain/vitality_badge.dart';
import 'package:vireo/features/vitality/providers/vitality_progress_provider.dart';

class ProtocolTracker extends ConsumerWidget {
  const ProtocolTracker({super.key, required this.article});

  final VitalityArticle article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final progressMap = ref.watch(protocolProgressProvider);
    final progress = progressMap[article.id] ?? const ProtocolTrackerState();
    final notifier = ref.read(protocolProgressProvider.notifier);
    final total = article.protocolItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.vitalityProtocolTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.vitalityProtocolStreak(progress.consecutiveDays),
            style: TextStyle(color: colors.textMute),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress.consecutiveDays == 0
                  ? 0.05
                  : (progress.consecutiveDays / 7).clamp(0.05, 1.0),
              backgroundColor: colors.line,
              color: colors.recovery,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in article.protocolItems)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: progress.checkedItemIds.contains(item.id),
              onChanged: (_) => notifier.toggleItem(article.id, item.id),
              title: Text(item.textFor(locale), style: const TextStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          if (total > 0 &&
              progress.checkedItemIds.length >= total)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton(
                onPressed: () async {
                  await notifier.completeProtocolDay(article.id, total);
                  if (!context.mounted) return;
                  final streak =
                      ref.read(protocolProgressProvider)[article.id]?.consecutiveDays ??
                          0;
                  if (streak >= 7) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(l10n.vitalityProtocolBadgeEarned)),
                    );
                  }
                },
                child: Text(l10n.vitalityProtocolCompleteDay),
              ),
            ),
        ],
      ),
    );
  }
}
