class ProductModel {
  final String barcode;
  final String name;
  final double price;
  final int quantity;
  final String company;
  final int stock;
  final String? imageUrl;

  ProductModel({
    required this.barcode,
    required this.name,
    required this.price,
    required this.quantity,
    required this.company,
    required this.stock,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'name': name,
    'price': price,
    'quantity': quantity,
    'company': company,
    'stock': stock,
    'imageUrl': imageUrl, 
  };

factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    name: json['name'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    barcode: json['barcode'] ?? '',
    company: json['company'] ?? '',
    stock: json['stock'] ?? 0,
    quantity: json['quantity'] ?? 0,
    imageUrl: json['imageUrl'] ?? 'assets/images/medicine.jpg',
  );
}

}
