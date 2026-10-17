import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/fingerprint/domain/vireo_fingerprint.dart';

/// بصمتك — نظام Vireo الذكي (4 cards).
class FingerprintScreen extends StatelessWidget {
  const FingerprintScreen({super.key, required this.profile});

  final VireoFingerprint profile;

  static Future<void> open(BuildContext context, VireoFingerprint profile) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FingerprintScreen(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.fingerprintTitle),
        actions: [
          TextButton(
            onPressed: () async {
              await VireoFingerprint.reset();
              if (context.mounted) Navigator.of(context).maybePop();
            },
            child: Text(l10n.fingerprintReset),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.fingerprintSubtitle,
            style: TextStyle(color: colors.textMute),
          ),
          const SizedBox(height: 16),
          _card(
            colors,
            title: l10n.fingerprintActivity,
            value:
                '${profile.activity.effectiveComfortable} ${l10n.fingerprintStepsUnit}',
            confidence: profile.activity.confidence,
            why: l10n.fingerprintActivityWhy,
            editLabel: l10n.fingerprintEdit,
          ),
          _card(
            colors,
            title: l10n.fingerprintNutrition,
            value: l10n.fingerprintMealsCount(profile.nutrition.typicalMealCount),
            confidence: profile.nutrition.confidence,
            why: l10n.fingerprintNutritionWhy,
            editLabel: l10n.fingerprintEdit,
          ),
          _card(
            colors,
            title: l10n.fingerprintTolerance,
            value: l10n.fingerprintDeficitValue(
              profile.tolerance.sustainableDeficitKcal,
            ),
            confidence: profile.tolerance.confidence,
            why: l10n.fingerprintToleranceWhy,
            editLabel: l10n.fingerprintEdit,
          ),
          _card(
            colors,
            title: l10n.fingerprintChronotype,
            value: l10n.fingerprintLogHour(profile.chronotype.typicalLogHour),
            confidence: profile.chronotype.confidence,
            why: l10n.fingerprintChronotypeWhy,
            editLabel: l10n.fingerprintEdit,
          ),
          if (!profile.ready)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l10n.fingerprintNotReady(profile.daysOfData),
                style: TextStyle(color: colors.gold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _card(
    VireoColors colors, {
    required String title,
    required String value,
    required double confidence,
    required String why,
    required String editLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: TextStyle(color: colors.textMute, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: colors.line,
              color: colors.ember,
            ),
          ),
          const SizedBox(height: 8),
          Text(why, style: TextStyle(color: colors.textMute, fontSize: 12)),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () {},
              child: Text(editLabel),
            ),
          ),
        ],
      ),
    );
  }
}
