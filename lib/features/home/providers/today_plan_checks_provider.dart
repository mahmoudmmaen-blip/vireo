import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const _todayPlanChecksKey = 'today_plan_checks';

String _todayDateKey() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

class TodayPlanChecksNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => _loadForToday();

  Set<String> _loadForToday() {
    if (!HiveService.isInitialized) return {};
    try {
      final raw = HiveService.cacheBox.get(_todayPlanChecksKey);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['date'] == _todayDateKey()) {
          final ids = map['checked'];
          if (ids is List) {
            return ids.map((e) => e.toString()).toSet();
          }
        }
      }
    } catch (_) {}
    return {};
  }

  Future<void> toggle(String id, {required bool value}) async {
    final next = Set<String>.from(state);
    if (value) {
      next.add(id);
    } else {
      next.remove(id);
    }
    state = next;
    await _persist(next);
  }

  Future<void> _persist(Set<String> ids) async {
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(_todayPlanChecksKey, {
      'date': _todayDateKey(),
      'checked': ids.toList(),
    });
  }
}

final todayPlanChecksProvider =
    NotifierProvider<TodayPlanChecksNotifier, Set<String>>(
  TodayPlanChecksNotifier.new,
);
