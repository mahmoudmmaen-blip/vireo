import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/accent_palette_provider.dart';
import 'package:vireo/core/services/app_skin_provider.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/theme_mode_provider.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';
import 'package:vireo/core/widgets/app_router.dart';

class VireoApp extends ConsumerWidget {
  const VireoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final textDirection = ref.watch(textDirectionProvider);
    final themeMode = ref.watch(themeModeProvider);
    final accent = ref.watch(accentPaletteProvider);
    final skin = ref.watch(appSkinProvider);

    // Special dark skins always render as dark theme.
    final effectiveMode = skin.isSpecialDark ? ThemeMode.dark : themeMode;

    return MaterialApp(
      title: 'Vireo',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const VireoScrollBehavior(),
      theme: AppTheme.lightWithAccent(accent),
      darkTheme: AppTheme.darkWithAccent(accent, skin),
      themeMode: effectiveMode,
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
