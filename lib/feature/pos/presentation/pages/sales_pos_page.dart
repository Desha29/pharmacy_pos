import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../data/models/tab_data.dart';
import '../cubits/pos_cubit.dart';
import '../cubits/pos_state.dart';
import '../widgets/product_grid_loader.dart';
import '../widgets/search_input.dart';
import '../widgets/product_grid.dart';
import '../widgets/cart_panel.dart';

class SalesPOSPage extends StatelessWidget {
  const SalesPOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 16);

    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        final tab = state.tabs[state.activeTabIndex];
        final isMobile = ResponsiveHelper.isMobile(context);
        final isTablet = ResponsiveHelper.isTablet(context);
        final isDesktop = !isMobile && !isTablet;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // Tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(state.tabs.length, (index) {
                            final isActive = index == state.activeTabIndex;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    context.read<PosCubit>().switchTab(index),
                                child: Chip(
                                  label: Text("POS ${index + 1}"),
                                  backgroundColor: isActive
                                      ? Colors.blue.shade100
                                      : Colors.grey.shade200,
                                  labelStyle: TextStyle(
                                    color: isActive
                                        ? Colors.blue
                                        : Colors.black87,
                                  ),
                                  deleteIcon:
                                      index != 0 && state.tabs.length > 1
                                      ? const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 18,
                                        )
                                      : null,
                                  onDeleted: index != 0 && state.tabs.length > 1
                                      ? () => context
                                            .read<PosCubit>()
                                            .removeTab(index)
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.read<PosCubit>().addNewTab(),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Main Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(spacing),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Products & Search
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            SearchInput(
                              controller: tab.searchController,
                              onChanged: (value) {
                                context.read<PosCubit>().updateSearchQuery(
                                  state.activeTabIndex,
                                  value,
                                );
                              },
                            ),
                            SizedBox(height: spacing),
                            Expanded(
                              child: ProductGridLoader(
                                searchQuery: tab.searchQuery,
                                onAddToCart: (product) => context
                                    .read<PosCubit>()
                                    .addToCart(state.activeTabIndex, product),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right: CartPanel or Button
                      if (isDesktop) ...[
                        SizedBox(width: spacing),
                        Expanded(
                          flex: 2,
                          child: CartPanel(
                            cartItems: tab.cartItems,
                            onRemove: (barcode) => context
                                .read<PosCubit>()
                                .removeFromCart(state.activeTabIndex, barcode),
                            onIncrease: (barcode) =>
                                context.read<PosCubit>().increaseQuantity(
                                  state.activeTabIndex,
                                  barcode,
                                ),
                            onDecrease: (barcode) =>
                                context.read<PosCubit>().decreaseQuantity(
                                  state.activeTabIndex,
                                  barcode,
                                ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 15),
                        Expanded(
                          child: FittedBox(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showCartBottomSheet(
                                  context,
                                  tab,
                                  state.activeTabIndex,
                                );
                              },
                              icon: FittedBox(
                                child: const Icon(Icons.shopping_cart),
                              ),
                              label: FittedBox(child: const Text("Open Cart")),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 6,
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCartBottomSheet(BuildContext context, TabData tab, int tabIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),

          child: FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.85,
            child: Center(
              child: CartPanel(
                cartItems: tab.cartItems,
                onRemove: (barcode) =>
                    context.read<PosCubit>().removeFromCart(tabIndex, barcode),
                onIncrease: (barcode) => context
                    .read<PosCubit>()
                    .increaseQuantity(tabIndex, barcode),
                onDecrease: (barcode) => context
                    .read<PosCubit>()
                    .decreaseQuantity(tabIndex, barcode),
              ),
            ),
          ),
        );
      },
    );
  }
}
