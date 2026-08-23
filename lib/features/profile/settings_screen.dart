import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
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
            groupValue: mode,
            onChanged: (value) {
              if (value != null) {
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
}
