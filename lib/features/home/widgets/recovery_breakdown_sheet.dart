import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

Future<void> showRecoveryBreakdownSheet(BuildContext context, int score) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      final colors = ctx.vireoColors;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          24 + MediaQuery.paddingOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.homeRecoveryScore,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '$score%',
                  style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                        color: colors.success,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeRecoveryExplain(score),
              style: TextStyle(color: colors.textMute),
            ),
            const SizedBox(height: 16),
            _Factor(
              icon: Icons.bedtime_outlined,
              title: l10n.homeRecoveryFactorSleep,
              value: '90%',
              tip: l10n.homeRecoveryTipSleep,
              colors: colors,
            ),
            _Factor(
              icon: Icons.spa_outlined,
              title: l10n.homeRecoveryFactorRest,
              value: '80%',
              tip: l10n.homeRecoveryTipRest,
              colors: colors,
            ),
            _Factor(
              icon: Icons.fitness_center_outlined,
              title: l10n.homeRecoveryFactorMuscle,
              value: '85%',
              tip: l10n.homeRecoveryTipMuscle,
              colors: colors,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.homeRecoveryImproveTitle,
              style: Theme.of(ctx).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            Text(l10n.homeRecoveryImproveBody, style: TextStyle(color: colors.textMute)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.continueButton),
            ),
          ],
        ),
      );
    },
  );
}

class _Factor extends StatelessWidget {
  const _Factor({
    required this.icon,
    required this.title,
    required this.value,
    required this.tip,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String value;
  final String tip;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.recovery),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text(value, style: TextStyle(color: colors.success, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(tip, style: TextStyle(color: colors.textMute, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
