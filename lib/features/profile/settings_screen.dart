import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/constants/legal_urls.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/accent_palette_provider.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/services/app_skin_provider.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';
import 'package:vireo/core/widgets/language_picker_screen.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/auth_screen.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/diet_programs/domain/cuisine_type.dart';
import 'package:vireo/features/home/providers/feature_unlock_provider.dart';
import 'package:vireo/features/notifications/screens/notification_settings_screen.dart';
import 'package:vireo/features/profile/delete_account_warning_screen.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        elevation: 0,
      ),
      body: NoScrollbarScrollConfiguration(
        child: ListView(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ---------------------------------------------------------------
            // 1. الحساب (Account)
            // ---------------------------------------------------------------
            _SettingsSectionHeader(
              icon: Icons.person_outline_rounded,
              title: isAr ? 'الحساب' : 'Account',
            ),
            _buildAccountGroup(context, ref, l10n, colors),
            const SizedBox(height: 16),

            // ---------------------------------------------------------------
            // 2. الأهداف والخيارات (Goals & Preferences)
            // ---------------------------------------------------------------
            _SettingsSectionHeader(
              icon: Icons.track_changes_rounded,
              title: isAr ? 'الأهداف والتفضيلات' : 'Goals & Preferences',
            ),
            _buildGoalsGroup(context, ref, l10n, colors, isAr),
            const SizedBox(height: 16),

            // ---------------------------------------------------------------
            // 3. التنبيهات (Notifications)
            // ---------------------------------------------------------------
            _SettingsSectionHeader(
              icon: Icons.notifications_none_rounded,
              title: isAr ? 'التنبيهات' : 'Notifications',
            ),
            _buildNotificationsGroup(context, ref, l10n, colors, isAr),
            const SizedBox(height: 16),

            // ---------------------------------------------------------------
            // 4. الخصوصية والشروط (Privacy & Legal)
            // ---------------------------------------------------------------
            _SettingsSectionHeader(
              icon: Icons.shield_outlined,
              title: isAr ? 'الخصوصية والشروط' : 'Privacy & Terms',
            ),
            _buildPrivacyGroup(context, ref, l10n, colors, isAr),
            const SizedBox(height: 16),

            // ---------------------------------------------------------------
            // 5. الاشتراك (Subscription)
            // ---------------------------------------------------------------
            _SettingsSectionHeader(
              icon: Icons.workspace_premium_outlined,
              title: isAr ? 'الاشتراك' : 'Subscription',
            ),
            _buildSubscriptionGroup(context, ref, l10n, colors, isAr),

            // ---------------------------------------------------------------
            // مظهر التطبيق (App Appearance & Customization - tucked neatly)
            // ---------------------------------------------------------------
            const SizedBox(height: 16),
            _SettingsSectionHeader(
              icon: Icons.palette_outlined,
              title: isAr ? 'مظهر التطبيق' : 'Appearance',
            ),
            _buildAppearanceGroup(context, ref, l10n, colors),

            // ---------------------------------------------------------------
            // أدوات المطور (Developer / Debug items - only in debug mode)
            // ---------------------------------------------------------------
            if (kDebugMode) ...[
              const SizedBox(height: 16),
              _SettingsSectionHeader(
                icon: Icons.bug_report_outlined,
                title: isAr ? 'أدوات المطور (Debug)' : 'Developer Tools',
              ),
              _buildDebugGroup(context, ref, colors, isAr),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Account Section
  // ---------------------------------------------------------------------------
  Widget _buildAccountGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    VireoColors colors,
  ) {
    final auth = ref.watch(authProvider);

    return _SectionCard(
      child: auth.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        error: (error, stackTrace) => ListTile(
          leading: const Icon(Icons.error_outline),
          title: Text(l10n.authErrorGeneric),
        ),
        data: (state) {
          if (state.isGuest) {
            return ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.guestModeTitle),
              subtitle: Text(l10n.guestModeSubtitle),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.ember,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
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
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: colors.textMute),
                  title: Text(l10n.signOut),
                  onTap: () => ref.read(authProvider.notifier).signOut(),
                ),
                const Divider(height: 1),
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
            leading: const Icon(Icons.login_rounded),
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
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Goals & Preferences
  // ---------------------------------------------------------------------------
  Widget _buildGoalsGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    VireoColors colors,
    bool isAr,
  ) {
    final isUnlocked = ref.watch(isAdvancedFeaturesUnlockedProvider);

    return _SectionCard(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant_menu_rounded),
            title: Text(l10n.cuisineSettingTitle),
            subtitle: Text(ref.watch(cuisineProvider).localizedName(l10n)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showCuisineSelector(context, ref, l10n),
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.auto_awesome_rounded),
            title: Text(isAr ? 'كل المميزات فوراً' : 'All Features'),
            subtitle: Text(
              isUnlocked
                  ? (isAr ? 'المميزات المتقدمة مفتوحة بالكامل' : 'All features are unlocked')
                  : (isAr ? 'فتح المميزات المتقدمة دون انتظار اليوم الثالث' : 'Unlock Day 3+ features immediately'),
              style: TextStyle(fontSize: 12, color: colors.textMute),
            ),
            value: isUnlocked,
            activeTrackColor: colors.ember,
            activeThumbColor: Colors.white,
            onChanged: (val) {
              if (val) {
                ref.read(isAdvancedFeaturesUnlockedProvider.notifier).unlockAllManually();
              } else {
                ref.read(isAdvancedFeaturesUnlockedProvider.notifier).resetToProgressive();
              }
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Notifications
  // ---------------------------------------------------------------------------
  Widget _buildNotificationsGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    VireoColors colors,
    bool isAr,
  ) {
    return _SectionCard(
      child: ListTile(
        leading: const Icon(Icons.notifications_active_outlined),
        title: Text(l10n.notificationsTitle),
        subtitle: Text(isAr ? 'أوقات الوجبات، تذكير شرب الماء والرياضة' : 'Meal times, water and workout reminders'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const NotificationSettingsScreen(),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Privacy & Legal
  // ---------------------------------------------------------------------------
  Widget _buildPrivacyGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    VireoColors colors,
    bool isAr,
  ) {
    return _SectionCard(
      child: Column(
        children: [
          FutureBuilder<bool>(
            future: AdService.instance.isPrivacyOptionsRequired(),
            builder: (ctx, snap) {
              if (snap.data != true) return const SizedBox.shrink();
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.security_update_good_outlined),
                    title: Text(isAr ? 'خيارات الخصوصية والإعلانات (EEA/UK)' : 'Privacy Options (Consent)'),
                    subtitle: Text(isAr ? 'تعديل موافقتك على الإعلانات والبيانات' : 'Update ad tracking consent'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => AdService.instance.showPrivacyOptionsForm(),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(isAr ? 'شروط الاستخدام' : 'Terms of Use'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () => LegalUrls.openTerms(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(isAr ? 'سياسة الخصوصية' : 'Privacy Policy'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () => LegalUrls.openPrivacy(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.health_and_safety_outlined),
            title: Text(isAr ? 'إخلاء المسؤولية الطبية' : 'Medical Disclaimer'),
            subtitle: Text(
              isAr
                  ? 'تطبيق للعافية ونمط الحياة — ليس بديلاً عن الطبيب'
                  : 'Wellness app — not a substitute for medical advice',
              style: TextStyle(fontSize: 12, color: colors.textMute),
            ),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () => LegalUrls.openMedicalDisclaimer(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Subscription
  // ---------------------------------------------------------------------------
  Widget _buildSubscriptionGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    VireoColors colors,
    bool isAr,
  ) {
    return _SectionCard(
      child: ListTile(
        leading: Icon(Icons.star_rounded, color: colors.ember),
        title: Text(l10n.paywallTitle),
        subtitle: Text(l10n.settingsManageSubscription),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => openPaywall(context),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Appearance
  // ---------------------------------------------------------------------------
  Widget _buildAppearanceGroup(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    VireoColors colors,
  ) {
    final mode = ref.watch(themeModeProvider);
    final skin = ref.watch(appSkinProvider);
    final accent = ref.watch(accentPaletteProvider);

    return _SectionCard(
      child: ExpansionTile(
        leading: const Icon(Icons.dark_mode_outlined),
        title: Text(l10n.settingsThemeTitle),
        subtitle: Text(
          mode == ThemeMode.system
              ? l10n.settingsThemeSystem
              : (mode == ThemeMode.dark ? l10n.settingsThemeDark : l10n.settingsThemeLight),
          style: TextStyle(color: colors.textMute, fontSize: 13),
        ),
        children: [
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
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(ref.watch(activeAppLanguageProvider).languageLabel),
            subtitle: Text(ref.watch(activeAppLanguageProvider).nativeName),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              LanguagePickerScreen.route(isInitial: false),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.settingsAccentTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    width: 64,
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                          radius: 14,
                          backgroundColor: palette.color,
                          child: selected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _accentLabel(l10n, palette),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Debug / Developer Tools (Only shown in kDebugMode)
  // ---------------------------------------------------------------------------
  Widget _buildDebugGroup(
    BuildContext context,
    WidgetRef ref,
    VireoColors colors,
    bool isAr,
  ) {
    return _SectionCard(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.refresh_rounded),
            title: Text(isAr ? 'إعادة ضبط تجربة اليوم 1' : 'Reset Day Counter to Day 1'),
            subtitle: Text(
              isAr ? 'إعادة تجربة المستخدم الجديد لاختبار الفتح التدريجي' : 'Simulate fresh Day 1 installation',
              style: TextStyle(fontSize: 12, color: colors.textMute),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () async {
              await ref.read(isAdvancedFeaturesUnlockedProvider.notifier).resetToProgressive();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isAr ? 'تمت إعادة الضبط للوضع الافتراضي' : 'Reset to default')),
                );
              }
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

  void _showCuisineSelector(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final colors = context.vireoColors;
    final current = ref.read(cuisineProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.cuisineSettingTitle,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: CuisineType.values.map((c) {
                      final selected = c == current;
                      return ListTile(
                        title: Text(
                          c.localizedName(l10n),
                          style: TextStyle(
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: selected ? colors.ember : colors.text,
                          ),
                        ),
                        trailing: selected
                            ? Icon(Icons.check_rounded, color: colors.ember)
                            : null,
                        onTap: () {
                          ref.read(cuisineProvider.notifier).setCuisine(c);
                          Navigator.of(ctx).pop();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingsSectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.ember),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
