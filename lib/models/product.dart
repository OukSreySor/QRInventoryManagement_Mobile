import 'category.dart';
import 'product_item.dart';
import 'user.dart';
import 'enums/product_status.dart';

class Product {
  int id;
  String name;
  String description;
  String? image;
  double unitPrice;
  double sellingPrice;
  ProductStatus status;
  int categoryId;
  Category category;
  String userId;
  User user;
  List<ProductItem> productItems;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.unitPrice,
    required this.sellingPrice,
    required this.status,
    required this.categoryId,
    required this.category,
    required this.userId,
    required this.user,
    required this.productItems,
  });

}
