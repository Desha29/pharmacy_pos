import 'package:flutter/material.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/responsive.dart';

class AuthFormContainer extends StatelessWidget {
  final Widget child;

  const AuthFormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveHelper.getResponsiveCardWidth(context);
    final padding = ResponsiveHelper.isMobile(context) ? 24.0 : 40.0;
    final borderRadius = ResponsiveHelper.isMobile(context) ? 12.0 : 16.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveHelper.isMobile(context) ? 16 : 32,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: child,
    );
  }
}
