import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/activity/screens/health_hub_screen.dart';
import 'package:vireo/features/activity/screens/outdoor_history_screen.dart';
import 'package:vireo/features/activity/screens/outdoor_pick_screen.dart';
import 'package:vireo/features/breathing/screens/breathing_hub_screen.dart';

/// Honor-style Activity & Health entry hub.
class ActivityHubScreen extends ConsumerWidget {
  const ActivityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return FeatureScaffold(
      title: l10n.activityHubTitle,
      body: ListView(
        padding: const EdgeInsets.all(VSpace.md),
        children: [
          Text(
            l10n.activityHubSubtitle,
            style: TextStyle(color: colors.textMute, height: 1.35),
          ),
          const SizedBox(height: VSpace.lg),
          _HubTile(
            icon: Icons.map_outlined,
            title: l10n.outdoorWorkoutTitle,
            subtitle: l10n.outdoorWorkoutSubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const OutdoorPickScreen()),
            ),
          ),
          const SizedBox(height: VSpace.sm),
          _HubTile(
            icon: Icons.history_rounded,
            title: l10n.outdoorHistoryTitle,
            subtitle: l10n.outdoorHistorySubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const OutdoorHistoryScreen()),
            ),
          ),
          const SizedBox(height: VSpace.sm),
          _HubTile(
            icon: Icons.monitor_heart_outlined,
            title: l10n.healthHubTitle,
            subtitle: l10n.healthHubCardSubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HealthHubScreen()),
            ),
          ),
          const SizedBox(height: VSpace.sm),
          _HubTile(
            icon: Icons.self_improvement_outlined,
            title: l10n.breathingHubTitle,
            subtitle: l10n.breathingHubSubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const BreathingHubScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return VireoCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.ember.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.ember),
          ),
          const SizedBox(width: VSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: colors.textMute, fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.textMute),
        ],
      ),
    );
  }
}
