import 'package:flutter/material.dart';
import 'package:pharmacy_pos/core/constants/colors.dart';
import '../../../../../core/theme/text_styles.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const SearchInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          hintText: 'Search by name or barcode...',
          hintStyle: AppStyles.bodyMedium.copyWith(
            color: AppColors.textGray,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
