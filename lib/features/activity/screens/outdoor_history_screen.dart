import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/features/activity/data/outdoor_workout_repository.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/activity/screens/outdoor_detail_screen.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

class OutdoorHistoryScreen extends ConsumerWidget {
  const OutdoorHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessions = ref.watch(outdoorWorkoutSessionsProvider);
    final colors = context.vireoColors;

    return FeatureScaffold(
      title: l10n.outdoorHistoryTitle,
      body: sessions.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.outdoorHistoryEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textMute),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final s = sessions[i];
                final isPro = ref.watch(isProUserProvider);
                return VireoCard(
                  onTap: () {
                    if (!FeatureGates.requirePro(context, ref, force: true)) return;
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => OutdoorDetailScreen(sessionId: s.id),
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_icon(s.type), color: colors.ember),
                    title: Row(
                      children: [
                        Text(_label(l10n, s.type)),
                        if (!isPro) ...[
                          const SizedBox(width: 8),
                          VireoPill(
                            label: 'PRO',
                            icon: Icons.lock_outline,
                            color: colors.gold,
                            filled: true,
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      '${DateFormat.yMMMd().add_jm().format(s.startedAt)} · '
                      '${(s.distanceMeters / 1000).toStringAsFixed(2)} km · '
                      '${s.caloriesBurned} kcal'
                      '${FatEquivalent.hasEquivalent(s.caloriesBurned) ? ' · ${FatEquivalent.approxText(s.caloriesBurned, l10n: l10n, lang: Localizations.localeOf(context).languageCode)}' : ''}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
    );
  }

  IconData _icon(OutdoorWorkoutType t) => switch (t) {
        OutdoorWorkoutType.walk => Icons.directions_walk,
        OutdoorWorkoutType.run => Icons.directions_run,
        OutdoorWorkoutType.cycle => Icons.directions_bike,
      };

  String _label(AppLocalizations l10n, OutdoorWorkoutType t) => switch (t) {
        OutdoorWorkoutType.walk => l10n.outdoorTypeWalk,
        OutdoorWorkoutType.run => l10n.outdoorTypeRun,
        OutdoorWorkoutType.cycle => l10n.outdoorTypeCycle,
      };
}
