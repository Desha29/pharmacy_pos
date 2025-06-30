import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/responsive/responsive_layout.dart';

class ProductGrid extends StatelessWidget {
  final String searchQuery;
  final Function(Map<String, dynamic>) onAddToCart;
  final List<ProductModel> products;

  const ProductGrid({
    super.key,
    required this.searchQuery,
    required this.onAddToCart,
    required this.products,
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

    final filtered = products.where((p) {
      final name = p.name.toLowerCase();
      final barcode = p.barcode.toLowerCase();
      return name.contains(searchQuery.toLowerCase()) ||
          barcode.contains(searchQuery.toLowerCase());
    }).toList();

    return GridView.builder(
      itemCount: filtered.length,
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final product = filtered[index];
        return ProductCardMap(
          product: product.toJson(),
          onAddToCart: onAddToCart,
        );
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
                    product['imageUrl'],
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
                      'Stock: ${product['stock']}',
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
