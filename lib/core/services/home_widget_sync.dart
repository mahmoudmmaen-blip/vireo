import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/services/widget_service.dart';
import 'package:vireo/features/fasting/providers/fasting_provider.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

/// Pushes current home metrics to the Android/iOS home widget.
Future<void> syncHomeScreenWidget(
  WidgetRef ref, {
  required BuildContext context,
  bool force = false,
}) async {
  final locale = ref.read(localeProvider).languageCode;
  final nutrition = ref.read(todayNutritionProvider(locale));
  final goalKcal = nutrition.goalKcal > 0 ? nutrition.goalKcal : 2000;
  final math = MascotFillMath(
    consumedKcal: nutrition.eatenKcal,
    targetKcal: goalKcal,
  );
  final expression = math.expressionAt(DateTime.now());
  final emoji = mascotExpressionEmoji(expression);

  final fastingState = ref.read(fastingProvider);
  final session = fastingState.activeSession;
  final fastingActive = fastingState.isFasting && session != null;
  final fastingMin = fastingActive ? session.remaining.inMinutes : 0;

  final brightness = Theme.of(context).brightness;
  final themeMode = ref.read(themeModeProvider);
  final isDark = themeMode == ThemeMode.dark ||
      (themeMode == ThemeMode.system && brightness == Brightness.dark);

  final isRtl = Directionality.of(context) == TextDirection.rtl;

  final score = ref.read(dailyScoreProvider).totalScore;
  final steps = ref.read(todayStepsProvider);
  final water = ref.read(waterTrackerProvider);

  await WidgetService.updateWidget(
    caloriesRemaining: nutrition.remainingKcal.clamp(0, 99999),
    mascotEmoji: emoji,
    fastingActive: fastingActive,
    fastingRemainingMinutes: fastingMin,
    isDarkTheme: isDark,
    isRtl: isRtl,
    steps: steps,
    waterMl: water,
    dailyScore: score,
    force: force,
  );
}
