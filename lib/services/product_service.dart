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
}