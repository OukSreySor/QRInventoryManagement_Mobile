import 'package:qr_inventory_management/DTO/create_product_dto.dart';
import 'package:qr_inventory_management/models/product.dart';

import '../DTO/product_dto.dart';
import '../DTO/product_item_detail_dto.dart';
import '../DTO/product_stock_summary_dto.dart';
import 'dio_client.dart';

class ProductService {
  Future<List<ProductStockSummaryDTO>> fetchProductStockSummary() async {
    try {
      final response = await DioClient.dio.get('/Product/stock-summary');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((item) => ProductStockSummaryDTO.fromJson(item)).toList();

      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<ProductItemDetailDTO>> getItemsByProduct(int productId) async {
    try {
      final response = await DioClient.dio.get('/ProductItem/by-product/$productId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
          return data.map((item) => ProductItemDetailDTO.fromJson(item)).toList();

      } else {
        throw Exception('Failed to load product items');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await DioClient.dio.get('/Product');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((item) => ProductDTO.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<void> createProduct(CreateProductDTO dto) async {
    try {
      final response = await DioClient.dio.post('/Product', data: dto.toJson());
      print('Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        print('Product created successfully');

      } else {
        print('Backend returned error: ${response.data}');
        throw Exception('Failed to create product');
      }
    } catch (e) {
      print('Error creating product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(int productId, CreateProductDTO dto) async {
    final response = await DioClient.dio.put('/Product/$productId', data: dto.toJson());
    if (response.statusCode != 200 || response.data['success'] != true) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await DioClient.dio.delete('/Product/$productId');
    if (response.statusCode != 200 || response.data['success'] != true) {
      throw Exception('Failed to delete product');
    }
  }

}