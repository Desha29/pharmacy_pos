import 'package:flutter/material.dart';
import '../../../../core/animations/animations.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';

class SignLink extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String linkText;
  const SignLink({
    super.key,
    required this.onTap,
    required this.label,
    required,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(label, style: AppStyles.bodyText(context)),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          GestureDetector(
            onTap: onTap,
            child: AnimatedDefaultTextStyle(
              duration: AnimationConstants.fast,
              style: AppStyles.linkText(context),
              child: Text(linkText),
            ),
          ),
        ],
      ),
    );
  }
}
