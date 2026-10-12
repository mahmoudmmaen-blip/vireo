import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/services/health_steps_service.dart';
import 'package:vireo/features/walking/data/step_permission.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepNotificationsScreen extends ConsumerStatefulWidget {
  const StepNotificationsScreen({super.key});

  @override
  ConsumerState<StepNotificationsScreen> createState() =>
      _StepNotificationsScreenState();
}

class _StepNotificationsScreenState
    extends ConsumerState<StepNotificationsScreen> {
  bool _mealReminders = true;
  bool _workoutReminders = true;
  bool _weeklyCheckin = true;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 7,
      stepName: 'notifications',
    );
  }

  Future<void> _requestAndContinue() async {
    setState(() => _isRequesting = true);

    try {
      final plugin = FlutterLocalNotificationsPlugin();
      // Only request system permission if user accepts / taps button
      await plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      // Best-effort request Health Connect READ_STEPS and activity recognition
      if (HealthStepsService.isSupported) {
        await HealthStepsService.requestPermission();
      }
      await StepPermission.request();
    } catch (_) {
      // Best-effort permission request; never block onboarding
    }

    final draft = ref.read(onboardingProvider).draft;
    ref.read(onboardingProvider.notifier).updateDraft(
          draft.copyWith(
            walkingReminderEnabled: _mealReminders,
            weeklyCheckInReminderEnabled: _weeklyCheckin,
          ),
        );

    await AnalyticsService.onboardingStepCompleted(
      stepIndex: 7,
      stepName: 'notifications',
      properties: {
        'meal_reminders': _mealReminders,
        'workout_reminders': _workoutReminders,
        'weekly_checkin': _weeklyCheckin,
      },
    );

    if (mounted) {
      setState(() => _isRequesting = false);
      ref.read(onboardingProvider.notifier).nextStep();
    }
  }

  void _skip() {
    AnalyticsService.onboardingStepCompleted(
      stepIndex: 7,
      stepName: 'notifications',
      properties: {'skipped': true},
    );
    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 7,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingNotificationsTitle,
      subtitle: l10n.onboardingNotificationsSubtitle,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _skip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Explanation card
          FadeSlideIn(
            index: 0,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(VRadius.lg),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.ember.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: colors.ember,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.notificationsHeroTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.notificationsHeroBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMute,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Toggles
          FadeSlideIn(
            index: 1,
            child: _ReminderToggleTile(
              title: l10n.notificationsMealLoggingTitle,
              subtitle: l10n.notificationsMealLoggingDesc,
              icon: Icons.restaurant_rounded,
              value: _mealReminders,
              onChanged: (v) => setState(() => _mealReminders = v),
            ),
          ),
          const SizedBox(height: 10),

          FadeSlideIn(
            index: 2,
            child: _ReminderToggleTile(
              title: l10n.notificationsWorkoutSessionTitle,
              subtitle: l10n.notificationsWorkoutSessionDesc,
              icon: Icons.fitness_center_rounded,
              value: _workoutReminders,
              onChanged: (v) => setState(() => _workoutReminders = v),
            ),
          ),
          const SizedBox(height: 10),

          FadeSlideIn(
            index: 3,
            child: _ReminderToggleTile(
              title: l10n.notificationsWeeklyReviewTitle,
              subtitle: l10n.notificationsWeeklyReviewDesc,
              icon: Icons.bar_chart_rounded,
              value: _weeklyCheckin,
              onChanged: (v) => setState(() => _weeklyCheckin = v),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          FadeSlideIn(
            index: 4,
            child: Pressable(
              onTap: _isRequesting ? null : _requestAndContinue,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: colors.ember,
                  borderRadius: BorderRadius.circular(VRadius.md),
                ),
                alignment: Alignment.center,
                child: _isRequesting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.notificationsEnableButton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          FadeSlideIn(
            index: 5,
            child: TextButton(
              onPressed: _skip,
              child: Text(
                l10n.notificationsMaybeLater,
                style: TextStyle(
                  color: colors.textMute,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderToggleTile extends StatelessWidget {
  const _ReminderToggleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(VRadius.sm),
            ),
            child: Icon(icon, size: 20, color: colors.ember),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMute,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.ember,
          ),
        ],
      ),
    );
  }
}
