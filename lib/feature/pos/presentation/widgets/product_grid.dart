import 'package:flutter/material.dart';
import 'package:pharmacy_pos/feature/pos/data/models/product_model.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/responsive/responsive_layout.dart';

class ProductGrid extends StatelessWidget {
  final String searchQuery;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductGrid({
    super.key,
    required this.searchQuery,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 10);
    final aspectRatio = 0.7;

    final crossAxisCount = ResponsiveHelper.isMobile(context)
        ? 2
        : ResponsiveHelper.isTablet(context)
        ? 2
        : 3;

    final products =
        List.generate(50, (index) {
          return ProductModel(
            name: 'Medicine #$index 500mg Extra Strength Pain Reliever',
            price: (index + 1) * 3.75,
            barcode: 'BC000$index',
            company: 'Pharma Co.',
            imageUrl: 'assets/images/medicine.jpg',
          );
        }).where((p) {
          final name = (p.name).toString().toLowerCase();
          final barcode = (p.barcode).toString().toLowerCase();
          return name.contains(searchQuery) || barcode.contains(searchQuery);
        }).toList();

    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardMap(product: {
          'name': product.name,
          'price': product.price,
          'barcode': product.barcode,
          'company': product.company,
          'imageUrl': product.imageUrl,
        }, onAddToCart: onAddToCart);
      },
    );
  }
}
class ProductCardMap extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductCardMap({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
    final priceFontSize = ResponsiveHelper.getResponsiveFontSize(context, 15);
    final smallFontSize = ResponsiveHelper.getResponsiveFontSize(context, 13);
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 16);
    final padding = ResponsiveHelper.getResponsiveSpacing(context, 12);
    

    return Material(
      elevation: 3,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                          Flexible(
                    child: FittedBox(
                      child: ClipRRect(
                     
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          height: 300,
                         width: 600,
                          product['imageUrl'] ?? 'assets/images/p1.jpg',
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
                spacing: spacing / 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
    
                  Expanded(
                    flex: 2,
                    child: Text(
                      product['name'],
                      style: AppStyles.bodyLarge.copyWith(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Flexible(
                    child: Text(
                      'Barcode: ${product['barcode']}',
                      style: AppStyles.caption.copyWith(
                        fontSize: smallFontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '\$${(product['price'] as num).toStringAsFixed(2)}',
                      style: AppStyles.bodyLarge.copyWith(
                        fontSize: priceFontSize,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            FittedBox(
              child: ElevatedButton.icon(
                onPressed: () => onAddToCart(product),
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
