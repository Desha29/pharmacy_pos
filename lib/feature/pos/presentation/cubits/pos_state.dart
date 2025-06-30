import '../../data/models/product_model.dart';
import '../../data/models/tab_data.dart';

class PosState {
  final List<TabData> tabs;
  final int activeTabIndex;
  final List<ProductModel> products;
  final bool loadingProducts;

  PosState({
    required this.tabs,
    required this.activeTabIndex,
    required this.products,
    required this.loadingProducts,
  });

  factory PosState.initial() => PosState(
        tabs: [TabData()],
        activeTabIndex: 0,
        products: [],
        loadingProducts: true,
      );

  PosState copyWith({
    List<TabData>? tabs,
    int? activeTabIndex,
    List<ProductModel>? products,
    bool? loadingProducts,
  }) {
    return PosState(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      products: products ?? this.products,
      loadingProducts: loadingProducts ?? this.loadingProducts,
    );
  }
}
