import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/colors.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 16.0);
    final padding = ResponsiveHelper.getResponsivePadding(context);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
    final labelSize = ResponsiveHelper.getResponsiveFontSize(context, 14);
    final priceSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
    final cardRadius = BorderRadius.circular(12);

    return Padding(
      padding: padding,
      child: GridView.builder(
        itemCount: 20,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.getGridColumns(context),
          childAspectRatio: ResponsiveHelper.getCardAspectRatio(context),
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          return Material(
            elevation: 2,
            borderRadius: cardRadius,
            child: Container(
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: cardRadius,
                border: Border.all(color: AppColors.borderGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product #$index',
                    style: AppStyles.bodyLarge.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing / 4),
                  Text(
                    'Stock: ${20 + index}',
                    style: AppStyles.caption.copyWith(fontSize: labelSize),
                  ),
                  const Spacer(),
                  Text(
                    '\$${(15.00 + index * 2).toStringAsFixed(2)}',
                    style: AppStyles.bodyLarge.copyWith(
                      fontSize: priceSize,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
