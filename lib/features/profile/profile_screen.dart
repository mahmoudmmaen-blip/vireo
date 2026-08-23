import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/bmi_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/auth/widgets/guest_auth_gate.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/profile/settings_screen.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';
import 'package:vireo/features/subscription/widgets/subscription_status_banner.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final sub = ref.watch(subscriptionProvider);

    return FeatureScaffold(
      title: l10n.profileTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
      ],
      body: Column(
        children: [
          sub.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (snapshot) {
              if (snapshot.accessLevel == SubscriptionAccessLevel.trialActive &&
                  snapshot.trialDaysRemaining != null) {
                return SubscriptionStatusBanner(
                  trialDaysRemaining: snapshot.trialDaysRemaining!,
                  onUpgrade: () => openPaywall(context),
                );
              }
              if (snapshot.shouldShowExpiredGate) {
                return const ExpiredSubscriptionBanner();
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: auth.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
              data: (state) {
                if (state is AppAuthGuest) {
                  return _GuestProfileBody(
                    onSaveProgress: () async {
                      await requireAccountAccess(
                        context,
                        ref,
                        reason: AuthGateReason.saveProgress,
                      );
                      final userId = ref.read(authProvider).valueOrNull?.user?.id;
                      if (userId != null) {
                        await ref
                            .read(onboardingRepositoryProvider)
                            .syncGuestProfileToCloud(userId: userId);
                      }
                    },
                  );
                }
                if (state is AppAuthAuthenticated) {
                  return _RegisteredProfileBody(
                    email: state.user.email ?? l10n.authSignedIn,
                    displayName: state.user.email?.split('@').first ?? 'Vireo',
                  );
                }
                return Center(child: Text(l10n.authTitle));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestProfileBody extends StatelessWidget {
  const _GuestProfileBody({required this.onSaveProgress});

  final VoidCallback onSaveProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final profile = HiveService.cacheBox.get('guest_profile');
    final map = profile is Map ? Map<String, dynamic>.from(profile) : <String, dynamic>{};
    final weight = (map['weight_kg'] as num?)?.toDouble() ?? 75.0;
    final height = (map['height_cm'] as num?)?.toDouble() ?? 170.0;
    final activity = ActivityLevel.fromValue(
      map['activity_level'] as String? ?? ActivityLevel.moderatelyActive.value,
    );
    final bmi = BmiCalculator.compute(weightKg: weight, heightCm: height);
    final bmiCategory = BmiCalculator.categoryFor(bmi);
    final goalWeight = (weight - 5).clamp(50.0, 200.0);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colors.surfaceRaised,
          child: Text(
            l10n.profileGuestAvatar,
            style: TextStyle(color: colors.ember, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.guestModeTitle,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(l10n.guestModeSubtitle, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _GuestStatCard(
                icon: Icons.fitness_center_outlined,
                label: l10n.profileStatWorkoutsLabel,
                value: '7',
                colors: colors,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GuestStatCard(
                icon: Icons.local_fire_department_outlined,
                label: l10n.profileStatStreakLabel,
                value: '3',
                colors: colors,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _GuestStatCard(
          icon: Icons.calendar_today_outlined,
          label: l10n.profileStatProgramDays,
          value: '14',
          colors: colors,
          fullWidth: true,
        ),
        const SizedBox(height: 24),
        Text(l10n.profileStatsSection, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _StatRow(label: l10n.profileGoalWeight, value: '${goalWeight.toStringAsFixed(1)} kg'),
        _BmiStatRow(
          label: l10n.profileCurrentBmi,
          bmi: bmi,
          category: bmiCategory,
        ),
        _StatRow(label: l10n.profileActivityLevel, value: _activityLabel(l10n, activity)),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: onSaveProgress, child: Text(l10n.saveProgressToCloud)),
      ],
    );
  }

  String _activityLabel(AppLocalizations l10n, ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => l10n.activitySedentary,
      ActivityLevel.moderatelyActive => l10n.activityModerate,
      ActivityLevel.veryActive => l10n.activityVeryActive,
    };
  }
}

class _RegisteredProfileBody extends StatelessWidget {
  const _RegisteredProfileBody({
    required this.email,
    required this.displayName,
  });

  final String email;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colors.ember.withValues(alpha: 0.2),
          child: Text(
            displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
            style: TextStyle(
              color: colors.ember,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(displayName, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
        Text(email, style: TextStyle(color: colors.textMute), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.edit_outlined),
          label: Text(l10n.profileEditProfile),
        ),
      ],
    );
  }
}

class _BmiStatRow extends StatelessWidget {
  const _BmiStatRow({
    required this.label,
    required this.bmi,
    required this.category,
  });

  final String label;
  final double bmi;
  final BmiCategory category;

  String _categoryLabel(AppLocalizations l10n) {
    return switch (category) {
      BmiCategory.underweight => l10n.profileBmiUnderweight,
      BmiCategory.healthy => l10n.profileBmiHealthy,
      BmiCategory.overweight => l10n.profileBmiOverweight,
      BmiCategory.obese => l10n.profileBmiObese,
    };
  }

  Color _categoryColor(VireoColors colors) {
    return switch (category) {
      BmiCategory.underweight => colors.recovery,
      BmiCategory.healthy => colors.success,
      BmiCategory.overweight => colors.gold,
      BmiCategory.obese => colors.danger,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final tagColor = _categoryColor(colors);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Tooltip(
            message: l10n.profileBmiTooltip,
            preferBelow: false,
            child: Icon(Icons.info_outline, size: 18, color: colors.textMute),
          ),
          const SizedBox(width: 8),
          Text(
            bmi.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tagColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              _categoryLabel(l10n),
              style: TextStyle(
                color: tagColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

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

class _GuestStatCard extends StatelessWidget {
  const _GuestStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VireoColors colors;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            Icon(icon, color: colors.ember, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMute, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
