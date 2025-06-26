import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/responsive/responsive_layout.dart';

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
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 20);
    final aspectRatio = 0.85;

    final crossAxisCount = ResponsiveHelper.isMobile(context)
        ? 1
        : ResponsiveHelper.isTablet(context)
        ? 2
        : 3;

    final products =
        List.generate(50, (index) {
          return {
            'name': 'Medicine #$index 500mg Extra Strength Pain Reliever',
            'price': (index + 1) * 3.75,
            'barcode': 'BC000$index',
            'company': 'Pharma Co.',
          };
        }).where((p) {
          final name = (p['name'] ?? '').toString().toLowerCase();
          final barcode = (p['barcode'] ?? '').toString().toLowerCase();
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
        return ProductCard(product: product, onAddToCart: onAddToCart);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductCard({
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
    final buttonHeight = ResponsiveHelper.getResponsiveSpacing(context, 38);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: AppStyles.bodyLarge.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing / 6),
                  FittedBox(
                    child: Text(
                      'Barcode: ${product['barcode']}',
                      style: AppStyles.caption.copyWith(fontSize: smallFontSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      'Company: ${product['company']}',
                      style: AppStyles.caption.copyWith(fontSize: smallFontSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: spacing / 6),
                  FittedBox(
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
            SizedBox(height: spacing / 4),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: FittedBox(
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
            ),
          ],
        ),
      ),
    );
  }
}
