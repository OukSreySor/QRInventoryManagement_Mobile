import 'package:qr_inventory_management/DTO/product_dto.dart';
import 'package:qr_inventory_management/DTO/user_dto.dart';

import '../models/category.dart';

class CategoryDTO {
  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      products: json['products'] != null
          ? (json['products'] as List)
              .map((e) => ProductDTO.fromJson(e))
              .toList()
          : null,
      userId: json['userId'],
      user: json['user'] != null ? UserDTO.fromJson(json['user']) : null,
    );
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'description': category.description,
      'products': category.products?.map((e) => ProductDTO.toJson(e)).toList(),
      'userId': category.userId,
      'user': category.user != null ? UserDTO.toJson(category.user!) : null,
    };
  }
}
