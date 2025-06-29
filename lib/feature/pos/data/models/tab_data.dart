
import 'package:flutter/material.dart';

class TabData {
  final List<Map<String, dynamic>> cartItems;
  final TextEditingController searchController;
  final String searchQuery;

  TabData({
    List<Map<String, dynamic>>? cartItems,
    TextEditingController? searchController,
    this.searchQuery = '',
  })  : cartItems = cartItems ?? [],
        searchController = searchController ?? TextEditingController();

  TabData copyWith({
    List<Map<String, dynamic>>? cartItems,
    TextEditingController? searchController,
    String? searchQuery,
  }) {
    return TabData(
      cartItems: cartItems ?? this.cartItems,
      searchController: searchController ?? this.searchController,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}