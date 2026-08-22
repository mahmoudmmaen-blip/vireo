import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';

class FridgeScanBanner extends StatelessWidget {
  const FridgeScanBanner({
    super.key,
    required this.remaining,
    required this.onScan,
  });

  final int remaining;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceGradientStart, colors.surfaceGradientEnd],
        ),
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        border: Border.all(color: colors.line),
        boxShadow: VireoDecorations.cardShadow(glow: colors.ember),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.nutritionFridgeBanner(remaining),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onScan,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(l10n.nutritionFridgeScanCta),
          ),
        ],
      ),
    );
  }
}
