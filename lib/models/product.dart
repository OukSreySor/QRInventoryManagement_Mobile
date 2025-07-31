import 'package:qr_inventory_management/models/category_dropdown.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double unitPrice;
  final double sellingPrice;
  final int categoryId;
  final CategoryDropdown category;
  final String? userName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.sellingPrice,
    required this.categoryId,
    required this.category,
    this.userName
  });

}
