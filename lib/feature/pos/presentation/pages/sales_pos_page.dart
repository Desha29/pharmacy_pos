
import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_layout.dart';
import 'widgets/cart_panel.dart';
import 'widgets/product_grid.dart';
import 'widgets/search_input.dart';

class SalesPOSPage extends StatefulWidget {
  const SalesPOSPage({super.key});

  @override
  State<SalesPOSPage> createState() => _SalesPOSPageState();
}

class _SalesPOSPageState extends State<SalesPOSPage> {
  final List<Map<String, dynamic>> cartItems = [];
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  void addToCart(Map<String, dynamic> product) {
    final index = cartItems.indexWhere((item) => item['barcode'] == product['barcode']);
    setState(() {
      if (index != -1) {
        cartItems[index]['quantity'] += 1;
      } else {
        cartItems.add({...product, 'quantity': 1});
      }
    });
  }

  void removeFromCart(String barcode) {
    setState(() {
      cartItems.removeWhere((item) => item['barcode'] == barcode);
    });
  }

  void increaseQuantity(String barcode) {
    final index = cartItems.indexWhere((item) => item['barcode'] == barcode);
    if (index != -1) {
      setState(() {
        cartItems[index]['quantity'] += 1;
      });
    }
  }

  void decreaseQuantity(String barcode) {
    final index = cartItems.indexWhere((item) => item['barcode'] == barcode);
    if (index != -1 && cartItems[index]['quantity'] > 1) {
      setState(() {
        cartItems[index]['quantity'] -= 1;
      });
    } else {
      removeFromCart(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final spacing = ResponsiveHelper.getResponsiveSpacing(context, 24);

    return Padding(
      padding: ResponsiveHelper.getScreenPadding(context),
      child: isMobile
          ? const Center(child: Text("Mobile layout coming soon"))
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchInput(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      SizedBox(height: spacing),
                      Expanded(
                        child: ProductGrid(
                          searchQuery: searchQuery,
                          onAddToCart: addToCart,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  flex: 2,
                  child: CartPanel(
                    cartItems: cartItems,
                    onRemove: removeFromCart,
                    onIncrease: increaseQuantity,
                    onDecrease: decreaseQuantity,
                  ),
                ),
              ],
            ),
    );
  }
}
