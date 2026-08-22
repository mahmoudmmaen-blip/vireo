import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/utils/date_utils.dart';
import 'package:vireo/data/models/progress_models.dart';

class ProgressRepository {
  const ProgressRepository();

  static const _weightCacheKey = 'weight_logs_cache';
  static const _adherenceCacheKey = 'adherence_weeks_cache';
  static const _energyCacheKey = 'energy_checkins_cache';

  Future<List<WeightLogEntry>> fetchWeightLogs() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final rows = await SupabaseService.client
              .from('weight_logs')
              .select()
              .eq('user_id', userId)
              .order('logged_at');

          final logs = (rows as List)
              .map((r) => WeightLogEntry.fromJson(Map<String, dynamic>.from(r)))
              .toList();
          await HiveService.cacheBox.put(
            _weightCacheKey,
            logs.map((e) => e.toJson()).toList(),
          );
          return logs;
        }
      }
    } catch (_) {
      // Fall through to cache/demo.
    }

    final cached = HiveService.cacheBox.get(_weightCacheKey);
    if (cached is List && cached.isNotEmpty) {
      return cached
          .map((r) => WeightLogEntry.fromJson(Map<String, dynamic>.from(r)))
          .toList();
    }

    return _demoWeightLogs();
  }

  Future<double?> fetchWeightGoalKg() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final row = await SupabaseService.client
              .from('users')
              .select('weight_goal_kg, weight_kg')
              .eq('id', userId)
              .maybeSingle();
          if (row != null) {
            final goal = row['weight_goal_kg'];
            if (goal != null) return (goal as num).toDouble();
            final weight = row['weight_kg'];
            if (weight != null) return (weight as num).toDouble();
          }
        }
      }
    } catch (_) {}

    final guest = HiveService.cacheBox.get('guest_profile');
    if (guest is Map && guest['weight_kg'] != null) {
      return (guest['weight_kg'] as num).toDouble();
    }
    return 75.0;
  }

  Future<void> logWeight({
    required double weightKg,
    DateTime? loggedAt,
  }) async {
    final at = loggedAt ?? DateTime.now();
    final entry = WeightLogEntry(
      id: 'local_${at.millisecondsSinceEpoch}',
      weightKg: weightKg,
      loggedAt: at,
    );

    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          await SupabaseService.client.from('weight_logs').insert({
            'user_id': userId,
            'weight_kg': weightKg,
            'logged_at': at.toUtc().toIso8601String(),
          });
          return;
        }
      }
    } catch (_) {
      rethrow;
    }

    final cached = HiveService.cacheBox.get(_weightCacheKey);
    final list = cached is List
        ? cached.map((r) => Map<String, dynamic>.from(r)).toList()
        : <Map<String, dynamic>>[];
    list.add(entry.toJson());
    await HiveService.cacheBox.put(_weightCacheKey, list);
  }

  Future<List<AdherenceWeek>> fetchAdherenceWeeks({int weeks = 8}) async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final rows = await SupabaseService.client
              .from('checkins')
              .select('adherence, adherence_pct, created_at, week_number')
              .eq('user_id', userId)
              .order('created_at');

          if ((rows as List).isNotEmpty) {
            final result = _adherenceFromCheckins(rows, weeks);
            await HiveService.cacheBox.put(_adherenceCacheKey, result
                .map((w) => {
                      'week_start': w.weekStart.toIso8601String(),
                      'completion_pct': w.completionPct,
                    })
                .toList());
            return result;
          }
        }
      }
    } catch (_) {}

    final cached = HiveService.cacheBox.get(_adherenceCacheKey);
    if (cached is List && cached.isNotEmpty) {
      return cached
          .map(
            (r) => AdherenceWeek(
              weekStart: DateTime.parse(r['week_start'] as String),
              completionPct: r['completion_pct'] as int,
            ),
          )
          .toList();
    }

    return _demoAdherenceWeeks(weeks);
  }

  List<AdherenceWeek> _adherenceFromCheckins(List rows, int weeks) {
    final mapped = rows
        .map((r) {
          final pct = r['adherence'] as int? ?? r['adherence_pct'] as int?;
          if (pct == null) return null;
          return AdherenceWeek(
            weekStart: DateTime.parse(r['created_at'] as String),
            completionPct: pct,
          );
        })
        .whereType<AdherenceWeek>()
        .toList();
    if (mapped.length >= weeks) return mapped.sublist(mapped.length - weeks);
    return mapped;
  }

  Future<List<EnergyCheckIn>> fetchEnergyCheckIns() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final rows = await SupabaseService.client
              .from('checkins')
              .select()
              .eq('user_id', userId)
              .not('energy_score', 'is', null)
              .order('created_at');

          if ((rows as List).isNotEmpty) {
            final list = rows
                .map((r) => EnergyCheckIn.fromJson(Map<String, dynamic>.from(r)))
                .toList();
            await HiveService.cacheBox.put(
              _energyCacheKey,
              rows,
            );
            return list;
          }
        }
      }
    } catch (_) {}

    final cached = HiveService.cacheBox.get(_energyCacheKey);
    if (cached is List && cached.isNotEmpty) {
      return cached
          .map((r) => EnergyCheckIn.fromJson(Map<String, dynamic>.from(r)))
          .toList();
    }

    return _demoEnergyCheckIns();
  }

  List<WeightLogEntry> _demoWeightLogs() {
    final now = DateTime.now();
    return List.generate(8, (i) {
      final date = now.subtract(Duration(days: (7 - i) * 7));
      return WeightLogEntry(
        id: 'demo-$i',
        weightKg: 82.0 - i * 0.4,
        loggedAt: date,
      );
    });
  }

  List<AdherenceWeek> _demoAdherenceWeeks(int weeks) {
    final now = DateTime.now();
    return List.generate(weeks, (i) {
      final pct = [55, 62, 70, 68, 75, 80, 72, 85][i % 8];
      return AdherenceWeek(
        weekStart: now.subtract(Duration(days: (weeks - 1 - i) * 7)),
        completionPct: pct,
      );
    });
  }

  List<EnergyCheckIn> _demoEnergyCheckIns() {
    final week = DateUtilsVireo.isoWeekNumber(DateTime.now());
    return List.generate(6, (i) {
      return EnergyCheckIn(
        weekNumber: week - (5 - i),
        energyScore: [4, 5, 6, 5, 7, 6][i],
        loggedAt: DateTime.now().subtract(Duration(days: (5 - i) * 7)),
      );
    });
  }
}
