import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/accent_palette_provider.dart';
import 'package:vireo/core/services/app_skin_provider.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/auth_screen.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/profile/delete_account_warning_screen.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final colors = context.vireoColors;
    final mode = ref.watch(themeModeProvider);
    final accent = ref.watch(accentPaletteProvider);
    final skin = ref.watch(appSkinProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsThemeTitle,
              style: Theme.of(context).textTheme.titleMedium,
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
                  title: Text(l10n.settingsThemeSystem),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.settingsThemeDark),
                  value: ThemeMode.dark,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.settingsThemeLight),
                  value: ThemeMode.light,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsSkinTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          RadioGroup<AppSkin>(
            groupValue: skin,
            onChanged: (value) {
              if (value != null) {
                ref.read(appSkinProvider.notifier).setSkin(value);
                if (value.isSpecialDark) {
                  ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                }
              }
            },
            child: Column(
              children: [
                RadioListTile<AppSkin>(
                  title: Text(l10n.settingsSkinStandard),
                  subtitle: Text(l10n.settingsSkinStandardDesc),
                  value: AppSkin.standard,
                ),
                RadioListTile<AppSkin>(
                  title: Text(l10n.settingsSkinAmoled),
                  subtitle: Text(l10n.settingsSkinAmoledDesc),
                  value: AppSkin.amoled,
                ),
                RadioListTile<AppSkin>(
                  title: Text(l10n.settingsSkinNavy),
                  subtitle: Text(l10n.settingsSkinNavyDesc),
                  value: AppSkin.navy,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsAccentTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Opacity(
              opacity: skin.isSpecialDark ? 0.45 : 1,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AccentPalette.values.map((palette) {
                  final selected = accent == palette && !skin.isSpecialDark;
                  return InkWell(
                    onTap: skin.isSpecialDark
                        ? null
                        : () => ref
                            .read(accentPaletteProvider.notifier)
                            .setPalette(palette),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 72,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? palette.color : colors.line,
                          width: selected ? 2.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: palette.color,
                            child: selected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _accentLabel(l10n, palette),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(l10n.paywallTitle),
            subtitle: Text(l10n.settingsManageSubscription),
            onTap: () => openPaywall(context),
          ),
          const Divider(),
          auth.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => ListTile(title: Text(l10n.authErrorGeneric)),
            data: (state) {
              if (state is AppAuthGuest) {
                return ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.guestModeTitle),
                  subtitle: Text(l10n.guestModeSubtitle),
                  trailing: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    ),
                    child: Text(l10n.authSignUp),
                  ),
                );
              }
              if (state is AppAuthAuthenticated) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(state.user.email ?? l10n.authSignedIn),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: colors.textMute),
                      title: Text(l10n.signOut),
                      onTap: () => ref.read(authProvider.notifier).signOut(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.delete_forever, color: colors.danger),
                      title: Text(
                        l10n.deleteAccountTitle,
                        style: TextStyle(color: colors.danger),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DeleteAccountWarningScreen(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListTile(
                title: Text(l10n.authTitle),
                trailing: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  ),
                  child: Text(l10n.authSignIn),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _accentLabel(AppLocalizations l10n, AccentPalette palette) {
    return switch (palette) {
      AccentPalette.vireoOrange => l10n.settingsAccentOrange,
      AccentPalette.emeraldHealth => l10n.settingsAccentEmerald,
      AccentPalette.oceanicBlue => l10n.settingsAccentBlue,
      AccentPalette.deepViolet => l10n.settingsAccentViolet,
    };
  }
}
