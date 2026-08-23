import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vireo/features/habits/data/datasources/habit_local_data_source.dart';
import 'package:vireo/features/habits/data/models/habit_model.dart';

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  HabitLocalDataSourceImpl(this._prefs);

  static const storageKey = 'habits_v1';

  final SharedPreferences _prefs;

  @override
  Future<List<HabitModel>> getHabits() async {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => HabitModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveHabits(List<HabitModel> habits) async {
    final encoded = jsonEncode(habits.map((habit) => habit.toJson()).toList());
    await _prefs.setString(storageKey, encoded);
  }
}
