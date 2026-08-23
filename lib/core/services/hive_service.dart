import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';

/// Local offline storage via Hive.
/// On web, [Hive.initFlutter] uses IndexedDB — no filesystem paths required.
abstract final class HiveService {
  static const settingsBoxName = 'settings';
  static const cacheBoxName = 'cache';

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) {
      BootLog.step('HiveService.init skipped (already initialized)');
      return;
    }

    BootLog.step('HiveService.init');
    try {
      BootLog.step('Starting Hive.initFlutter...');
      // Web uses IndexedDB; native uses the app documents directory.
      await Hive.initFlutter().timeout(
        bootServiceTimeout,
        onTimeout: () => throw TimeoutException('Hive.initFlutter'),
      );
      BootLog.ok('Hive.initFlutter');

      BootLog.step('Starting Hive.openBox(settings)...');
      await Hive.openBox<dynamic>(settingsBoxName).timeout(
        bootServiceTimeout,
        onTimeout: () => throw TimeoutException('Hive.openBox(settings)'),
      );
      BootLog.ok('Hive.openBox(settings)');

      BootLog.step('Starting Hive.openBox(cache)...');
      await Hive.openBox<dynamic>(cacheBoxName).timeout(
        bootServiceTimeout,
        onTimeout: () => throw TimeoutException('Hive.openBox(cache)'),
      );
      BootLog.ok('Hive.openBox(cache)');

      _initialized = true;
      BootLog.ok('HiveService.init');
    } catch (e) {
      BootLog.warn('HiveService.init failed', e);
      rethrow;
    }
  }

  static Box<dynamic> get settingsBox {
    _ensureInitialized();
    return Hive.box<dynamic>(settingsBoxName);
  }

  static Box<dynamic> get cacheBox {
    _ensureInitialized();
    return Hive.box<dynamic>(cacheBoxName);
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('HiveService.init() must complete before accessing boxes.');
    }
  }
}
