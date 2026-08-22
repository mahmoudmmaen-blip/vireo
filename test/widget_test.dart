import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

void main() {
  testWidgets('AppTheme is dark-only and exposes VireoColors §2.1', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const Scaffold(body: SizedBox()),
      ),
    );

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(materialApp.theme?.brightness, Brightness.dark);
    expect(materialApp.theme?.scaffoldBackgroundColor, VireoColors.dark.background);
    expect(
      materialApp.theme?.extension<VireoColors>()?.ember,
      const Color(0xFFE8763C),
    );
  });
}
