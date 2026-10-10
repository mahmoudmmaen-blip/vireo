import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/breathing/screens/breathing_session_screen.dart';

enum BreathingPattern { box, fourSevenEight }

class BreathingHubScreen extends StatelessWidget {
  const BreathingHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(
      title: l10n.breathingHubTitle,
      body: Padding(
        padding: const EdgeInsets.all(VSpace.md),
        child: Column(
          children: [
            _Pick(
              title: l10n.breathingBoxTitle,
              subtitle: l10n.breathingBoxSubtitle,
              onTap: (min) => _open(context, BreathingPattern.box, min),
            ),
            const SizedBox(height: VSpace.sm),
            _Pick(
              title: l10n.breathing478Title,
              subtitle: l10n.breathing478Subtitle,
              onTap: (min) => _open(context, BreathingPattern.fourSevenEight, min),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, BreathingPattern pattern, int minutes) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BreathingSessionScreen(pattern: pattern, minutes: minutes),
      ),
    );
  }
}

class _Pick extends StatelessWidget {
  const _Pick({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final void Function(int minutes) onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return VireoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          Text(subtitle),
          const SizedBox(height: VSpace.sm),
          Wrap(
            spacing: 8,
            children: [
              for (final m in [1, 3, 5])
                ActionChip(label: Text(l10n.breathingMinutes(m)), onPressed: () => onTap(m)),
            ],
          ),
        ],
      ),
    );
  }
}
