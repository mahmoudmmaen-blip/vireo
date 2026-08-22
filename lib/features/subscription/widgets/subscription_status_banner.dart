import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

class SubscriptionStatusBanner extends StatelessWidget {
  const SubscriptionStatusBanner({
    super.key,
    required this.trialDaysRemaining,
    this.onUpgrade,
  });

  final int trialDaysRemaining;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Material(
      color: colors.gold.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onUpgrade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.star, color: colors.gold, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.subscriptionTrialDaysRemaining(trialDaysRemaining),
                  style: TextStyle(color: colors.gold, fontWeight: FontWeight.w600),
                ),
              ),
              if (onUpgrade != null)
                Icon(Icons.chevron_right, color: colors.gold, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpiredSubscriptionBanner extends StatelessWidget {
  const ExpiredSubscriptionBanner({super.key, this.onUpgrade});

  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Material(
      color: colors.danger.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onUpgrade ??
            () => openPaywall(
                  context,
                  paywallContext: PaywallContext.subscriptionExpired,
                ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: colors.danger, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.subscriptionExpiredBanner,
                  style: TextStyle(color: colors.danger),
                ),
              ),
              Icon(Icons.chevron_right, color: colors.danger, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
