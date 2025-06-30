import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<void> updateStock(String barcode, int change);
  Future<void> syncProducts();
}
