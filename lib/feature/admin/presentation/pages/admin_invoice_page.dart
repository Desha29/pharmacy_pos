import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_pos/core/constants/colors.dart';
import 'package:pharmacy_pos/core/theme/text_styles.dart';
import 'package:pharmacy_pos/core/responsive/responsive_layout.dart';
import 'package:pharmacy_pos/feature/pos/presentation/cubits/invoice_cubit.dart';
import 'package:pharmacy_pos/feature/pos/presentation/cubits/invoice_state.dart';


import '../../../pos/data/models/invoice_model.dart';
import '../../../pos/presentation/widgets/search_input.dart';

/// 🔹 Admin Invoice Management Page
class AdminInvoicePage extends StatelessWidget {
  const AdminInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 8);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            context.read<InvoiceCubit>().loadInvoices(); // Load invoices

            return Column(
              children: [
                // 🔍 Search + Sort row
                Padding(
                  padding: EdgeInsets.all(spacing),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SearchInput(
                          hintText: "Search invoices...",
                          controller: state.searchController,
                          onChanged: (val) =>
                              context.read<InvoiceCubit>().updateSearchQuery(val),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderGray),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: FittedBox(
                              child: DropdownButton<String>(
                                hint: Text(
                                  'Sort invoices by...',
                                  style: AppStyles.bodyMedium.copyWith(color: AppColors.primaryBlue),
                                ),
                                value: state.sortBy,
                                onChanged: (val) =>
                                    context.read<InvoiceCubit>().updateSortBy(val!),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textGray,
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                style: AppStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                isDense: true,
                                items: const [
                                  DropdownMenuItem(value: 'Date Desc', child: Text('Date ↓')),
                                  DropdownMenuItem(value: 'Date Asc', child: Text('Date ↑')),
                                  DropdownMenuItem(value: 'Total Desc', child: Text('Total ↓')),
                                  DropdownMenuItem(value: 'Total Asc', child: Text('Total ↑')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 📋 Invoices Grid + Detail
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(spacing),
                          child: GridView.builder(
                            itemCount: state.filteredInvoices.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing,
                              childAspectRatio: 1.3,
                            ),
                            itemBuilder: (_, index) {
                              final invoice = state.filteredInvoices[index];
                              return _buildInvoiceCard(
                                context,
                                invoice,
                                spacing,
                                isMobile,
                                isTablet,
                              );
                            },
                          ),
                        ),
                      ),

                      // Right-side details (desktop only)
                      if (!isMobile && state.selectedInvoice != null)
                        _buildInvoiceDetailPanel(
                          context,
                          spacing,
                          isTablet,
                          state.selectedInvoice!,
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 🧾 Invoice card in the grid
  Widget _buildInvoiceCard(
    BuildContext context,
    InvoiceModel invoice,
    double spacing,
    bool isMobile,
    bool isTablet,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(invoice.id, style: AppStyles.heading3),
            SizedBox(height: spacing / 2),
            Text('Date: ${invoice.date.toLocal().toIso8601String().split('T')[0]}',
                style: AppStyles.caption),
            SizedBox(height: spacing / 2),
            Text('Items: ${invoice.products.length}', style: AppStyles.caption),
            SizedBox(height: spacing / 2),
            Text(
              'Total: \$${invoice.total.toStringAsFixed(2)}',
              style: AppStyles.bodyLarge.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (isMobile || isTablet) {
                  _showInvoiceBottomSheet(context, invoice, spacing);
                } else {
                  context.read<InvoiceCubit>().selectInvoice(invoice);
                }
              },
              icon: const Icon(Icons.receipt_long, size: 18),
              label: const Text("Details"),
            ),
            const SizedBox(height: 8),
            Icon(
              invoice.isSynced ? Icons.sync : Icons.sync_disabled,
              color: invoice.isSynced ? Colors.green : Colors.redAccent,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  /// 📑 Detail side panel
  Widget _buildInvoiceDetailPanel(
    BuildContext context,
    double spacing,
    bool isTablet,
    InvoiceModel invoice,
  ) {
    return Container(
      width: isTablet ? 280 : 350,
      margin: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Invoice: ${invoice.id}', style: AppStyles.heading3),
          const SizedBox(height: 4),
          Text('Date: ${invoice.date.toLocal().toIso8601String().split('T')[0]}',
              style: AppStyles.caption),
          const SizedBox(height: 12),
          Text('Items:', style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
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
                        child: Text(product.name,
                            style: AppStyles.bodyMedium,
                            overflow: TextOverflow.ellipsis),
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
        ],
      ),
    );
  }

  /// 📱 Bottom sheet for mobile/tablet
  void _showInvoiceBottomSheet(
    BuildContext context,
    InvoiceModel invoice,
    double spacing,
  ) {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final isTablet = ResponsiveHelper.isTablet(context);
        final screenHeight = MediaQuery.of(context).size.height;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
              child: _buildInvoiceDetailPanel(context, spacing, isTablet, invoice),
            ),
          ),
        );
      },
    );
  }
}
