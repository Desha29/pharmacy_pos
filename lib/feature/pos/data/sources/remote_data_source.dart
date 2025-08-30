import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ----------------- INVOICES -----------------

  Future<void> uploadInvoice(Map<String, dynamic> invoice) async {
    await firestore.collection('invoices').doc(invoice['id']).set(invoice);
  }

  Future<List<Map<String, dynamic>>> fetchInvoices() async {
    final query = await firestore.collection('invoices').get();

    return query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> updateInvoice(String id, Map<String, dynamic> updatedData) async {
    await firestore.collection('invoices').doc(id).update(updatedData);
  }

  Future<void> deleteInvoice(String id) async {
    await firestore.collection('invoices').doc(id).delete();
  }

  // ----------------- PRODUCTS -----------------

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final query = await firestore.collection('products').get();

    return query.docs.map((doc) {
      final data = doc.data();
      data['barcode'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    await firestore.collection('products').doc(product['barcode']).set(product);
  }

  Future<void> updateProduct(String barcode, Map<String, dynamic> updatedData) async {
    await firestore.collection('products').doc(barcode).update(updatedData);
  }

  Future<void> deleteProduct(String barcode) async {
    await firestore.collection('products').doc(barcode).delete();
  }

  Future<void> updateProductStock(String barcode, int change) async {
    final ref = firestore.collection('products').doc(barcode);
    var item = await ref.get();
    int stock = item.data()?['stock'] ?? 0;

    if (change <= stock) {
      await ref.update({"stock": stock - change});
    }
  }
}
