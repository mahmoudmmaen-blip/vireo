import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/energy_ledger.dart';

class EnergyLedgerCard extends StatefulWidget {
  const EnergyLedgerCard({
    super.key,
    required this.days,
    this.trendWeightChangeKg,
  });

  final Map<String, EnergyLedgerDay> days;
  final double? trendWeightChangeKg;

  @override
  State<EnergyLedgerCard> createState() => _EnergyLedgerCardState();
}

class _EnergyLedgerCardState extends State<EnergyLedgerCard> {
  LedgerPeriod _period = LedgerPeriod.allTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final totals = EnergyLedger.totalsFor(widget.days, period: _period);
    final fatKg = totals.activityFatKgEstimate;
    final note = EnergyLedger.divergenceNoteAr(
      activityFatKgEstimate: fatKg,
      trendWeightChangeKg: widget.trendWeightChangeKg,
    );

    return Container(
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
            l10n.energyLedgerTitle,
            style: TextStyle(
              color: colors.text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: [
              _tab(l10n.energyLedgerToday, LedgerPeriod.today, colors),
              _tab(l10n.energyLedgerWeek, LedgerPeriod.week, colors),
              _tab(l10n.energyLedgerMonth, LedgerPeriod.month, colors),
              _tab(l10n.energyLedgerAllTime, LedgerPeriod.allTime, colors),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.energyLedgerBurned(
              totals.netActivityKcal,
              fatKg.toStringAsFixed(1),
            ),
            style: TextStyle(
              color: colors.ember,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.energyLedgerBalanceNote,
            style: TextStyle(color: colors.textMute, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(note, style: TextStyle(color: colors.textMute, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            l10n.energyLedgerStepsDistance(
              totals.steps,
              (totals.distanceMeters / 1000).toStringAsFixed(1),
            ),
            style: TextStyle(color: colors.text, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, LedgerPeriod p, VireoColors colors) {
    final selected = _period == p;
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: () => setState(() => _period = p),
        style: TextButton.styleFrom(
          foregroundColor: selected ? colors.ember : colors.textMute,
          backgroundColor: selected ? colors.surface : Colors.transparent,
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
