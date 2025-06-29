import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/invoice_model.dart';
import '../cubits/invoice_cubit.dart';

class InvoiceDetailPanel extends StatelessWidget {
   InvoiceDetailPanel({
    super.key,
    required this.spacing,
    required this.isTablet,
    required this.invoice,
    required this.onPressed 
  });
  final double spacing;
  final bool isTablet;
  final InvoiceModel invoice;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isTablet ? 280 : 350,
      margin: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Invoice: ${invoice.id}', style: AppStyles.heading3),
          const SizedBox(height: 4),
          Text(
            'Date: ${invoice.date.toLocal().toIso8601String().split('T')[0]}',
            style: AppStyles.caption,
          ),
          const SizedBox(height: 12),
          Text(
            'Items:',
            style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: invoice.products.length,
              itemBuilder: (_, index) {
                final product = invoice.products[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          product.name,
                          style: AppStyles.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${product.quantity} x \$${product.price.toStringAsFixed(2)}',
                          style: AppStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 24),
          Text(
            'Total: \$${invoice.total.toStringAsFixed(2)}',
            style: AppStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.close, color: Colors.red),
            label: const Text('Close', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
