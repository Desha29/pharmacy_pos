import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/invoice_model.dart';

class InvoiceState extends Equatable {
  final List<InvoiceModel> allInvoices;
  final List<InvoiceModel> filteredInvoices;
  final String sortBy;
  final String searchQuery;
  final InvoiceModel? selectedInvoice;
  final TextEditingController searchController;

  const InvoiceState({
    required this.allInvoices,
    required this.filteredInvoices,
    required this.sortBy,
    required this.searchQuery,
    required this.selectedInvoice,
    required this.searchController,
  });

  factory InvoiceState.initial(List<InvoiceModel> invoices) {
    return InvoiceState(
      allInvoices: invoices,
      filteredInvoices: invoices,
      sortBy: 'Date Desc',
      searchQuery: '',
      selectedInvoice: null,
      searchController: TextEditingController(),
    );
  }

  InvoiceState copyWith({
    List<InvoiceModel>? allInvoices,
    List<InvoiceModel>? filteredInvoices,
    String? sortBy,
    String? searchQuery,
    InvoiceModel? selectedInvoice,
    TextEditingController? searchController, 
  }) {
    return InvoiceState(
      allInvoices: allInvoices ?? this.allInvoices,
      filteredInvoices: filteredInvoices ?? this.filteredInvoices,
      sortBy: sortBy ?? this.sortBy,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedInvoice: selectedInvoice ?? this.selectedInvoice,
      searchController: searchController ?? this.searchController, 
    );
  }

  @override
  List<Object?> get props => [
        allInvoices,
        filteredInvoices,
        sortBy,
        searchQuery,
        selectedInvoice,
      ];
}
