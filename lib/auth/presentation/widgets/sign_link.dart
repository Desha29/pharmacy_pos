import 'package:flutter/material.dart';
import '../../../core/utils/animations.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';

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
          Text(label, style: AppTextStyles.bodyText(context)),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          GestureDetector(
            onTap: onTap,
            child: AnimatedDefaultTextStyle(
              duration: AnimationConstants.fast,
              style: AppTextStyles.linkText(context),
              child: Text(linkText),
            ),
          ),
        ],
      ),
    );
  }
}
