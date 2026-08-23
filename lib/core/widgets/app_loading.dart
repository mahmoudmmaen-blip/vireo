import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/vireo_logo.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VireoLogo(size: 96),
            const SizedBox(height: 20),
            Text(
              'Vireo',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w900,
                fontSize: 36,
                color: colors.ember,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.ember,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
