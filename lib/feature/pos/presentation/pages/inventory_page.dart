import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/product_model.dart';

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

    final products = _dummyProducts();

    return Padding(
      padding: padding,
      child: LayoutBuilder(
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
                     
                        borderRadius: cardRadius*2,
                        child: Image.asset(
                          height: 300,
                         width: 600,
                          product.imageUrl ?? 'assets/images/p1.jpg',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 50, color: AppColors.textSecondary);
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
      ),
    );
  }

  List<ProductModel> _dummyProducts() {
    return List.generate(20, (i) {
      return ProductModel(
        name: 'Product ${i + 1}',
        price: 15.00 + i * 2,
        barcode: 'BC-000$i',
        company: 'Pharma Co. ${i + 1}',
        stock: 10 + i * 5,
        quantity: 1,
        imageUrl: 'assets/images/p1.jpg'
      );
    });
  }
}
