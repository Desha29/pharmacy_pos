import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/pos_cubit.dart';
import '../cubits/pos_state.dart';
import 'product_grid.dart';

class ProductGridLoader extends StatelessWidget {
  final String searchQuery;
  final Function(Map<String, dynamic>) onAddToCart;

  const ProductGridLoader({
    super.key,
    required this.searchQuery,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state.loadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }

        final filtered = state.products.where((p) {
          final name = p.name.toLowerCase();
          final barcode = p.barcode.toLowerCase();
          return name.contains(searchQuery.toLowerCase()) ||
              barcode.contains(searchQuery.toLowerCase());
        }).toList();

        return ProductGrid(
          searchQuery: searchQuery,
          products: filtered,
          onAddToCart: onAddToCart,
        );
      },
    );
  }
}