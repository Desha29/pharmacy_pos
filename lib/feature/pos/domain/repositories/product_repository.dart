import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<void> updateStock(String barcode, int change);
  Future<void> syncProducts();

  // 🛠 Admin Features
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String barcode);
}
