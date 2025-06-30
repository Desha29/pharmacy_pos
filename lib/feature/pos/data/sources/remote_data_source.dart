import 'package:cloud_firestore/cloud_firestore.dart';


class RemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final query = await firestore.collection('products').get();

    return query.docs.map((doc) {
      final data = doc.data();
      data['barcode'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> updateProductStock(String barcode, int change) async {
    final ref = firestore.collection('products').doc(barcode);
    var item = await ref.get();
    int stock = item.data()!['stock'] ?? 0;
    if (change <= stock) {
     await ref.update({"stock":stock-change});
    }
  }
}
