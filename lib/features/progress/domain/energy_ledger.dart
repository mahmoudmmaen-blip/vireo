import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/activity/domain/acsm_net_energy.dart';

@immutable
class EnergyLedgerDay {
  const EnergyLedgerDay({
    required this.dateKey,
    required this.intakeKcal,
    required this.adaptiveTdee,
    required this.netActivityKcal,
    required this.steps,
    required this.distanceMeters,
  });

  final String dateKey;
  final int intakeKcal;
  final int adaptiveTdee;
  final int netActivityKcal;
  final int steps;
  final double distanceMeters;

  /// Intake − TDEE (negative = deficit / fat loss direction).
  int get balanceKcal => intakeKcal - adaptiveTdee;

  Map<String, dynamic> toJson() => {
        'date': dateKey,
        'intake': intakeKcal,
        'tdee': adaptiveTdee,
        'activity': netActivityKcal,
        'steps': steps,
        'distance_m': distanceMeters,
      };

  factory EnergyLedgerDay.fromJson(Map<String, dynamic> j) {
    return EnergyLedgerDay(
      dateKey: j['date']?.toString() ?? '',
      intakeKcal: (j['intake'] as num?)?.toInt() ?? 0,
      adaptiveTdee: (j['tdee'] as num?)?.toInt() ?? 0,
      netActivityKcal: (j['activity'] as num?)?.toInt() ?? 0,
      steps: (j['steps'] as num?)?.toInt() ?? 0,
      distanceMeters: (j['distance_m'] as num?)?.toDouble() ?? 0,
    );
  }

  EnergyLedgerDay copyWith({
    int? intakeKcal,
    int? adaptiveTdee,
    int? netActivityKcal,
    int? steps,
    double? distanceMeters,
  }) {
    return EnergyLedgerDay(
      dateKey: dateKey,
      intakeKcal: intakeKcal ?? this.intakeKcal,
      adaptiveTdee: adaptiveTdee ?? this.adaptiveTdee,
      netActivityKcal: netActivityKcal ?? this.netActivityKcal,
      steps: steps ?? this.steps,
      distanceMeters: distanceMeters ?? this.distanceMeters,
    );
  }
}

enum LedgerPeriod { today, week, month, allTime }

@immutable
class EnergyLedgerTotals {
  const EnergyLedgerTotals({
    required this.netActivityKcal,
    required this.balanceKcal,
    required this.steps,
    required this.distanceMeters,
    required this.days,
  });

  final int netActivityKcal;
  final int balanceKcal;
  final int steps;
  final double distanceMeters;
  final int days;

  /// Fat equivalent from energy balance (deficit → positive fat kg estimate).
  double get fatKgFromBalance {
    final deficit = -balanceKcal; // negative balance = surplus; we want deficit
    return deficit / AcsmNetEnergy.kcalPerKgFat;
  }

  double get activityFatKgEstimate =>
      netActivityKcal / AcsmNetEnergy.kcalPerKgFat;
}

/// Incremental cumulative energy ledger (Hive). Nightly reconcile fixes edits.
abstract final class EnergyLedger {
  static const hiveKey = 'energy_ledger_v1';
  static const milestoneEveryKcal = 10000;

  static Map<String, EnergyLedgerDay> loadAll() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.settingsBox.get(hiveKey);
    if (raw is! String || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final days = map['days'] as Map<String, dynamic>? ?? {};
      return days.map(
        (k, v) => MapEntry(
          k,
          EnergyLedgerDay.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveAll(Map<String, EnergyLedgerDay> days) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(
      hiveKey,
      jsonEncode({
        'days': days.map((k, v) => MapEntry(k, v.toJson())),
      }),
    );
  }

  static String dateKey(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$d';
  }

  /// Incremental upsert — cheap for UI path.
  static Future<EnergyLedgerDay> upsertDay(EnergyLedgerDay day) async {
    final all = loadAll();
    all[day.dateKey] = day;
    await saveAll(all);
    return day;
  }

  static EnergyLedgerTotals totalsFor(
    Map<String, EnergyLedgerDay> all, {
    required LedgerPeriod period,
    DateTime? now,
    DateTime? installDate,
  }) {
    final n = now ?? DateTime.now();
    final today = dateKey(n);
    Iterable<EnergyLedgerDay> selected;
    switch (period) {
      case LedgerPeriod.today:
        selected = [if (all[today] != null) all[today]!];
      case LedgerPeriod.week:
        final start = n.subtract(Duration(days: n.weekday % 7));
        selected = all.values.where((d) {
          final dt = DateTime.tryParse(d.dateKey);
          return dt != null && !dt.isBefore(DateTime(start.year, start.month, start.day));
        });
      case LedgerPeriod.month:
        selected = all.values.where((d) => d.dateKey.startsWith(
              '${n.year}-${n.month.toString().padLeft(2, '0')}',
            ));
      case LedgerPeriod.allTime:
        selected = all.values;
    }
    final list = selected.toList();
    return EnergyLedgerTotals(
      netActivityKcal: list.fold(0, (s, e) => s + e.netActivityKcal),
      balanceKcal: list.fold(0, (s, e) => s + e.balanceKcal),
      steps: list.fold(0, (s, e) => s + e.steps),
      distanceMeters: list.fold(0.0, (s, e) => s + e.distanceMeters),
      days: list.length,
    );
  }

  /// Full recompute from day map (for nightly reconcile equality checks).
  static EnergyLedgerTotals recomputeAll(Map<String, EnergyLedgerDay> all) {
    return totalsFor(all, period: LedgerPeriod.allTime);
  }

  /// Nightly reconcile: replace days with authoritative snapshots.
  static Future<void> reconcile(Map<String, EnergyLedgerDay> authoritative) async {
    final current = loadAll();
    current.addAll(authoritative);
    // Drop empty orphan keys not in authoritative if provided as full window.
    await saveAll(current);
  }

  static int milestonesReached(int cumulativeActivityKcal) {
    if (cumulativeActivityKcal <= 0) return 0;
    return cumulativeActivityKcal ~/ milestoneEveryKcal;
  }

  /// Honesty check: activity-based fat estimate vs trend weight change.
  static String divergenceNoteAr({
    required double activityFatKgEstimate,
    required double? trendWeightChangeKg,
  }) {
    if (trendWeightChangeKg == null) {
      return 'تقديري من النشاط — سجّل وزنك عشان نقارن';
    }
    final lost = -trendWeightChangeKg;
    if ((activityFatKgEstimate - lost).abs() > 0.5) {
      return 'الفرق عن ميزان الوزن غالباً مية أو نقص تسجيل — تقديري';
    }
    return 'متوافق تقريباً مع اتجاه الوزن — تقديري';
  }
}
