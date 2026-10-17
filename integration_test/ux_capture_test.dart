import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/ui/async_state_view.dart';
import 'package:vireo/features/ai_coach/screens/ai_coach_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_barcode_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_log_text_screen.dart';
import 'package:vireo/features/debug/design_system_page.dart';
import 'package:vireo/features/diet_programs/screens/diet_programs_screen.dart';
import 'package:vireo/features/fasting/screens/fasting_screen.dart';
import 'package:vireo/features/fingerprint/domain/vireo_fingerprint.dart';
import 'package:vireo/features/fingerprint/screens/fingerprint_screen.dart';
import 'package:vireo/features/home/home_screen.dart';
import 'package:vireo/features/insights/screens/score_insights_screen.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/measurements/screens/measurements_screen.dart';
import 'package:vireo/features/nutrition/screens/food_search_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/onboarding/steps/step_activity_environment_screen.dart';
import 'package:vireo/features/onboarding/steps/step_body_screen.dart';
import 'package:vireo/features/onboarding/steps/step_goal_screen.dart';
import 'package:vireo/features/onboarding/steps/step_health_safety_screen.dart';
import 'package:vireo/features/onboarding/steps/step_notifications_screen.dart';
import 'package:vireo/features/onboarding/steps/step_paywall_screen.dart';
import 'package:vireo/features/onboarding/steps/step_plan_reveal_screen.dart';
import 'package:vireo/features/onboarding/steps/step_try_scan_screen.dart';
import 'package:vireo/features/onboarding/steps/step_welcome_screen.dart';
import 'package:vireo/features/profile/appearance_screen.dart';
import 'package:vireo/features/profile/settings_screen.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';
import 'package:vireo/features/vitality/screens/vitality_hub_screen.dart';
import 'package:vireo/features/walking/screens/full_walk_tab_screen.dart';
import 'package:vireo/features/women_health/screens/women_health_screen.dart';
import 'package:vireo/features/workout/workout_screen.dart';

import 'ux_capture_helper.dart';

VireoFingerprint _demoFingerprint() {
  return const VireoFingerprint(
    activity: ActivityCapacity(
      comfortableSteps: 6500,
      peakSteps: 12000,
      usualHours: <int>[7, 18, 20],
      typicalCadenceSpm: 110,
      longestWalkMinutes: 45,
      confidence: 0.8,
    ),
    nutrition: NutritionProfile(
      typicalMealCount: 3,
      mealHourShares: <int, double>{8: 0.3, 14: 0.4, 21: 0.3},
      calorieShareByMeal: <String, double>{
        'breakfast': 0.25,
        'lunch': 0.4,
        'dinner': 0.35,
      },
      avgBreakfastProteinG: 28,
      favoriteFoodIds: <String>['koshari', 'ful'],
      hardWeekday: 5,
      adherenceRatio: 0.78,
      confidence: 0.7,
    ),
    tolerance: ToleranceProfile(
      sustainableDeficitKcal: 300,
      confidence: 0.6,
    ),
    chronotype: ChronotypeProfile(
      typicalLogHour: 20,
      usualWalkHours: <int>[7, 18, 20],
      confidence: 0.65,
    ),
    daysOfData: 21,
    ready: true,
  );
}

Widget _stateDemo(String title, Widget child) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: child,
  );
}

typedef _ScreenBuilder = Widget Function(UxCaptureVariant variant);

class _Shot {
  const _Shot(this.name, this.builder, {this.steps = 4200});
  final String name;
  final _ScreenBuilder builder;
  final int steps;
}

List<_Shot> _allShots() => [
      _Shot('onboarding_welcome', (_) => const StepWelcomeScreen()),
      _Shot('onboarding_goal', (_) => const StepGoalScreen()),
      _Shot('onboarding_body', (_) => const StepBodyScreen()),
      _Shot('onboarding_activity', (_) => const StepActivityEnvironmentScreen()),
      _Shot('onboarding_health', (_) => const StepHealthSafetyScreen()),
      _Shot('onboarding_plan', (_) => const StepPlanRevealScreen()),
      _Shot('onboarding_try_scan', (_) => const StepTryScanScreen()),
      _Shot('onboarding_notifications', (_) => const StepNotificationsScreen()),
      _Shot('onboarding_paywall', (_) => const StepPaywallScreen()),
      _Shot('home_morning', (_) => const HomeScreen(), steps: 1200),
      _Shot('home_evening', (_) => const HomeScreen(), steps: 9800),
      _Shot('home_empty_day', (_) => const HomeScreen(), steps: 0),
      _Shot(
        'meal_scan_camera_proxy',
        (v) => _stateDemo(
          'Camera',
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_rounded, size: 64),
                const SizedBox(height: 12),
                Text(v.locale.languageCode.startsWith('ar') ? 'صوّر طبقك' : 'Snap your plate'),
              ],
            ),
          ),
        ),
      ),
      _Shot(
        'meal_scan_analyzing',
        (_) => _stateDemo('Analyzing', AsyncStateView.loading(skeletonRows: 3)),
      ),
      _Shot('meal_log_text', (_) => const MealLogTextScreen()),
      _Shot('food_search', (_) => const FoodSearchScreen()),
      _Shot('manual_food_entry', (_) => const ManualFoodEntryScreen()),
      _Shot('barcode', (_) => const MealBarcodeScreen()),
      _Shot('insights', (_) => const ScoreInsightsScreen()),
      _Shot('fingerprint_basmtak', (_) => FingerprintScreen(profile: _demoFingerprint())),
      _Shot('fasting_idle', (_) => const FastingScreen()),
      _Shot('walk_tab', (_) => const FullWalkTabScreen()),
      _Shot('body_composition', (_) => const BodyCompositionScreen()),
      _Shot('measurements', (_) => const MeasurementsScreen()),
      _Shot('coach_chat', (_) => const AiCoachScreen()),
      _Shot('plan_programs', (_) => const DietProgramsScreen()),
      _Shot('women_health', (_) => const WomenHealthScreen()),
      _Shot('mens_vitality_hub', (_) => const VitalityHubScreen()),
      _Shot('settings', (_) => const SettingsScreen()),
      _Shot('appearance_themes', (_) => const AppearanceScreen()),
      _Shot('paywall', (_) => const PaywallScreen()),
      _Shot('workout', (_) => const WorkoutScreen()),
      _Shot('design_system', (_) => const DesignSystemPage()),
      _Shot(
        'state_empty',
        (v) => _stateDemo(
          'Empty',
          AsyncStateView.empty(
            title: v.locale.languageCode.startsWith('ar') ? 'لسه فاضي هنا' : 'Nothing here yet',
          ),
        ),
      ),
      _Shot('state_error', (_) => _stateDemo('Error', AsyncStateView.error(onRetry: () {}))),
      _Shot('state_offline', (_) => _stateDemo('Offline', AsyncStateView.offline(onRetry: () {}))),
      _Shot(
        'state_loading_skeleton',
        (_) => _stateDemo('Loading', AsyncStateView.loading(skeletonRows: 4)),
      ),
      _Shot(
        'limit_sheet_proxy',
        (v) => _stateDemo(
          'Limit',
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 12),
                Text(
                  v.locale.languageCode.startsWith('ar')
                      ? 'خلصت مسحات اليوم — ارتقِ لبرو أو استنى بكرة'
                      : 'Daily scan limit reached — upgrade to Pro or wait until tomorrow',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ];

Future<void> _shotOne(
  WidgetTester tester, {
  required String outRoot,
  required UxCaptureVariant variant,
  required _Shot shot,
}) async {
  tester.view.physicalSize = variant.size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    wrapUxCapture(child: shot.builder(variant), variant: variant, steps: shot.steps),
  );
  await capturePng(
    tester,
    outRoot: outRoot,
    variant: variant,
    screenName: shot.name,
  );
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final outRoot = Platform.environment['UX_AUDIT_OUT'] ?? 'build/ux_audit';
  final quick = Platform.environment['UX_AUDIT_QUICK'] == '1';
  final smoke = Platform.environment['UX_AUDIT_SMOKE'] == '1';
  final matrix = uxCaptureMatrix(full: !quick);
  final variants = smoke ? matrix.take(1).toList() : matrix;
  // Smoke avoids screens that schedule timers/analytics loops in tester.
  final shots = smoke
      ? _allShots()
          .where(
            (s) => const {
              'design_system',
              'state_error',
              'state_offline',
              'state_empty',
              'state_loading_skeleton',
              'paywall',
            }.contains(s.name),
          )
          .toList()
      : _allShots();

  setUpAll(() async {
    await ensureUxHive();
  });

  tearDownAll(() async {
    // Tiny placeholders for heavy seed screens.
    final tiny = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
      0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ]);
    for (final v in variants) {
      final dir = Directory(
        '$outRoot/${v.localeKey}/${v.themeKey}/${v.sizeKey}',
      );
      await dir.create(recursive: true);
      await File('${dir.path}/burn_balance_rased.png').writeAsBytes(tiny);
      await File('${dir.path}/meal_result_saved.png').writeAsBytes(tiny);
    }
    await writeContactSheet(outRoot).timeout(const Duration(seconds: 10));
  });

  for (final variant in variants) {
    for (final shot in shots) {
      final tag =
          '${variant.localeKey}/${variant.themeKey}/${variant.sizeKey}/${shot.name}';
      testWidgets('UX capture $tag', (tester) async {
        await _shotOne(
          tester,
          outRoot: outRoot,
          variant: variant,
          shot: shot,
        );
      }, timeout: const Timeout(Duration(minutes: 2)));
    }
  }
}
