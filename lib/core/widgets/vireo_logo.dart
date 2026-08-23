import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Vireo brand mark — orange ring with centered dot (#E8763C).
class VireoLogo extends StatelessWidget {
  const VireoLogo({super.key, this.size = 64});

  static const assetPath = 'assets/images/vireo_logo.svg';

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      semanticsLabel: 'Vireo',
    );
  }
}
