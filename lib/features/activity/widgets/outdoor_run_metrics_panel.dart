import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/activity/services/outdoor_gps_tracker.dart';

/// Live pace / distance / net kcal / cadence — used by outdoor session + audits.
class OutdoorRunMetricsPanel extends StatelessWidget {
  const OutdoorRunMetricsPanel({
    super.key,
    required this.stats,
    this.paceOrSpeedLabel = '—',
  });

  final OutdoorLiveStats stats;
  final String paceOrSpeedLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final km = (stats.distanceMeters / 1000).toStringAsFixed(2);

    Widget cell(String label, String value) {
      return Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: colors.text,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: colors.textMute, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Semantics(
      container: true,
      label: l10n.outdoorNetKcalLabel,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            cell(l10n.outdoorDistance, '$km km'),
            cell(l10n.outdoorPace, paceOrSpeedLabel),
            cell(l10n.outdoorNetKcalLabel, '${stats.calories}'),
            cell(
              l10n.outdoorCadenceLabel,
              stats.cadenceSpm > 0 ? stats.cadenceSpm.toStringAsFixed(0) : '—',
            ),
          ],
        ),
      ),
    );
  }
}
