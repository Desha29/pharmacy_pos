import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_layout.dart';
import 'animated_logo.dart';


class AuthLogoSection extends StatelessWidget {
  const AuthLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = ResponsiveHelper.getResponsiveLogoSize(context);
    final logoFontSize = ResponsiveHelper.getResponsiveFontSize(context, 32);

    return Column(
      children: [
        AnimatedLogo(size: logoSize, fontSize: logoFontSize),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 20)),
      ],
    );
  }
}
