import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/walking/walking_tracker_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return FeatureScaffold(
      title: l10n.homeTitle,
      actions: [
        IconButton(
          onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
          tooltip: l10n.languageToggle,
          icon: Text(
            l10n.languageToggle,
            style: TextStyle(color: colors.ember, fontWeight: FontWeight.w600),
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.fitness_center, color: colors.ember),
              title: Text(l10n.setupComplete),
              subtitle: Text(l10n.homeWelcomeSubtitle),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.directions_walk, color: colors.ember),
              title: Text(l10n.walkingTitle),
              subtitle: Text(l10n.homeWalkingCardSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WalkingTrackerScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
