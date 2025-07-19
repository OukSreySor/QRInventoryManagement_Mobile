import '../DTO/category_dto.dart';
import '../models/category.dart';
import 'dio_client.dart';

class CategoryService {
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await DioClient.dio.get('/Category');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];

        return data.map((json) => CategoryDTO.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  Future<void> createCategory(String name, String description) async {
    await DioClient.dio.post('/Category', data: {
      'name': name,
      'description': description,
    });
  }

  Future<void> updateCategory(int id, String name, String description) async {
    await DioClient.dio.put('/Category/$id', data: {
      'name': name,
      'description': description,
    });
  }

  Future<void> deleteCategory(int id) async {
    await DioClient.dio.delete('/Category/$id');
  }
}
