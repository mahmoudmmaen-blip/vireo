import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/accent_palette_provider.dart';
import 'package:vireo/core/services/app_skin_provider.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final mode = ref.watch(themeModeProvider);
    final accent = ref.watch(accentPaletteProvider);
    final skin = ref.watch(appSkinProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.appearanceTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: VSpace.md),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.xs),
            child: Text(
              l10n.settingsThemeTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          RadioGroup<ThemeMode>(
            groupValue: skin.isSpecialDark ? ThemeMode.dark : mode,
            onChanged: (value) {
              if (value != null) {
                ref.read(appSkinProvider.notifier).setSkin(AppSkin.standard);
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeModeSystem),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeModeLight),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.themeModeDark),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.xs),
            child: Text(
              l10n.accentThemeTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.sm),
            child: Opacity(
              opacity: skin.isSpecialDark ? 0.45 : 1.0,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  AccentPalette.vireoOrange,
                  AccentPalette.oceanicBlue,
                  AccentPalette.emeraldHealth,
                  AccentPalette.deepViolet,
                ].map((palette) {
                  final selected = accent == palette && !skin.isSpecialDark;
                  return InkWell(
                    onTap: skin.isSpecialDark
                        ? null
                        : () => ref
                            .read(accentPaletteProvider.notifier)
                            .setPalette(palette),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 78,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? palette.color : colors.line,
                          width: selected ? 2.5 : 1,
                        ),
                        color: selected
                            ? palette.color.withValues(alpha: 0.12)
                            : colors.surfaceRaised,
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: palette.color,
                            child: selected
                                ? const Icon(Icons.check, size: 18, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _accentName(l10n, palette),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (skin.isSpecialDark)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l10n.settingsAccentLockedHint,
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  String _accentName(AppLocalizations l10n, AccentPalette palette) {
    return switch (palette) {
      AccentPalette.vireoOrange => l10n.accentEmber,
      AccentPalette.oceanicBlue => l10n.accentOcean,
      AccentPalette.emeraldHealth => l10n.accentForest,
      AccentPalette.deepViolet => l10n.accentRoyal,
    };
  }
}
