import 'package:flutter/material.dart';
import 'package:pharmacy_pos/core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String hintText;

  const SearchInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search by name or barcode...',
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 12.0);
    return Padding(
      padding: EdgeInsets.only(left: spacing),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: AppColors.textGray),
            hintText: hintText,
            hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textGray),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
