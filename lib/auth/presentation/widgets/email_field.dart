import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';
import '../widgets/custom_text_field.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final VoidCallback onSubmitted;
  final String? errorText;
final Animation<Offset> errorSlideAnimation;

  const EmailField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
       this.errorText,
    required this.errorSlideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Email Address',
          placeholder: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          controller: controller,
          onChanged: onChanged,
          onSubmitted:onSubmitted,
          keyboardType: TextInputType.emailAddress,
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
