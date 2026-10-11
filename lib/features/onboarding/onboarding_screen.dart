import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/steps/step_activity_environment_screen.dart';
import 'package:vireo/features/onboarding/steps/step_body_screen.dart';
import 'package:vireo/features/onboarding/steps/step_goal_screen.dart';
import 'package:vireo/features/onboarding/steps/step_health_safety_screen.dart';
import 'package:vireo/features/onboarding/steps/step_notifications_screen.dart';
import 'package:vireo/features/onboarding/steps/step_paywall_screen.dart';
import 'package:vireo/features/onboarding/steps/step_plan_reveal_screen.dart';
import 'package:vireo/features/onboarding/steps/step_try_scan_screen.dart';
import 'package:vireo/features/onboarding/steps/step_welcome_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const routes = <Widget>[
    StepWelcomeScreen(),
    StepGoalScreen(),
    StepBodyScreen(),
    StepActivityEnvironmentScreen(),
    StepHealthSafetyScreen(),
    StepTryScanScreen(),
    StepPlanRevealScreen(),
    StepNotificationsScreen(),
    StepPaywallScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(onboardingProvider).step;
    return routes[step.clamp(0, routes.length - 1)];
  }
}
