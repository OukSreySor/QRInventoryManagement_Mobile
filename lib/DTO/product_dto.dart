import 'package:qr_inventory_management/DTO/category_dto.dart';
import 'package:qr_inventory_management/DTO/product_item_dto.dart';
import 'package:qr_inventory_management/DTO/user_dto.dart';
import '../models/product.dart';
import '../models/enums/product_status.dart';

class ProductDTO {
  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      unitPrice: (json['unit_Price']),
      sellingPrice: (json['selling_Price']),
      status: ProductStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      categoryId: json['categoryId'],
      category: CategoryDTO.fromJson(json['category']),
      userId: json['userId'],
      user: UserDTO.fromJson(json['user']),
      productItems: (json['productItems'] as List<dynamic>?)
              ?.map((item) => ProductItemDTO.fromJson(item))
              .toList() ?? [],
    );
  }

  static Map<String, dynamic> toJson(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'unitPrice': product.unitPrice,
      'sellingPrice': product.sellingPrice,
      'status': product.status.toString().split('.').last,
      'categoryId': product.categoryId,
      'category': CategoryDTO.toJson(product.category),
      'userId': product.userId,
      'user': UserDTO.toJson(product.user),
      'productItems': product.productItems.map((item) => ProductItemDTO.toJson(item)).toList(),
    };
  }
}
