import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/tab_data.dart';
import 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  PosCubit() : super(PosState.initial());

  void addNewTab() {
    final newTabs = List<TabData>.from(state.tabs)..add(TabData());
    emit(state.copyWith(tabs: newTabs, activeTabIndex: newTabs.length - 1));
  }

  void removeTab(int index) {
    if (state.tabs.length == 1) return; 
    final newTabs = List<TabData>.from(state.tabs)..removeAt(index);
    int newActive = state.activeTabIndex >= newTabs.length ? newTabs.length - 1 : state.activeTabIndex;
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
    final index = cart.indexWhere((item) => item['barcode'] == product['barcode']);
    if (index != -1) {
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
    if (index != -1) {
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

void checkout(int tabIndex) {
  final cartItems = state.tabs[tabIndex].cartItems;
  if (cartItems.isEmpty) {
    print('Cart is empty, nothing to checkout.');
    return;
  }
  print('Checked out ${state.tabs[tabIndex].cartItems.length} items');
}

}
