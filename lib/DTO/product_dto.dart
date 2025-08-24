
import 'package:qr_inventory_management/models/category_dropdown.dart';
import 'package:qr_inventory_management/models/enums/product_status.dart';

import '../models/product.dart';

class ProductDTO {
  static Product fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'];

    if (categoryJson == null) {
      throw Exception('Missing category data in product JSON');
    }
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      unitPrice: (json['unit_Price']),
      sellingPrice: (json['selling_Price']),
      categoryId: json['categoryId'],
      category: CategoryDropdown.fromJson(json['category']),
      userName: json['userName'],
      status: getProductStatus(json['status'])
    );
  }

}
