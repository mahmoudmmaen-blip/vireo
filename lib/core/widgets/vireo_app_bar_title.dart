import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/vireo_logo.dart';

/// Compact logo + "Vireo" wordmark for app bars.
class VireoAppBarTitle extends StatelessWidget {
  const VireoAppBarTitle({super.key, this.logoSize = 28});

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VireoLogo(size: logoSize),
        const SizedBox(width: 10),
        Text(
          'Vireo',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: colors.text,
          ),
        ),
      ],
    );
  }
}
