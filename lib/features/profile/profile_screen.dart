import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
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
                  return ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(state.user.email ?? l10n.authSignedIn),
                        subtitle: Text(l10n.profileCloudSynced),
                      ),
                      sub.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (snapshot) {
                          if (snapshot.hasPremiumAccess) {
                            return ListTile(
                              leading: const Icon(Icons.workspace_premium),
                              title: Text(l10n.subscriptionPremiumActive),
                              subtitle: Text(
                                _planLabel(l10n, snapshot.activePlanId),
                              ),
                            );
                          }
                          return ListTile(
                            leading: const Icon(Icons.lock_open),
                            title: Text(l10n.subscriptionFreeTier),
                            trailing: TextButton(
                              onPressed: () => openPaywall(context),
                              child: Text(l10n.subscriptionUpgrade),
                            ),
                          );
                        },
                      ),
                    ],
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

  String _planLabel(AppLocalizations l10n, SubscriptionPlanId? planId) {
    switch (planId) {
      case SubscriptionPlanId.monthly:
        return l10n.paywallPlanMonthly;
      case SubscriptionPlanId.annual:
        return l10n.paywallPlanAnnual;
      case SubscriptionPlanId.lifetime:
        return l10n.paywallPlanLifetime;
      case null:
        return l10n.subscriptionPremiumActive;
    }
  }
}

class _GuestProfileBody extends StatelessWidget {
  const _GuestProfileBody({required this.onSaveProgress});

  final VoidCallback onSaveProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.guestModeTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.guestModeSubtitle),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _GuestStatCard(
                  icon: Icons.fitness_center_outlined,
                  label: l10n.profileStatWorkoutsLabel,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GuestStatCard(
                  icon: Icons.local_fire_department_outlined,
                  label: l10n.profileStatStreakLabel,
                  colors: colors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onSaveProgress,
            child: Text(l10n.saveProgressToCloud),
          ),
        ],
      ),
    );
  }
}

class _GuestStatCard extends StatelessWidget {
  const _GuestStatCard({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final VireoColors colors;

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
              '0',
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
