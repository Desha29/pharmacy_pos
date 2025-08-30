import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pharmacy_pos/feature/pos/data/models/invoice_model.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../sources/local_data_source.dart';
import '../sources/remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final LocalDataSource local;
  final RemoteDataSource remote;

  InvoiceRepositoryImpl(this.local, this.remote);

  @override
  Future<void> addInvoice(InvoiceModel invoice) async {
    final json = invoice.toJson();
    final connectivityResult = await Connectivity().checkConnectivity();

    json['isSynced'] = false;
    await local.saveInvoice(json);

    // reduce stock locally
    for (var product in invoice.products) {
      final localProd = await local.getProductByBarcode(product.barcode);
      if (localProd != null) {
        final updatedStock = (localProd['stock'] ?? 0) - product.quantity;
        await local.updateProduct(product.barcode, {
          ...localProd,
          'stock': updatedStock < 0 ? 0 : updatedStock,
        });
      }
    }

    // try to sync immediately if online
    if (connectivityResult != ConnectivityResult.none) {
      try {
        await remote.uploadInvoice(json);
        for (var product in invoice.products) {
          await remote.updateProductStock(product.barcode, product.quantity);
        }
        await local.markAsSynced(json['id']);
        print('✅ Invoice synced to Firestore');
      } catch (e) {
        print('❌ Firestore sync failed, will retry later: $e');
      }
    } else {
      print('📴 Offline: invoice will sync when back online');
    }
  }

  @override
  Future<List<InvoiceModel>> fetchAllInvoices() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final cloudInvoices = await remote.fetchInvoices();
        for (var invoice in cloudInvoices) {
          await local.saveInvoice({...invoice, 'isSynced': true});
        }
      } catch (e) {
        print('⚠️ Failed to fetch cloud invoices: $e');
      }
    }

    final raw = local.getInvoices();
    return raw.map((json) => InvoiceModel.fromJson(json)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> syncInvoices() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection. Sync postponed.');
      return;
    }

    final unsynced = local.getUnsyncedInvoices();
    unsynced.sort((a, b) => (a['date'] ?? '').compareTo(b['date'] ?? ''));

    for (final invoice in unsynced) {
      try {
        bool canSync = true;
        final List<String> conflictedBarcodes = [];

        for (final product in invoice['products']) {
          final barcode = product['barcode'];
          final qtySold = product['quantity'];

          final doc = await remote.firestore
              .collection('products')
              .doc(barcode)
              .get();
          if (!doc.exists) {
            conflictedBarcodes.add(barcode);
            canSync = false;
            continue;
          }

          final cloudStock = doc['stock'] ?? 0;
          if (cloudStock < qtySold) {
            conflictedBarcodes.add(barcode);
            canSync = false;
          }
        }

        if (!canSync) {
          for (final product in invoice['products']) {
            if (!conflictedBarcodes.contains(product['barcode'])) continue;
            final doc = await remote.firestore
                .collection('products')
                .doc(product['barcode'])
                .get();
            if (!doc.exists) continue;
            final cloudStock = doc['stock'] ?? 0;
            product['quantity'] = cloudStock > 0 ? cloudStock : 0;
          }
          invoice['products'] =
              invoice['products'].where((p) => p['quantity'] > 0).toList();
          invoice['total'] = invoice['products']
              .map((p) => p['price'] * p['quantity'])
              .fold(0.0, (a, b) => a + b);
        }

        if (invoice['products'].isEmpty) {
          print('Invoice skipped: all products out of stock');
          continue;
        }

        await remote.uploadInvoice(invoice);
        await local.markAsSynced(invoice['id']);

        for (final product in invoice['products']) {
          await remote.updateProductStock(
            product['barcode'],
            product['quantity'],
          );
        }

        print('✅ Invoice ${invoice['id']} synced with concurrency safety.');
      } catch (e) {
        print('❌ Sync failure for invoice ${invoice['id']}: $e');
      }
    }
  }

  // 🔹 Admin: delete invoice
  @override
  Future<void> deleteInvoice(String id) async {
    await local.deleteInvoice(id);

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        await remote.deleteInvoice(id);
        print('🗑️ Invoice $id deleted from Firestore');
      } catch (e) {
        print('⚠️ Failed to delete from Firestore, will retry later: $e');
        await local.markAsUnsynced(id); 
      }
    }
  }

  // 🔹 Admin: update invoice
  @override
  Future<void> updateInvoice(InvoiceModel invoice) async {
    final json = invoice.toJson();
    await local.updateInvoice(invoice.id, json);

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        await remote.updateInvoice(invoice.id, json);
        await local.markAsSynced(invoice.id);
        print('✏️ Invoice ${invoice.id} updated in Firestore');
      } catch (e) {
        print('⚠️ Failed to update Firestore, will retry later: $e');
      }
    }
  }
}
