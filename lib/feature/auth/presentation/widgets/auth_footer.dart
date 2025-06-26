import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '© 2025 Pharma POS. All rights reserved.',
        style: AppStyles.footerText(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
