import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_pos/core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../cubits/pos_cubit.dart';


class CartPanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 12.0);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 14);
    final titleFontSize = ResponsiveHelper.getResponsiveFontSize(context, 18);

    final total = context.read<PosCubit>().getTotal(
      context.read<PosCubit>().state.activeTabIndex,
    );

    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.borderGray),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(spacing),
        child: Column(
          children: [
          
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Cart Summary',
                maxLines: 1,
                style: AppStyles.logoTitle(context).copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: spacing),

          // Cart Items List
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Cart is empty'),
                      ),
                    )
                  : ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(),
                      padding: EdgeInsets.only(bottom: spacing),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing / 2),
                          child: Container(
                            padding: EdgeInsets.all(spacing),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(spacing),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Item Info
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.bodyLarge.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Barcode: ${item['barcode']}',
                                        style: AppStyles.caption.copyWith(fontSize: 13),
                                      ),
                                      Text(
                                        'Company: ${item['company']}',
                                        style: AppStyles.caption.copyWith(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),

                              
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: IconButton(
                                          icon: Icon(Icons.remove_circle_outline, size: 22),
                                          color: Colors.red.shade400,
                                          onPressed: () => onDecrease(item['barcode']),
                                          tooltip: 'Decrease',
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${item['quantity']}',
                                            style: AppStyles.bodyMedium.copyWith(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: IconButton(
                                          icon: Icon(Icons.add_circle_outline, size: 22),
                                          color: Colors.green.shade600,
                                          onPressed: () => onIncrease(item['barcode']),
                                          tooltip: 'Increase',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                    textAlign: TextAlign.center,
                                    style: AppStyles.bodyLarge.copyWith(
                                      fontSize: 15,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                             
                                Flexible(
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 22),
                                    tooltip: 'Remove',
                                    color: Colors.red,
                                    onPressed: () => onRemove(item['barcode']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Total & Checkout
            const Divider(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Total:',
                        style: AppStyles.bodyLarge.copyWith(
                          fontSize: fontSize + 1,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: fontSize + 2,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const FittedBox(child: Text('Checkout')),
                onPressed: () {
                  final currentState = context.read<PosCubit>().state;
                  context.read<PosCubit>().checkout(currentState.activeTabIndex,context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
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
