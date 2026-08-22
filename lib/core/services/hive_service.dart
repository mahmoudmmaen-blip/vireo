import 'package:hive_flutter/hive_flutter.dart';

/// Local offline storage via Hive.
abstract final class HiveService {
  static const settingsBoxName = 'settings';
  static const cacheBoxName = 'cache';

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
      await Hive.openBox<dynamic>(settingsBoxName);
      await Hive.openBox<dynamic>(cacheBoxName);
      _initialized = true;
    } catch (_) {
      rethrow;
    }
  }

  static Box<dynamic> get settingsBox => Hive.box<dynamic>(settingsBoxName);

  static Box<dynamic> get cacheBox => Hive.box<dynamic>(cacheBoxName);
}
