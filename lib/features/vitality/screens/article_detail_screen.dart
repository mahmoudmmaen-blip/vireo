import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/navigation/vireo_page_routes.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';
import 'package:vireo/features/vitality/providers/vitality_progress_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/vitality/widgets/protocol_tracker.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = ref.watch(vitalityArticleProvider(articleId));
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;

    if (article == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.authErrorGeneric)),
      );
    }

    final log = ref.watch(vitalityDailyLogProvider);
    final isRead = log.readArticleIds.contains(article.id);

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.gold.withValues(alpha: 0.85),
                      const Color(0xFF6B21A8).withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    vitalityCategoryIcon(article.category),
                    size: 56,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    article.titleFor(locale),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(
                          Icons.schedule,
                          size: 16,
                          color: colors.ember,
                        ),
                        label: Text(
                          l10n.vitalityReadingTime(article.readingTimeMinutes),
                        ),
                      ),
                      Chip(
                        label: Text(
                          _categoryLabel(l10n, article.category),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.summaryFor(locale),
                    style: TextStyle(color: colors.textMute, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  ...article.blocks.map(
                    (block) => _ContentBlockView(
                      block: block,
                      locale: locale,
                      colors: colors,
                    ),
                  ),
                  if (article.hasProtocol) ...[
                    const SizedBox(height: 16),
                    ProtocolTracker(article: article),
                  ],
                  const SizedBox(height: 20),
                  _SourcesSection(article: article, locale: locale),
                  const SizedBox(height: 16),
                  _DisclaimerBanner(text: l10n.vitalityArticleDisclaimer),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isRead
                        ? null
                        : () async {
                            final added = await ref
                                .read(vitalityDailyLogProvider.notifier)
                                .markArticleRead(article.id);
                            if (context.mounted && added) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.vitalityMarkReadSuccess),
                                ),
                              );
                            }
                          },
                    child: Text(
                      isRead
                          ? l10n.vitalityMarkReadDone
                          : l10n.vitalityMarkRead,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
}

class _ContentBlockView extends StatelessWidget {
  const _ContentBlockView({
    required this.block,
    required this.locale,
    required this.colors,
  });

  final VitalityContentBlock block;
  final String locale;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    final heading = block.headingFor(locale);
    final bullets = block.bulletsFor(locale);
    final takeaway = block.keyTakeawayFor(locale);
    final steps = block.protocolStepsFor(locale);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null) ...[
            Text(
              heading,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
          ],
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 18, color: colors.success),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bullet, style: const TextStyle(height: 1.35))),
                ],
              ),
            ),
          if (takeaway != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.ember.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.ember.withValues(alpha: 0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: colors.ember, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).vitalityKeyTakeaway,
                          style: TextStyle(
                            color: colors.ember,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          takeaway,
                          style: TextStyle(
                            color: colors.text,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (steps.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: colors.recovery.withValues(alpha: 0.2),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.recovery,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(steps[i])),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SourcesSection extends StatelessWidget {
  const _SourcesSection({required this.article, required this.locale});

  final VitalityArticle article;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    if (article.scientificSources.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        l10n.vitalityScientificSources,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: article.scientificSources
          .map(
            (source) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                source.titleFor(locale),
                style: const TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                source.url,
                style: TextStyle(color: colors.textMute, fontSize: 11),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy_outlined, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: source.url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.vitalityLinkCopied)),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, height: 1.4)),
    );
  }
}

void openVitalityArticle(BuildContext context, String articleId) {
  Navigator.of(context).push(
    SlideUpRoute<void>(page: ArticleDetailScreen(articleId: articleId)),
  );
}
