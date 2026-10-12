import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:vireo/app.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/crash_monitoring_service.dart';
import 'package:vireo/core/services/hive_service.dart';

Future<void> main() async {
  BootLog.step('WidgetsFlutterBinding.ensureInitialized');
  WidgetsFlutterBinding.ensureInitialized();
  BootLog.ok('WidgetsFlutterBinding.ensureInitialized');

  try {
    await HiveService.init();
  } catch (e) {
    BootLog.warn('HiveService.init in main failed — fallback in AppInitNotifier', e);
  }

  void startApp() {
    BootLog.step('runApp');
    runApp(const ProviderScope(child: VireoApp()));
    BootLog.ok('runApp');
  }

  if (AppConfig.sentryDsn.trim().isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = AppConfig.sentryDsn.trim();
        options.environment = AppConfig.appEnvironment;
        options.release = AppConfig.appRelease;
        // Strip sensitive user and health data before sending
        options.beforeSend = (event, hint) {
          return event.copyWith(
            user: null,
          );
        };
      },
      appRunner: () => runZonedGuarded(
        () {
          startApp();
        },
        (error, stack) {
          CrashMonitoringService.recordError(error, stack, fatal: true);
        },
      ),
    );
  } else {
    runZonedGuarded(
      () {
        startApp();
      },
      (error, stack) {
        CrashMonitoringService.recordError(error, stack, fatal: true);
      },
    );
  }
}

