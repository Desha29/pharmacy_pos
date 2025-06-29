

class ProductModel {
  final String name;
  final double price;
  final String barcode;
  final String company;
  final String? imageUrl; 
  int quantity;
  int stock ; // Default stock value

  ProductModel({
    required this.name,
    required this.price,
    required this.barcode,
    required this.company,
    this.quantity = 1,
    this.stock = 0, 
    this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'],
      price: map['price'],
      barcode: map['barcode'],
      company: map['company'],
      quantity: map['quantity'] ?? 1,
      stock: map['stock'] ?? 0, 
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'barcode': barcode,
      'company': company,
      'quantity': quantity,
      'stock': stock, 
      'imageUrl': imageUrl,
    };
  }
}
