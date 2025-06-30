import '../../data/models/invoice_model.dart';

abstract class InvoiceRepository {
  Future<void> addInvoice(InvoiceModel invoice);
  Future<List<InvoiceModel>> fetchAllInvoices();
  Future<void> syncInvoices();
}
