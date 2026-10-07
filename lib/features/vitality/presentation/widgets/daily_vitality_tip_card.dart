import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/vitality/screens/vitality_hub_screen.dart';

class DailyVitalityTipCard extends ConsumerWidget {
  const DailyVitalityTipCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final tip = ref.watch(dailyVitalityTipProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const VitalityHubScreen()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.recovery.withValues(alpha: 0.35)),
              gradient: LinearGradient(
                colors: [
                  colors.surfaceGradientStart,
                  colors.recovery.withValues(alpha: 0.12),
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.spa_outlined, color: colors.recovery, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.vitalityHubTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors.textMute),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tip.textFor(locale),
                  style: TextStyle(color: colors.text, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.vitalityDailyTipLabel,
                  style: TextStyle(color: colors.textMute, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
