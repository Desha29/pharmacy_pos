// FILE: admin_inventory_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/animations/animations.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/constants/colors.dart';
import '../../../pos/data/models/product_model.dart';
import '../../../pos/presentation/cubits/pos_cubit.dart';
import '../../../pos/presentation/cubits/pos_state.dart';
import '../widgets/add_product_dialog.dart';

class AdminInventoryPage extends StatelessWidget {
   AdminInventoryPage({super.key});
  
 

  
  

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
    final isMobile = ResponsiveHelper.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => ProductDialog(
            onSubmit: (newProduct) {
              context.read<PosCubit>().addProduct(newProduct);
            },
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: TweenAnimationBuilder<double>(
        duration: AnimationConstants.slow,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: Container(
                margin: padding,
                decoration: AppStyles.cardDecoration,
                padding: EdgeInsets.all(isMobile ? 32 : 8),

                child: Padding(
                  padding: padding,
                  child: BlocBuilder<PosCubit, PosState>(
                    builder: (context, state) {
                      final products = state.products;
                      if (state.loadingProducts) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (products.isEmpty) {
                        return const Center(
                          child: Text('No products available'),
                        );
                      }

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
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    product.imageUrl ??
                                                    'assets/images/medicine.jpg',
                                                errorWidget: (context, url, error) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    child: Image.asset(
                                                      'assets/images/medicine.jpg',
                                                      fit: BoxFit.cover,
                                                      width: 1200,
                                                      height: 800,
                                                    ),
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                                width: 1200,
                                                height: 800,
                                              ),
                                            ),
                                          ),
                                        ),

                                        /// NAME
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
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
                                        SizedBox(height: spacing / 4),

                                        /// STOCK
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Stock: ${product.stock}',
                                            style: AppStyles.caption.copyWith(
                                              fontSize: labelSize,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: spacing / 4),

                                        /// PRICE
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: AppStyles.bodyLarge.copyWith(
                                              fontSize: priceSize,
                                              color: AppColors.primaryBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// ACTIONS
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () => showDialog(
  context: context,
  builder: (_) => ProductDialog(
    product: product,
    onSubmit: (updatedProduct) {
      context.read<PosCubit>().updateProduct(updatedProduct);
    },
  ),
)),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<PosCubit>()
                                              .removeProduct(product);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
