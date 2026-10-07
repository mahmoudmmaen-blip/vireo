import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/domain/vitality_badge.dart';
import 'package:vireo/features/vitality/providers/vitality_progress_provider.dart';

class VitalityBadgesGrid extends ConsumerWidget {
  const VitalityBadgesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final progress = ref.watch(vitalityBadgeProgressProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.vitalityBadgesTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: VitalityBadgeCatalog.badges.length,
          itemBuilder: (context, index) {
            final badge = VitalityBadgeCatalog.badges[index];
            final unlocked = progress.unlockedBadgeIds.contains(badge.id);
            return _BadgeTile(
              badge: badge,
              locale: locale,
              unlocked: unlocked,
              colors: colors,
            );
          },
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.badge,
    required this.locale,
    required this.unlocked,
    required this.colors,
  });

  final VitalityBadge badge;
  final String locale;
  final bool unlocked;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: unlocked
            ? colors.gold.withValues(alpha: 0.12)
            : colors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? colors.gold.withValues(alpha: 0.5)
              : colors.line,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            badge.icon,
            color: unlocked ? colors.gold : colors.textMute,
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            badge.titleFor(locale),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: unlocked ? colors.text : colors.textMute,
            ),
          ),
        ],
      ),
    );
  }
}
