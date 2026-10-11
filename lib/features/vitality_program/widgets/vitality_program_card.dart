import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/navigation/vireo_page_routes.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/vitality_program/providers/vitality_program_provider.dart';
import 'package:vireo/features/vitality_program/screens/vitality_program_screen.dart';

class VitalityProgramCard extends ConsumerWidget {
  const VitalityProgramCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final program = ref.watch(vitalityProgramProvider);
    final started = program.progress.hasStarted;
    final progress = program.overallProgress / 100;
    final isPro = ref.watch(isProUserProvider);

    return Material(
      color: colors.surfaceRaised,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (!FeatureGates.requirePro(context, ref, force: true)) return;
          Navigator.of(context).push(
            SlideUpRoute<void>(page: const VitalityProgramScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.gold.withValues(alpha: 0.35),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.gold.withValues(alpha: 0.08),
                colors.recovery.withValues(alpha: 0.06),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('🚀', style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      started
                          ? l10n.vitalityProgramContinue
                          : l10n.vitalityProgramStartCta,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  if (!isPro) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PRO',
                        style: TextStyle(
                          color: colors.gold,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Icon(Icons.chevron_right, color: colors.textMute),
                ],
              ),
              if (started) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.05, 1.0),
                    minHeight: 8,
                    backgroundColor: colors.line,
                    color: colors.gold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.vitalityWeekX(program.progress.currentWeek),
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    l10n.vitalityProgramSubtitle,
                    style: TextStyle(color: colors.textMute, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
