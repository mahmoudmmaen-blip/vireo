import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/steps/step1_body_metrics.dart';
import 'package:vireo/features/onboarding/steps/step2_health_screening.dart';
import 'package:vireo/features/onboarding/steps/step3_training_environment.dart';
import 'package:vireo/features/onboarding/steps/step4_goal.dart';
import 'package:vireo/features/onboarding/steps/step5_consent.dart';
import 'package:vireo/features/onboarding/steps/step6_notifications.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const routes = <Widget>[
    Step1BodyMetrics(),
    Step2HealthScreening(),
    Step3TrainingEnvironment(),
    Step4Goal(),
    Step5Consent(),
    Step6Notifications(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(onboardingProvider).step;
    return routes[step.clamp(0, routes.length - 1)];
  }
}
