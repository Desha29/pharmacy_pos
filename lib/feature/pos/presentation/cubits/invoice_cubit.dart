import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/invoice_model.dart';
import '../../domain/repositories/invoice_repository.dart';
import 'invoice_state.dart';
import '../../data/sources/local_data_source.dart';
import '../../data/sources/remote_data_source.dart';


class InvoiceCubit extends Cubit<InvoiceState> {
  final InvoiceRepository repository;
  final RemoteDataSource remote;
  final LocalDataSource local;

  InvoiceCubit(this.repository, this.remote, this.local)
      : super(InvoiceState.initial([]));

  Future<void> initializeInvoices() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn != ConnectivityResult.none) {
      try {
        final invoices = await remote.fetchInvoices();
        for (var invoice in invoices) {
          await local.saveInvoice({...invoice, 'isSynced': true});
        }

        final unsynced = local.getUnsyncedInvoices();
        for (var invoice in unsynced) {
          try {
            await remote.uploadInvoice(invoice);
            await local.markAsSynced(invoice['id']);
          } catch (e) {
            print('❌ Sync failed for invoice ${invoice['id']}: $e');
          }
        }
      } catch (e) {
        print('❌ Failed to initialize invoices: $e');
      }
    }

    loadInvoices();
  }

  Future<void> loadInvoices() async {
    final invoices = await repository.fetchAllInvoices();
    emit(state.copyWith(allInvoices: invoices, filteredInvoices: invoices));
  }

  Future<void> syncInvoices() async {
    await repository.syncInvoices();
    loadInvoices(); 
  }
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
            inv.products.any((p) =>
                p.name.toLowerCase().contains(state.searchQuery.toLowerCase()));
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
}
