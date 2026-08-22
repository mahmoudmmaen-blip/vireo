import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class ScanQuotaBanner extends StatelessWidget {
  const ScanQuotaBanner({super.key, required this.remaining});

  final int remaining;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: colors.surfaceRaised,
      child: Text(
        l10n.nutritionScansRemaining(remaining),
        style: TextStyle(color: colors.textMute, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
