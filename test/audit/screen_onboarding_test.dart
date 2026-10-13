import 'package:vireo/features/onboarding/steps/step_welcome_screen.dart';
import 'package:vireo/features/onboarding/steps/step_goal_screen.dart';
import 'package:vireo/features/onboarding/steps/step_body_screen.dart';
import 'package:vireo/features/onboarding/steps/step_activity_environment_screen.dart';
import 'package:vireo/features/onboarding/steps/step_health_safety_screen.dart';
import 'package:vireo/features/onboarding/steps/step_try_scan_screen.dart';
import 'package:vireo/features/onboarding/steps/step_plan_reveal_screen.dart';
import 'package:vireo/features/onboarding/steps/step_notifications_screen.dart';
import 'package:vireo/features/onboarding/steps/step_paywall_screen.dart';
import 'audit_test_helper.dart';

void main() {
  testScreenOverflow('Onboarding Step 1', () => const StepWelcomeScreen());
  testScreenOverflow('Onboarding Step 2', () => const StepGoalScreen());
  testScreenOverflow('Onboarding Step 3', () => const StepBodyScreen());
  testScreenOverflow('Onboarding Step 4', () => const StepActivityEnvironmentScreen());
  testScreenOverflow('Onboarding Step 5', () => const StepHealthSafetyScreen());
  testScreenOverflow('Onboarding Step 6', () => const StepTryScanScreen());
  testScreenOverflow('Onboarding Step 7', () => const StepPlanRevealScreen());
  testScreenOverflow('Onboarding Step 8', () => const StepNotificationsScreen());
  testScreenOverflow('Onboarding Step 9', () => const StepPaywallScreen());
}
