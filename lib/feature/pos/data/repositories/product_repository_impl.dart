import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../sources/local_data_source.dart';
import '../sources/remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalDataSource local;
  final RemoteDataSource remote;

  ProductRepositoryImpl(this.local, this.remote);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn != ConnectivityResult.none) {
      try {
        final remoteProducts = await remote.fetchProducts();
        for (var product in remoteProducts) {
          await local.updateProduct(product['barcode'], product);
        }
      } catch (e) {
        print('❌ Failed to fetch remote products: $e');
      }
    }

    final raw = local.getProducts();
    return raw.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateStock(String barcode, int change) async {
    final product = await local.getProductByBarcode(barcode);
    if (product == null) return;

    final currentStock = product['stock'] ?? 0;
    final newStock = currentStock - change;

    final updated = {
      ...product,
      'stock': newStock < 0 ? 0 : newStock,
    };

    await local.updateProduct(barcode, updated);

    try {
      await remote.updateProductStock(barcode, change);
    } catch (e) {
      print('⚠️ Remote stock update failed for $barcode: $e');
    }
  }

  @override
  Future<void> syncProducts() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) {
      print('🔌 Offline, cannot sync products');
      return;
    }

    try {
      final cloud = await remote.fetchProducts();
      for (final product in cloud) {
        await local.updateProduct(product['barcode'], product);
      }
      print('✅ Product sync completed');
    } catch (e) {
      print('❌ Product sync failed: $e');
    }
  }
}
