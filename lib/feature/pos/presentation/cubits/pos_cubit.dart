// 📁 pos_cubit.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_pos/feature/pos/data/models/invoice_model.dart';
import 'package:synchronized/synchronized.dart';
import '../../data/models/product_model.dart';
import '../../data/models/tab_data.dart';
import '../../data/sources/local_data_source.dart';
import '../../data/sources/remote_data_source.dart';
import '../../domain/repositories/invoice_repository.dart';
import 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final InvoiceRepository invoiceRepository;
  final RemoteDataSource remote;
  final LocalDataSource local;
  final Lock _checkoutLock = Lock();

  PosCubit(this.invoiceRepository, this.remote, this.local)
    : super(PosState.initial());

  Future<void> initializeProducts() async {
    emit(state.copyWith(loadingProducts: true));
    final conn = await Connectivity().checkConnectivity();
    if (conn != ConnectivityResult.none) {
      try {
        final products = await remote.fetchProducts();
        print("fetch  remote");
        for (var product in products) {
          await local.updateProduct(product['barcode'], product);
        }
        print("update local");
      } catch (e) {
        print('❌ Failed to fetch products: $e');
      }
    }
    final localProducts = local.getProducts();
    final parsed = localProducts.map((p) => ProductModel.fromJson(p)).toList();
    emit(state.copyWith(products: parsed, loadingProducts: false));
  }

  void addNewTab() {
    final newTabs = List<TabData>.from(state.tabs)..add(TabData());
    emit(state.copyWith(tabs: newTabs, activeTabIndex: newTabs.length - 1));
  }

  void removeTab(int index) {
    if (state.tabs.length == 1) return;
    final newTabs = List<TabData>.from(state.tabs)..removeAt(index);
    final newActive = state.activeTabIndex >= newTabs.length
        ? newTabs.length - 1
        : state.activeTabIndex;
    emit(state.copyWith(tabs: newTabs, activeTabIndex: newActive));
  }

  void switchTab(int index) {
    emit(state.copyWith(activeTabIndex: index));
  }

  void updateSearchQuery(int tabIndex, String query) {
    final updatedTabs = List<TabData>.from(state.tabs);
    updatedTabs[tabIndex] = updatedTabs[tabIndex].copyWith(searchQuery: query);
    emit(state.copyWith(tabs: updatedTabs));
  }

  void addToCart(int tabIndex, Map<String, dynamic> product) {
    final tabs = List<TabData>.from(state.tabs);
    final cart = List<Map<String, dynamic>>.from(tabs[tabIndex].cartItems);
    final index = cart.indexWhere(
      (item) => item['barcode'] == product['barcode'],
    );
    if (index != -1 && cart[index]['quantity']<cart[index]['stock']) {
      cart[index]['quantity'] += 1;
    } else {
      cart.add({...product, 'quantity': 1});
    }
    tabs[tabIndex] = tabs[tabIndex].copyWith(cartItems: cart);
    emit(state.copyWith(tabs: tabs));
  }

  void increaseQuantity(int tabIndex, String barcode) {
    final tabs = List<TabData>.from(state.tabs);
    final cart = List<Map<String, dynamic>>.from(tabs[tabIndex].cartItems);
    final index = cart.indexWhere((item) => item['barcode'] == barcode);
    if (index != -1&& cart[index]['quantity']<cart[index]['stock']) {
      cart[index]['quantity'] += 1;
      tabs[tabIndex] = tabs[tabIndex].copyWith(cartItems: cart);
      emit(state.copyWith(tabs: tabs));
    }
  }

  void decreaseQuantity(int tabIndex, String barcode) {
    final tabs = List<TabData>.from(state.tabs);
    final cart = List<Map<String, dynamic>>.from(tabs[tabIndex].cartItems);
    final index = cart.indexWhere((item) => item['barcode'] == barcode);
    if (index != -1) {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity'] -= 1;
      } else {
        cart.removeAt(index);
      }
      tabs[tabIndex] = tabs[tabIndex].copyWith(cartItems: cart);
      emit(state.copyWith(tabs: tabs));
    }
  }

  void removeFromCart(int tabIndex, String barcode) {
    final tabs = List<TabData>.from(state.tabs);
    final cart = List<Map<String, dynamic>>.from(tabs[tabIndex].cartItems)
      ..removeWhere((item) => item['barcode'] == barcode);
    tabs[tabIndex] = tabs[tabIndex].copyWith(cartItems: cart);
    emit(state.copyWith(tabs: tabs));
  }

  double getTotal(int tabIndex) {
    return state.tabs[tabIndex].cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void clearCart(int tabIndex) {
    final updatedTabs = [...state.tabs];
    updatedTabs[tabIndex] = updatedTabs[tabIndex].copyWith(cartItems: []);
    emit(state.copyWith(tabs: updatedTabs));
  }

  Future<void> checkout(int tabIndex) async {
    await _checkoutLock.synchronized(() async {
      try {
        final cartItems = state.tabs[tabIndex].cartItems;
        if (cartItems.isEmpty) {
          print('Tab $tabIndex: Cart is empty.');
          return;
        }

        final invoice = InvoiceModel(
          id: 'INV-${DateTime.now().millisecondsSinceEpoch}-$tabIndex',
          date: DateTime.now(),
          products: cartItems.map((e) => ProductModel.fromJson(e)).toList(),
          total: getTotal(tabIndex),
        );

        await invoiceRepository.addInvoice(invoice);
        clearCart(tabIndex);
        initializeProducts();
        print('Tab $tabIndex: Invoice saved.');
      } catch (e, s) {
        print('Tab $tabIndex: Invoice failed. $e\n$s');
      }
    });
  }
}
