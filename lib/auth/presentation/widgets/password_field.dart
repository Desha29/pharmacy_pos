// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';
import '../widgets/custom_text_field.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final VoidCallback onSubmitted;
  final String? errorText;

  final Animation<Offset> errorSlideAnimation;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.errorText,
    required this.errorSlideAnimation,
    this.placeholder = 'Enter your password',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: label,
          placeholder: placeholder,
          isPassword: true,
          prefixIcon: Icons.lock_outline,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
        if (errorText != null) ...[
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 12)),
          SlideTransition(
            position: errorSlideAnimation,
            child: Text(errorText!, style: AppTextStyles.errorText(context)),
          ),
        ],
      ],
    );
  }
}
