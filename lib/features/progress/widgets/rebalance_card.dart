import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/rebalance_engine.dart';

/// Deterministic rebalance card — options require an explicit user tap.
class RebalanceCard extends StatelessWidget {
  const RebalanceCard({
    super.key,
    required this.result,
    this.onOptionSelected,
  });

  final RebalanceResult result;
  final void Function(RebalanceOption option)? onOptionSelected;

  @override
  Widget build(BuildContext context) {
    if (result.kind == RebalanceKind.none) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Semantics(
      container: true,
      label: l10n.rebalanceCardTitle,
      child: Container(
        width: double.infinity,
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
              l10n.rebalanceCardTitle,
              style: TextStyle(
                color: colors.text,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.messageAr.isNotEmpty ? result.messageAr : l10n.rebalanceSafeDay,
              style: TextStyle(color: colors.textMute, height: 1.4),
            ),
            if (result.options.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...result.options.map((opt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: onOptionSelected == null
                          ? null
                          : () => onOptionSelected!(opt),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.ember,
                        side: BorderSide(color: colors.line),
                        alignment: AlignmentDirectional.centerStart,
                      ),
                      child: Text(
                        '${opt.titleAr} — ${opt.detailAr}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }),
              Text(
                l10n.rebalanceNeedsTap,
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
