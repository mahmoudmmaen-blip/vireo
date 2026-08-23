import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/widgets/app_router.dart';

class VireoApp extends ConsumerWidget {
  const VireoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final textDirection = ref.watch(textDirectionProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Vireo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AppRouter(),
    );
  }
}
