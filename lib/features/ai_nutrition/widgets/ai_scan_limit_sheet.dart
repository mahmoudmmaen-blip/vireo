import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_log_text_screen.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

/// Modal when the daily AI meal scan limit is reached.
class AiScanLimitSheet extends StatelessWidget {
  const AiScanLimitSheet({
    super.key,
    this.onAdWatched,
  });

  final VoidCallback? onAdWatched;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onAdWatched,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiScanLimitSheet(onAdWatched: onAdWatched),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final canWatchAd = AdService.canWatchRewardedToday();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('📸', style: TextStyle(fontSize: 28)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.scanLimitTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.scanLimitBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMute, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),

            _ActionOptionCard(
              emoji: '👑',
              title: l10n.scanLimitProTitle,
              subtitle: l10n.scanLimitProSubtitle,
              buttonLabel: l10n.scanLimitProCta,
              buttonColor: colors.gold,
              isEnabled: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const PaywallScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _ActionOptionCard(
              emoji: '🌙',
              title: l10n.scanLimitWaitTitle,
              subtitle: l10n.scanLimitWaitSubtitle,
              buttonLabel: l10n.scanLimitWaitCta,
              buttonColor: colors.line,
              isSecondary: true,
              isEnabled: true,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),

            _ActionOptionCard(
              emoji: '🎁',
              title: isArabic ? 'إعلان سريع = مسحين إضافيين (+2)' : 'Short Ad = +2 Free Scans',
              subtitle: canWatchAd
                  ? (isArabic
                      ? 'شاهد إعلان قصير للحصول على مسحين إضافيين فوراً'
                      : 'Watch a short ad for +2 extra meal scans today')
                  : (isArabic ? 'وصلت للحد الأقصى للإعلانات اليوم' : 'Daily ad limit reached'),
              buttonLabel: isArabic ? 'مشاهدة إعلان (+2)' : 'Watch Ad (+2)',
              buttonColor: colors.ember,
              isEnabled: canWatchAd,
              onTap: () async {
                Navigator.pop(context);
                await AdService.instance.showRewardedAd(
                  onRewarded: () async {
                    await FeatureGates.grantRewardedMealScans();
                    onAdWatched?.call();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 3),
                          persist: false,
                          content: Text(l10n.scanLimitAdRewardSnack),
                        ),
                      );
                    }
                  },
                  onFailed: () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 3),
                          persist: false,
                          content: Text(l10n.scanLimitAdFailedSnack),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 10),

            _ActionOptionCard(
              emoji: '✍️',
              title: l10n.scanLimitManualTitle,
              subtitle: l10n.scanLimitManualSubtitle,
              buttonLabel: l10n.scanLimitManualCta,
              buttonColor: colors.line,
              isSecondary: true,
              isEnabled: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const MealLogTextScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionOptionCard extends StatelessWidget {
  const _ActionOptionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonColor,
    required this.isEnabled,
    required this.onTap,
    this.isSecondary = false,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final Color buttonColor;
  final bool isEnabled;
  final VoidCallback onTap;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: colors.textMute, fontSize: 11, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton(
              onPressed: isEnabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSecondary ? colors.surfaceRaised : buttonColor,
                foregroundColor: isSecondary ? colors.text : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
