import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/app.dart';
import 'package:vireo/core/boot/boot_log.dart';

Future<void> main() async {
  BootLog.step('WidgetsFlutterBinding.ensureInitialized');
  WidgetsFlutterBinding.ensureInitialized();
  BootLog.ok('WidgetsFlutterBinding.ensureInitialized');

  BootLog.step('runApp');
  runApp(const ProviderScope(child: VireoApp()));
  BootLog.ok('runApp');
}
