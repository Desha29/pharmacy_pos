import 'product_model.dart';

class InvoiceModel {
  final String id;
  final DateTime date;
  final List<ProductModel> products;
  final double total;
  final bool isSynced;

  InvoiceModel({
    required this.id,
    required this.date,
    required this.products,
    required this.total,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'products': products.map((p) => p.toJson()).toList(),
    'total': total,
    'isSynced': isSynced,
  };

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
  return InvoiceModel(
    id: json['id'],
    date: DateTime.parse(json['date']),
    total: (json['total'] as num).toDouble(),
    products: (json['products'] as List)
        .map((p) => ProductModel.fromJson(Map<String, dynamic>.from(p)))
        .toList(),
  );
}

}
