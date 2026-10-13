import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/theme/app_theme_variant_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final mode = ref.watch(themeModeProvider);
    final currentVariant = ref.watch(appThemeVariantProvider);

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
            groupValue: mode,
            onChanged: (value) {
              if (value != null) {
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
              Localizations.localeOf(context).languageCode.startsWith('ar')
                  ? 'طابع التطبيق (المظهر والألوان)'
                  : 'App Theme & Color System',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.sm),
            child: Column(
              children: AppThemeVariant.values.map((variant) {
                final selected = currentVariant == variant;
                final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => ref
                        .read(appThemeVariantProvider.notifier)
                        .setThemeVariant(variant),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? variant.primaryAccent : colors.line,
                          width: selected ? 2 : 1,
                        ),
                        color: selected
                            ? variant.primaryAccent.withValues(alpha: 0.12)
                            : colors.surfaceRaised,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [variant.primaryAccent, variant.secondaryAccent],
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check, size: 20, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  variant.label(isAr),
                                  style: TextStyle(
                                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                                    fontSize: 14.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  switch (variant) {
                                    AppThemeVariant.ember => isAr
                                        ? 'البرتقالي الكلاسيكي — الافتراضي للرجال'
                                        : 'Warm Ember orange — Default for men',
                                    AppThemeVariant.calmGold => isAr
                                        ? 'رمادي داكن وفحم مع ذهبي وزيتوني — الافتراضي للنساء'
                                        : 'Charcoal, warm gold & olive — Default for women',
                                    AppThemeVariant.ocean => isAr
                                        ? 'كحلي عميق مع تيل منعش'
                                        : 'Deep navy + refreshing teal',
                                    AppThemeVariant.rose => isAr
                                        ? 'برقوقي ناعم مع روز هادئ وراقي'
                                        : 'Refined soft plum + muted rose',
                                  },
                                  style: TextStyle(
                                    color: colors.textMute,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
