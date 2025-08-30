// 📁 pos_cubit.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_pos/core/widgets/toast_helper.dart';
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
        for (var product in products) {
          await local.updateProduct(product['barcode'], product);
        }
      } catch (e) {
        print('❌ Failed to fetch products: \$e');
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

  void addToCart(
    int tabIndex,
    Map<String, dynamic> product,
    BuildContext context,
  ) {
    final tabs = List<TabData>.from(state.tabs);
    final cart = List<Map<String, dynamic>>.from(tabs[tabIndex].cartItems);

    final totalQtyInAllTabs = tabs.fold<int>(
      0,
      (sum, tab) =>
          sum +
          tab.cartItems
              .where((item) => item['barcode'] == product['barcode'])
              .fold(0, (s, i) => s + (i['quantity'] as int)),
    );

    final stock = product['stock'] ?? 0;

    final index = cart.indexWhere(
      (item) => item['barcode'] == product['barcode'],
    );
    if (totalQtyInAllTabs < stock) {
      if (index != -1) {
        cart[index]['quantity'] += 1;
      } else {
        cart.add({...product, 'quantity': 1});
      }
      tabs[tabIndex] = tabs[tabIndex].copyWith(cartItems: cart);
      emit(state.copyWith(tabs: tabs));
    } else {
      motionSnackBarError(
        context,
        "🚩 Cannot add more. Stock exceeded for \${product['barcode']}",
      );
    }
  }

  Future<void> syncUnsyncedInvoices() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) return;

    final unsyncedInvoices = local.getUnsyncedInvoices()
      ..sort(
        (a, b) =>
            DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])),
      );

    for (var invoice in unsyncedInvoices) {
      try {
        await remote.uploadInvoice(invoice);

        for (var product in invoice['products']) {
          await remote.updateProductStock(
            product['barcode'],
            product['quantity'],
          );
        }

        await local.markAsSynced(invoice['id']);
        print('✅ Synced invoice: ${invoice['id']}');
      } catch (e) {
        print('❌ Failed to sync invoice ${invoice['id']}: $e');
      }
    }
  }

  void startSyncListener() {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        print('🌐 Internet reconnected. Trying to sync...');
        await syncUnsyncedInvoices();
      }
    });
  }

  void increaseQuantity(int tabIndex, String barcode, BuildContext context) {
    final tabs = List<TabData>.from(state.tabs);
    final cart = List<Map<String, dynamic>>.from(tabs[tabIndex].cartItems);
    final index = cart.indexWhere((item) => item['barcode'] == barcode);

    if (index != -1) {
      final product = cart[index];
      final stock = product['stock'] ?? 0;

      final totalQtyInAllTabs = tabs.fold<int>(
        0,
        (sum, tab) =>
            sum +
            tab.cartItems
                .where((item) => item['barcode'] == barcode)
                .fold(0, (s, i) => s + (i['quantity'] as int)),
      );

      if (totalQtyInAllTabs < stock) {
        cart[index]['quantity'] += 1;
        tabs[tabIndex] = tabs[tabIndex].copyWith(cartItems: cart);
        emit(state.copyWith(tabs: tabs));
      } else {
        motionSnackBarError(
          context,
          "🚩 Cannot increase. Stock exceeded for \$barcode",
        );
      }
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

  Future<void> checkout(int tabIndex, BuildContext context) async {
    await _checkoutLock.synchronized(() async {
      try {
        final cartItems = state.tabs[tabIndex].cartItems;

        if (cartItems.isEmpty) {
          motionSnackBarError(context, "Tab $tabIndex: Cart is empty.");
          return;
        }
 await invoiceRepository.fetchAllInvoices();
        final invoice = InvoiceModel(
          id: 'INV-${DateTime.now().millisecondsSinceEpoch}-$tabIndex',
          date: DateTime.now(),
          products: cartItems.map((e) => ProductModel.fromJson(e)).toList(),
          total: getTotal(tabIndex),
        );

        final connectivityResult = await Connectivity().checkConnectivity();

        await invoiceRepository.addInvoice(invoice);
        clearCart(tabIndex);
        if (connectivityResult.last != ConnectivityResult.none) {
          await invoiceRepository.syncInvoices();
          motionSnackBarSuccess(context, "Checkout synced successfully ✅");
        } else {
          motionSnackBarSuccess(
            context,
            "Checkout saved offline. Will sync later 📴",
          );
        }

        initializeProducts();
      await invoiceRepository.fetchAllInvoices();
      } catch (e, s) {
        motionSnackBarError(context, "Checkout failed ❌: $e");
        print('Tab $tabIndex: Invoice failed. $e\n$s');
      }
    });
  }
  // Add these inside PosCubit, at the bottom

Future<void> addProduct(ProductModel product) async {
  try {
    await local.updateProduct(product.barcode, product.toJson());
    await remote.addProduct(product.toJson()); // backend create
    await initializeProducts();
  } catch (e) {
    print("❌ Failed to add product: $e");
  }
}

Future<void> updateProduct(ProductModel product) async {
  try {
    await local.updateProduct(product.barcode, product.toJson());
    await remote.updateProduct(product.barcode, product.toJson()); 

    await initializeProducts();
  } catch (e) {
    print("❌ Failed to update product: $e");
  }
}

Future<void> removeProduct(ProductModel product) async {
  try {
    await local.deleteProduct(product.barcode);
    await remote.deleteProduct(product.barcode); 
    await initializeProducts();
  } catch (e) {
    print("❌ Failed to delete product: $e");
  }
}

}
