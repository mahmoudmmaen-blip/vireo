import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/activity/screens/outdoor_countdown_screen.dart';

class OutdoorPickScreen extends StatelessWidget {
  const OutdoorPickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return FeatureScaffold(
      title: l10n.outdoorPickTitle,
      body: Padding(
        padding: const EdgeInsets.all(VSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.outdoorPickSubtitle, style: TextStyle(color: colors.textMute)),
            const SizedBox(height: VSpace.lg),
            _TypeCard(
              icon: Icons.directions_walk_rounded,
              label: l10n.outdoorTypeWalk,
              onTap: () => _start(context, OutdoorWorkoutType.walk),
            ),
            const SizedBox(height: VSpace.sm),
            _TypeCard(
              icon: Icons.directions_run_rounded,
              label: l10n.outdoorTypeRun,
              onTap: () => _start(context, OutdoorWorkoutType.run),
            ),
            const SizedBox(height: VSpace.sm),
            _TypeCard(
              icon: Icons.directions_bike_rounded,
              label: l10n.outdoorTypeCycle,
              onTap: () => _start(context, OutdoorWorkoutType.cycle),
            ),
          ],
        ),
      ),
    );
  }

  void _start(BuildContext context, OutdoorWorkoutType type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OutdoorCountdownScreen(type: type),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return VireoCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 32, color: colors.ember),
          const SizedBox(width: VSpace.md),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Icon(Icons.play_circle_fill, color: colors.ember, size: 36),
        ],
      ),
    );
  }
}
