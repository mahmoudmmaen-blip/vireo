import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/local_pro_prices.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

/// Subtle home entry to Pro — discoverable, no dark patterns.
class HomeProTeaserRow extends ConsumerWidget {
  const HomeProTeaserRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isProUserProvider)) return const SizedBox.shrink();

    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final priceHint = LocalProPrices.displayFor(
      SubscriptionPlanId.annual,
      isAr: isAr,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(VRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(VRadius.lg),
          onTap: () => openPaywall(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: colors.gold, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'ڤيريو برو' : 'Vireo Pro',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAr
                            ? 'مسح أكتر · بدون إعلانات · من $priceHint'
                            : 'More scans · ad-free · from $priceHint',
                        style: TextStyle(
                          color: colors.textMute,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textMute),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
