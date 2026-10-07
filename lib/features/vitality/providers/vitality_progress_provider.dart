import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/vitality/data/vitality_daily_log.dart';
import 'package:vireo/features/vitality/domain/vitality_badge.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';

const _protocolProgressKey = 'vitality_protocol_progress';
const _badgeProgressKey = 'vitality_badge_progress';

class VitalityProgressRepository {
  const VitalityProgressRepository();

  Map<String, ProtocolTrackerState> loadProtocols() {
    if (!HiveService.isInitialized) return {};
    try {
      final raw = HiveService.cacheBox.get(_protocolProgressKey);
      if (raw is! Map) return {};
      return raw.map(
        (key, value) => MapEntry(
          key.toString(),
          ProtocolTrackerState.fromJson(
            Map<String, dynamic>.from(value as Map),
          ),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> saveProtocols(Map<String, ProtocolTrackerState> map) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(
        _protocolProgressKey,
        map.map((k, v) => MapEntry(k, v.toJson())),
      );
    } catch (_) {}
  }

  VitalityBadgeProgress loadBadges() {
    if (!HiveService.isInitialized) return const VitalityBadgeProgress();
    try {
      final raw = HiveService.cacheBox.get(_badgeProgressKey);
      if (raw is Map) {
        return VitalityBadgeProgress.fromJson(Map<String, dynamic>.from(raw));
      }
    } catch (_) {}
    return const VitalityBadgeProgress();
  }

  Future<void> saveBadges(VitalityBadgeProgress progress) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(_badgeProgressKey, progress.toJson());
    } catch (_) {}
  }
}

final vitalityProgressRepositoryProvider =
    Provider<VitalityProgressRepository>((ref) {
  return const VitalityProgressRepository();
});

class ProtocolProgressNotifier
    extends Notifier<Map<String, ProtocolTrackerState>> {
  @override
  Map<String, ProtocolTrackerState> build() {
    return ref.read(vitalityProgressRepositoryProvider).loadProtocols();
  }

  Future<void> toggleItem(String articleId, String itemId) async {
    final current = state[articleId] ?? const ProtocolTrackerState();
    final checked = Set<String>.from(current.checkedItemIds);
    if (checked.contains(itemId)) {
      checked.remove(itemId);
    } else {
      checked.add(itemId);
    }
    state = {
      ...state,
      articleId: current.copyWith(checkedItemIds: checked),
    };
    await ref.read(vitalityProgressRepositoryProvider).saveProtocols(state);
  }

  Future<void> completeProtocolDay(String articleId, int totalItems) async {
    if (totalItems <= 0) return;
    final current = state[articleId] ?? const ProtocolTrackerState();
    if (current.checkedItemIds.length < totalItems) return;

    final today = vitalityTodayDateKey();
    var streak = current.consecutiveDays;
    if (current.lastCompletedDateKey == today) {
      return;
    }
    final yesterday = _yesterdayKey();
    if (current.lastCompletedDateKey == yesterday) {
      streak += 1;
    } else {
      streak = 1;
    }

    state = {
      ...state,
      articleId: ProtocolTrackerState(
        checkedItemIds: const {},
        consecutiveDays: streak,
        lastCompletedDateKey: today,
      ),
    };
    await ref.read(vitalityProgressRepositoryProvider).saveProtocols(state);
    await ref.read(vitalityBadgeProgressProvider.notifier).onProtocolDayComplete(
          articleId: articleId,
          streak: streak,
        );
  }

  String _yesterdayKey() {
    final d = DateTime.now().subtract(const Duration(days: 1));
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }
}

final protocolProgressProvider =
    NotifierProvider<ProtocolProgressNotifier, Map<String, ProtocolTrackerState>>(
  ProtocolProgressNotifier.new,
);

class VitalityBadgeProgressNotifier extends Notifier<VitalityBadgeProgress> {
  @override
  VitalityBadgeProgress build() {
    return ref.read(vitalityProgressRepositoryProvider).loadBadges();
  }

  Future<void> _persist(VitalityBadgeProgress next) async {
    state = next;
    await ref.read(vitalityProgressRepositoryProvider).saveBadges(next);
  }

  Future<void> onProtocolDayComplete({
    required String articleId,
    required int streak,
  }) async {
    var next = state;
    if (articleId == 'zinc_vitamin_d_protocol') {
      next = next.copyWith(zincProtocolDayStreak: streak);
      if (streak >= 30 && !next.unlockedBadgeIds.contains('zinc_champion')) {
        next = next.copyWith(
          unlockedBadgeIds: {...next.unlockedBadgeIds, 'zinc_champion'},
        );
      }
    }
    if (articleId == 'big_5_compound_lifts' && streak >= 28) {
      final weeks = streak ~/ 7;
      next = next.copyWith(squatProtocolWeeks: weeks);
      if (weeks >= 4 && !next.unlockedBadgeIds.contains('squat_master')) {
        next = next.copyWith(
          unlockedBadgeIds: {...next.unlockedBadgeIds, 'squat_master'},
        );
      }
    }
    await _persist(next);
  }

  Future<void> onBreathingSession(int totalSessions) async {
    var next = state.copyWith(totalBreathingSessions: totalSessions);
    if (totalSessions >= 10 &&
        !next.unlockedBadgeIds.contains('stress_warrior')) {
      next = next.copyWith(
        unlockedBadgeIds: {...next.unlockedBadgeIds, 'stress_warrior'},
      );
    }
    await _persist(next);
  }

  Future<void> onSleepLogged(double hours) async {
    var streak = state.sleep8DayStreak;
    if (hours >= 8) {
      streak += 1;
    } else {
      streak = 0;
    }
    var next = state.copyWith(sleep8DayStreak: streak);
    if (streak >= 7 && !next.unlockedBadgeIds.contains('deep_sleeper')) {
      next = next.copyWith(
        unlockedBadgeIds: {...next.unlockedBadgeIds, 'deep_sleeper'},
      );
    }
    await _persist(next);
  }

  Future<void> onProteinGoalMet(bool met) async {
    var streak = state.proteinGoalDayStreak;
    streak = met ? streak + 1 : 0;
    var next = state.copyWith(proteinGoalDayStreak: streak);
    if (streak >= 14 && !next.unlockedBadgeIds.contains('protein_king')) {
      next = next.copyWith(
        unlockedBadgeIds: {...next.unlockedBadgeIds, 'protein_king'},
      );
    }
    await _persist(next);
  }
}

final vitalityBadgeProgressProvider =
    NotifierProvider<VitalityBadgeProgressNotifier, VitalityBadgeProgress>(
  VitalityBadgeProgressNotifier.new,
);


IconData vitalityCategoryIcon(VitalityCategory category) {
  return switch (category) {
    VitalityCategory.nutrition => Icons.restaurant_outlined,
    VitalityCategory.training => Icons.fitness_center_outlined,
    VitalityCategory.lifestyle => Icons.self_improvement_outlined,
    VitalityCategory.environmental => Icons.eco_outlined,
    VitalityCategory.advanced => Icons.science_outlined,
  };
}
