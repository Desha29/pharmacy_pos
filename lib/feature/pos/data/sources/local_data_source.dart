import 'package:hive/hive.dart';

class LocalDataSource {
  final Box invoiceBox = Hive.box('invoices');
  final Box productBox = Hive.box('products');

  Future<void> saveInvoice(Map<String, dynamic> invoice) async {
  
    await invoiceBox.put(invoice['id'], invoice);
  }

  List<Map<String, dynamic>> getInvoices() {
   
    return invoiceBox.values
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    final invoice = invoiceBox.get(id);
    if (invoice != null) {
      final updated = Map<String, dynamic>.from(invoice);
      updated['isSynced'] = true;
      await invoiceBox.put(id, updated);
    }
  }

  List<Map<String, dynamic>> getUnsyncedInvoices() {
   
    return getInvoices().where((i) => i['isSynced'] == false).toList();
  }

  List<Map<String, dynamic>> getProducts() {
  
    return productBox.values
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> updateProduct(String barcode, Map<String, dynamic> data) async {
    
    await productBox.put(barcode, data);
  }

  Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    final item = productBox.get(barcode);
    if (item is Map) {
      return Map<String, dynamic>.from(item);
    }
    return null;
  }
}
