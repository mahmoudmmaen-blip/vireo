import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/achievement_badge.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/social/widgets/social_share_card_helper.dart';

class AchievementsGridCard extends ConsumerWidget {
  const AchievementsGridCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final badges = ref.watch(progressBadgesProvider);
    final locale = Localizations.localeOf(context).languageCode;

    final unlockedCount = badges.where((b) => b.isUnlocked).length;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.achievementsTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.ember.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unlockedCount / ${badges.length} ${l10n.achievementsUnlocked}',
                  style: TextStyle(
                    color: colors.ember,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return _BadgeItem(badge: badge, locale: locale);
            },
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({required this.badge, required this.locale});

  final AchievementBadge badge;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isUnlocked = badge.isUnlocked;

    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Text(badge.icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(child: Text(badge.title(locale))),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badge.desc(locale)),
                const SizedBox(height: 12),
                if (!isUnlocked) ...[
                  Text(
                    'Progress: ${(badge.progress * 100).round()}%',
                    style: TextStyle(color: colors.textMute, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: badge.progress,
                    color: colors.ember,
                    backgroundColor: colors.line,
                  ),
                ] else
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: colors.success, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Unlocked!',
                        style: TextStyle(
                          color: colors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            actions: [
              if (isUnlocked)
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    SocialShareCardHelper.showBadgeShareSheet(
                      context: context,
                      title: badge.title(locale),
                      description: badge.desc(locale),
                      icon: badge.icon,
                      isArabic: locale.startsWith('ar'),
                    );
                  },
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: Text(locale.startsWith('ar') ? 'مشاركة البطاقة' : 'Share Card'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isUnlocked
              ? colors.surface
              : colors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked ? colors.ember.withValues(alpha: 0.5) : colors.line,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.35,
              child: Text(badge.icon, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 6),
            Text(
              badge.title(locale),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                color: isUnlocked ? Colors.white : colors.textMute,
              ),
            ),
            if (!isUnlocked) ...[
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: badge.progress,
                  minHeight: 3,
                  color: colors.ember,
                  backgroundColor: colors.line,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
