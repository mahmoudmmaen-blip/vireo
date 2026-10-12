import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/auth/auth_screen.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/diet_programs/screens/diet_program_detail_screen.dart';
import 'package:vireo/features/diet_programs/screens/diet_programs_screen.dart';
import 'package:vireo/features/notifications/screens/notification_settings_screen.dart';
import 'package:vireo/features/profile/appearance_screen.dart';
import 'package:vireo/features/profile/privacy_settings_screen.dart';
import 'package:vireo/features/profile/settings_screen.dart';
import 'package:vireo/features/profile/widgets/profile_body_metrics_sheet.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';
import 'package:vireo/features/subscription/widgets/subscription_status_banner.dart';

const _displayNameKey = 'profile_display_name';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final sub = ref.watch(subscriptionProvider);
    final locale = Localizations.localeOf(context).languageCode;

    return FeatureScaffold(
      title: l10n.profileTitle,
      leading: IconButton(
        tooltip: l10n.homeTitle,
        icon: const BackButtonIcon(),
        onPressed: () => ref.read(shellTabIndexProvider.notifier).goHome(),
      ),
      body: auth.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
        data: (state) {
          return ListView(
            padding: const EdgeInsets.all(VSpace.md),
            children: [
              sub.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (snapshot) {
                  if (snapshot.accessLevel == SubscriptionAccessLevel.trialActive &&
                      snapshot.trialDaysRemaining != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: VSpace.sm),
                      child: SubscriptionStatusBanner(
                        trialDaysRemaining: snapshot.trialDaysRemaining!,
                        onUpgrade: () => openPaywall(context),
                      ),
                    );
                  }
                  if (snapshot.shouldShowExpiredGate) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: VSpace.sm),
                      child: ExpiredSubscriptionBanner(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              _ProfileHeaderCard(authState: state),
              if (state.isGuest) ...[
                const SizedBox(height: VSpace.md),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
                  ),
                  child: Text(l10n.profileSaveProgressCta),
                ),
              ],
              const SizedBox(height: VSpace.lg),
              Text(
                l10n.profileMyBody,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: VSpace.sm),
              _MyBodyCard(
                onEdit: () => showProfileBodyMetricsSheet(context, ref),
              ),
              const SizedBox(height: VSpace.lg),
              Text(
                l10n.profileMyPlanSection,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: VSpace.sm),
              _MyPlanCard(locale: locale),
              _SettingsGroup(
                children: [
                  ListTile(
                    leading: Icon(Icons.palette_outlined, color: context.vireoColors.ember),
                    title: Text(l10n.appearanceTitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AppearanceScreen()),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: context.vireoColors.ember),
                    title: Text(l10n.settingsTitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_outlined, color: context.vireoColors.ember),
                    title: Text(l10n.notificationsTitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NotificationSettingsScreen(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: context.vireoColors.ember),
                    title: Text(locale.startsWith('ar') ? 'الخصوصية وإدارة البيانات' : 'Privacy & Data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacySettingsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              if (!state.isGuest && state is AppAuthAuthenticated) ...[
                const SizedBox(height: VSpace.md),
                OutlinedButton(
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                  child: Text(l10n.signOut),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeaderCard extends ConsumerWidget {
  const _ProfileHeaderCard({required this.authState});

  final AppAuthState authState;

  String _displayName() {
    if (HiveService.isInitialized) {
      final stored = HiveService.cacheBox.get(_displayNameKey) as String?;
      if (stored != null && stored.trim().isNotEmpty) return stored.trim();
    }
    if (authState is AppAuthAuthenticated) {
      final email = (authState as AppAuthAuthenticated).user.email;
      if (email != null && email.contains('@')) return email.split('@').first;
    }
    return 'Vireo';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final sub = ref.watch(subscriptionProvider).valueOrNull;
    final isPro = sub?.hasPremiumAccess == true;
    final name = _displayName();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    String? emailLine;
    String? memberSince;
    if (authState is AppAuthAuthenticated) {
      final user = (authState as AppAuthAuthenticated).user;
      if (user.isAnonymous) {
        emailLine = l10n.profileGuestProgressHint;
      } else {
        emailLine = user.email ?? l10n.authSignedIn;
        final created = user.createdAt;
        if (created.isNotEmpty) {
          final dt = DateTime.tryParse(created);
          if (dt != null) {
            memberSince = l10n.profileMemberSince(
              DateFormat.yMMMd().format(dt),
            );
          }
        }
      }
    } else if (authState is AppAuthGuest) {
      emailLine = l10n.profileGuestProgressHint;
    }

    return VireoCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: colors.ember.withValues(alpha: 0.2),
            child: Text(
              initial,
              style: TextStyle(
                color: colors.ember,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: VSpace.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => _editName(context, name),
              ),
            ],
          ),
          if (emailLine != null)
            Text(
              emailLine,
              style: TextStyle(color: colors.textMute),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: VSpace.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (isPro ? colors.gold : colors.line).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              isPro ? l10n.profilePlanPro : l10n.profilePlanFree,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isPro ? colors.gold : colors.textMute,
              ),
            ),
          ),
          if (memberSince != null) ...[
            const SizedBox(height: 6),
            Text(memberSince, style: TextStyle(color: colors.textMute, fontSize: 12)),
          ],
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                Localizations.localeOf(context).languageCode.startsWith('ar')
                    ? 'المزامنة السحابية: جاهز دون اتصال'
                    : 'Cloud Sync: Offline-Ready',
                style: TextStyle(
                  color: colors.textMute,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editName(BuildContext context, String current) async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: current);
    final next = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileEditDisplayName),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.profileDisplayNameHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.reassessmentLater)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(l10n.profileSaveBodyMetrics),
          ),
        ],
      ),
    );
    if (next != null && next.isNotEmpty && HiveService.isInitialized) {
      await HiveService.cacheBox.put(_displayNameKey, next);
    }
  }
}

class _MyBodyCard extends StatelessWidget {
  const _MyBodyCard({required this.onEdit});

  final VoidCallback onEdit;

  Map<String, dynamic> _profile() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.cacheBox.get('guest_profile');
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final map = _profile();
    final age = (map['age'] as num?)?.toInt() ?? 30;
    final height = (map['height_cm'] as num?)?.toDouble() ?? 170;
    final weight = (map['weight_kg'] as num?)?.toDouble() ?? 75;
    final activity = ActivityLevel.fromValue(
      map['activity_level'] as String? ?? ActivityLevel.moderatelyActive.value,
    );
    final goal = FitnessGoal.fromValue(
      map['goal'] as String? ?? FitnessGoal.generalVitality.value,
    );

    return VireoCard(
      onTap: onEdit,
      child: Column(
        children: [
          _BodyRow(label: l10n.onboardingAge, value: '$age'),
          _BodyRow(label: l10n.onboardingHeight, value: '${height.round()} cm'),
          _BodyRow(label: l10n.onboardingWeight, value: '${weight.toStringAsFixed(1)} kg'),
          _BodyRow(label: l10n.profileFitnessGoal, value: _goal(l10n, goal)),
          _BodyRow(label: l10n.profileActivityLevel, value: _activity(l10n, activity)),
        ],
      ),
    );
  }

  String _goal(AppLocalizations l10n, FitnessGoal g) => switch (g) {
        FitnessGoal.weightLoss => l10n.goalWeightLoss,
        FitnessGoal.muscleGain => l10n.goalMuscleGain,
        FitnessGoal.generalVitality => l10n.goalGeneralVitality,
        FitnessGoal.allOfAbove => l10n.goalAllOfAbove,
      };

  String _activity(AppLocalizations l10n, ActivityLevel a) => switch (a) {
        ActivityLevel.sedentary => l10n.activitySedentary,
        ActivityLevel.moderatelyActive => l10n.activityModerate,
        ActivityLevel.veryActive => l10n.activityVeryActive,
      };
}

class _MyPlanCard extends ConsumerWidget {
  const _MyPlanCard({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final program = ref.watch(activeDietProgramProvider);
    final targets = ref.watch(activeDietTargetsProvider);

    return VireoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.restaurant_menu_rounded, color: context.vireoColors.ember),
            title: Text(program?.name.of(locale) ?? l10n.dietChoosePlanCard),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.dietMyPlan),
                if (targets != null && (targets.deficitKcal > 0 || targets.weeklyLossKg > 0)) ...[
                  const SizedBox(height: 2),
                  FatEquivalentBadge(
                    customText: FatEquivalent.dietPlanRateText(
                      dailyDeficitKcal: targets.deficitKcal,
                      weeklyLossKg: targets.weeklyLossKg,
                      l10n: l10n,
                      lang: locale,
                    ),
                    style: TextStyle(
                      color: context.vireoColors.ember,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                    showIcon: false,
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (program != null) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DietProgramDetailScreen(programId: program.id),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DietProgramsScreen(),
                  ),
                );
              }
            },
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const DietProgramsScreen()),
            ),
            child: Text(l10n.profileChangeDietPlan),
          ),
        ],
      ),
    );
  }
}

class _BodyRow extends StatelessWidget {
  const _BodyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VireoCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}
