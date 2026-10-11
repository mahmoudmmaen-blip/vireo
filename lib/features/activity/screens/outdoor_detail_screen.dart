import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/features/activity/data/outdoor_workout_repository.dart';
import 'package:vireo/features/activity/widgets/outdoor_map_view.dart';

class OutdoorDetailScreen extends ConsumerWidget {
  const OutdoorDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.read(outdoorWorkoutRepositoryProvider).byId(sessionId);
    final colors = context.vireoColors;

    if (session == null) {
      return FeatureScaffold(
        title: l10n.outdoorDetailTitle,
        body: Center(child: Text(l10n.authErrorGeneric)),
      );
    }

    final route = session.routePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    return FeatureScaffold(
      title: l10n.outdoorDetailTitle,
      body: ListView(
        padding: const EdgeInsets.all(VSpace.md),
        children: [
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(VRadius.lg),
              child: OutdoorMapView(route: route),
            ),
          ),
          const SizedBox(height: VSpace.md),
          Text(
            DateFormat.yMMMd().add_jm().format(session.startedAt),
            style: TextStyle(color: colors.textMute),
          ),
          const SizedBox(height: VSpace.sm),
          _Row(l10n.outdoorDistance, '${session.distanceKm.toStringAsFixed(2)} km'),
          _Row(l10n.outdoorDuration, _dur(session.durationSeconds)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.outdoorCalories(session.caloriesBurned),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (FatEquivalent.hasEquivalent(session.caloriesBurned)) ...[
                  const SizedBox(height: 4),
                  FatEquivalentBadge(
                    kcal: session.caloriesBurned,
                    isBurned: true,
                  ),
                ],
              ],
            ),
          ),
          if (session.splits.isNotEmpty) ...[
            const SizedBox(height: VSpace.lg),
            Text(
              l10n.outdoorSplitsTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: VSpace.sm),
            ...session.splits.map(
              (s) => _Row(
                l10n.outdoorSplitKm(s.kmIndex),
                _pace(s.paceMinPerKm),
              ),
            ),
            const SizedBox(height: VSpace.lg),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < session.splits.length; i++)
                          FlSpot(
                            i.toDouble() + 1,
                            session.splits[i].paceMinPerKm,
                          ),
                      ],
                      isCurved: true,
                      color: colors.ember,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _dur(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }

  String _pace(double minPerKm) {
    final m = minPerKm.floor();
    final sec = ((minPerKm - m) * 60).round();
    return '$m:${sec.toString().padLeft(2, '0')} / km';
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (value.isNotEmpty)
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
