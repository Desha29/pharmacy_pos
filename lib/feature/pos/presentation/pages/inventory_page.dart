// FILE: inventory_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/constants/colors.dart';

import '../cubits/pos_cubit.dart';
import '../cubits/pos_state.dart';

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

    final crossAxisCount = ResponsiveHelper.getGridColumns(context);
    final aspectRatio = ResponsiveHelper.getCardAspectRatio(context);

    return Padding(
      padding: padding,
      child: BlocBuilder<PosCubit, PosState>(
        builder: (context, state) {
          final products = state.products;
          if (state.loadingProducts) {
            return const Center(child: CircularProgressIndicator());
          }
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Material(
                    elevation: 3,
                    borderRadius: cardRadius,
                    child: Container(
                      padding: EdgeInsets.all(spacing),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: cardRadius,
                        border: Border.all(color: AppColors.borderGray),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              child: ClipRRect(
                                borderRadius: cardRadius * 2,
                                child: Image.asset(
                                  height: 300,
                                  width: 600,
                                  product.imageUrl?? 'assets/images/p1.jpg',
                                   errorBuilder: (context, error, stackTrace) {
                      return ClipRRect(
                         borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          fit: BoxFit.cover,
                            height: 400,
                                            width: 800,
                          'assets/images/medicine.jpg'),
                      );
                    },
                              
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.name,
                                      style: AppStyles.bodyLarge.copyWith(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(height: spacing / 4),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Stock: ${product.stock}',
                                      style: AppStyles.caption.copyWith(
                                        fontSize: labelSize,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(height: spacing / 4),
                                const Spacer(),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: AppStyles.bodyLarge.copyWith(
                                        fontSize: priceSize,
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
