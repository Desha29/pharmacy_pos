// 📁 lib/feature/pos/presentation/pages/widgets/cart_panel.dart
import 'package:flutter/material.dart';
import 'package:pharmacy_pos/core/constants/colors.dart';
import '../../../../../core/responsive/responsive_layout.dart';
import '../../../../../core/theme/text_styles.dart';

class CartPanel extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(String) onRemove;
  final Function(String) onIncrease;
  final Function(String) onDecrease;

  const CartPanel({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  double get total => widget.cartItems.fold(
      0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 12.0);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 14);
    final titleFontSize = ResponsiveHelper.getResponsiveFontSize(context, 18);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderGray),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(spacing),
      child: Column(
        children: [
          Text(
            'Cart Summary',
            style: AppStyles.logoTitle(context).copyWith(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing),
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListView.separated(
                    itemCount: widget.cartItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing / 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'], style: AppStyles.bodyLarge.copyWith(fontSize: fontSize)),
                                  Text('Barcode: ${item['barcode']}', style: AppStyles.caption.copyWith(fontSize: fontSize)),
                                  Text('Company: ${item['company']}', style: AppStyles.caption.copyWith(fontSize: fontSize)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => widget.onDecrease(item['barcode']),
                                ),
                                Text('${item['quantity']}', style: AppStyles.bodyMedium.copyWith(fontSize: fontSize)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => widget.onIncrease(item['barcode']),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                              child: Text(
                                '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: AppStyles.bodyLarge.copyWith(
                                  fontSize: fontSize + 1,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => widget.onRemove(item['barcode']),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: AppStyles.bodyLarge.copyWith(fontSize: fontSize + 1)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Checkout'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
