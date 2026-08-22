import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/subscription_gate.dart';

Future<void> openPaywall(
  BuildContext context, {
  PaywallContext paywallContext = PaywallContext.standard,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => PaywallScreen(paywallContext: paywallContext),
    ),
  );
}

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.paywallContext = PaywallContext.standard});

  final PaywallContext paywallContext;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  SubscriptionPlanId _selected = SubscriptionPlanId.annual;
  var _purchasing = false;
  var _restoring = false;

  Future<void> _purchase() async {
    final l10n = AppLocalizations.of(context);
    final sub = ref.read(subscriptionProvider).valueOrNull;
    if (sub == null || !sub.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.paywallNotConfigured)),
      );
      return;
    }

    final package = RevenueCatService.findPackage(
      (await RevenueCatService.getOfferings())?.current,
      _selected,
    );
    if (!mounted) return;
    if (package == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authErrorGeneric)),
      );
      return;
    }

    setState(() => _purchasing = true);
    try {
      final info = await purchaseWithAccountGate(context, ref, package);
      if (!mounted) return;
      if (info != null) {
        await ref.read(subscriptionProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallPurchaseSuccess)),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallPurchaseError)),
        );
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _restoring = true);
    try {
      final info = await restoreWithAccountGate(context, ref);
      if (!mounted) return;
      if (info == null) return;

      await ref.read(subscriptionProvider.notifier).refresh();
      final snapshot = ref.read(subscriptionProvider).valueOrNull;
      if (snapshot?.hasPremiumAccess == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallRestoreSuccess)),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallRestoreEmpty)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paywallRestoreError)),
        );
      }
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final subAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paywallTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: subAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
        data: (snapshot) {
          final plans = snapshot.plans.isNotEmpty
              ? snapshot.plans
              : SubscriptionSnapshot.demoFree.plans;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (widget.paywallContext == PaywallContext.trialEnded) ...[
                _ContextBanner(
                  icon: Icons.hourglass_disabled,
                  message: l10n.trialEndedTitle,
                  color: colors.ember,
                ),
                const SizedBox(height: 20),
              ] else if (widget.paywallContext == PaywallContext.subscriptionExpired) ...[
                _ContextBanner(
                  icon: Icons.lock_clock,
                  message: l10n.paywallSubscriptionExpiredMessage,
                  color: colors.danger,
                ),
                const SizedBox(height: 20),
              ],
              Text(
                l10n.paywallHeadline,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.paywallSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ..._featureBullets(l10n).map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: colors.success, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(bullet)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...plans.map((plan) {
                final selected = _selected == plan.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => setState(() => _selected = plan.id),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.ember.withValues(alpha: 0.12)
                            : colors.surfaceRaised,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? colors.ember : colors.line,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected ? colors.ember : colors.textMute,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _planTitle(l10n, plan.id),
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    if (plan.isBestValue) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.gold.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          l10n.paywallBestValue,
                                          style: TextStyle(
                                            color: colors.gold,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  plan.priceString,
                                  style: TextStyle(color: colors.textMute),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (_purchasing || _restoring) ? null : _purchase,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: _purchasing
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.paywallSubscribe),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: (_purchasing || _restoring) ? null : _restore,
                child: _restoring
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.paywallRestorePurchases),
              ),
            ],
          );
        },
      ),
    );
  }

  List<String> _featureBullets(AppLocalizations l10n) => [
        l10n.paywallFeatureUnlimitedScans,
        l10n.paywallFeatureFullProgram,
        l10n.paywallFeatureCloudSync,
        l10n.paywallFeatureProgressAnalytics,
      ];

  String _planTitle(AppLocalizations l10n, SubscriptionPlanId id) {
    switch (id) {
      case SubscriptionPlanId.monthly:
        return l10n.paywallPlanMonthly;
      case SubscriptionPlanId.annual:
        return l10n.paywallPlanAnnual;
      case SubscriptionPlanId.lifetime:
        return l10n.paywallPlanLifetime;
    }
  }
}

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
