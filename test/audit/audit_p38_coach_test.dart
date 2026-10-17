import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/activity/services/outdoor_gps_tracker.dart';
import 'package:vireo/features/activity/widgets/outdoor_run_metrics_panel.dart';
import 'package:vireo/features/progress/domain/rebalance_engine.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';
import 'package:vireo/features/progress/widgets/rebalance_card.dart';
import 'package:vireo/features/progress/widgets/weekly_balance_chart.dart';

import 'audit_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 17);
  final deficit = WeeklyDeficitSummary(
    hasData: true,
    totalNetKcal: 3200,
    days: List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DailyDeficitEntry(
        date: d,
        tdee: 2200,
        consumed: 1800 + i * 50,
        burned: 200,
        isToday: i == 6,
      );
    }),
  );

  final rebalance = RebalanceEngine.evaluate(
    intakeKcal: 2400,
    targetKcal: 2000,
    proteinG: 100,
    proteinTargetG: 120,
    steps: 5000,
    stepGoal: 8000,
    weightKg: 75,
    strideMeters: 0.72,
    isFemale: false,
    isPregnancy: false,
    isUnder18: false,
    hourOfDay: 14,
    isRamadan: false,
    lighterMealSwaps: [(nameAr: 'شوفان', saveKcal: 100)],
  );

  testScreenOverflow(
    'RebalanceCard P38',
    () => Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RebalanceCard(result: rebalance),
      ),
    ),
  );

  testScreenOverflow(
    'WeeklyBalanceChart P38',
    () => Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: WeeklyBalanceChart(summary: deficit),
      ),
    ),
  );

  testScreenOverflow(
    'OutdoorRunMetricsPanel P38',
    () => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: OutdoorRunMetricsPanel(
          stats: OutdoorLiveStats.initial.copyWithCadence(110),
          paceOrSpeedLabel: '6:30',
        ),
      ),
    ),
  );
}

extension on OutdoorLiveStats {
  OutdoorLiveStats copyWithCadence(double cadence) {
    return OutdoorLiveStats(
      elapsedSeconds: elapsedSeconds,
      activeSeconds: activeSeconds,
      distanceMeters: 1250,
      speedKmh: 5.5,
      calories: 85,
      route: route,
      splits: splits,
      isPaused: isPaused,
      autoPauseEnabled: autoPauseEnabled,
      currentType: currentType,
      detectedType: detectedType,
      isManuallyOverridden: isManuallyOverridden,
      cadenceSpm: cadence,
    );
  }
}
