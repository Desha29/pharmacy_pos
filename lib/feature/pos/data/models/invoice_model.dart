import 'product_model.dart';

class InvoiceModel {
  final String id;
  final DateTime date;
  final List<ProductModel> products;
  final double total;

  InvoiceModel({
    required this.id,
    required this.date,
    required this.products,
  }) : total = products.fold(0, (sum, p) => sum + p.price * p.quantity);

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      products: (map['products'] as List)
          .map((item) => ProductModel.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'products': products.map((p) => p.toMap()).toList(),
      };
}
