

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/product_model.dart';
import 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceState.initial(_dummyInvoices()));

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void updateSortBy(String sortBy) {
    emit(state.copyWith(sortBy: sortBy));
    _applyFilters();
  }

  void selectInvoice(InvoiceModel? invoice) {
    emit(state.copyWith(selectedInvoice: invoice));
  }

  void _applyFilters() {
    List<InvoiceModel> temp = List.from(state.allInvoices);

    if (state.searchQuery.isNotEmpty) {
      temp = temp.where((inv) {
        return inv.id.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            inv.products.any((p) => p.name.toLowerCase().contains(state.searchQuery.toLowerCase()));
      }).toList();
    }

    switch (state.sortBy) {
      case 'Date Asc':
        temp.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Date Desc':
        temp.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Total Asc':
        temp.sort((a, b) => a.total.compareTo(b.total));
        break;
      case 'Total Desc':
        temp.sort((a, b) => b.total.compareTo(a.total));
        break;
    }

    emit(state.copyWith(filteredInvoices: temp));
  }

  static List<InvoiceModel> _dummyInvoices() {
    return List.generate(6, (i) {
      return InvoiceModel(
        id: 'INV-20240${i + 1}',
        date: DateTime.now().subtract(Duration(days: i * 2)),
        products: [
          ProductModel(
            name: 'Panadol Extra',
            price: 25.0,
            barcode: 'BC100$i',
            company: 'Pharma Co.',
            quantity: 2,
          ),
          ProductModel(
            name: 'Vitamin C',
            price: 10.0,
            barcode: 'BC200$i',
            company: 'Health Inc.',
            quantity: 1,
          ),
        ],
      );
    });
  }
}
