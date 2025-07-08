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

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json['id'],
//         name: json['name'],
//         description: json['description'],
//         image: json['image'],
//         unitPrice: (json['unit_Price'] as num).toDouble(),
//         sellingPrice: (json['selling_Price'] as num).toDouble(),
//         status: productStatusFromString(json['status']),
//         categoryId: json['categoryId'],
//         category: Category.fromJson(json['category']),
//         userId: json['userId'],
//         user: User.fromJson(json['user']),
//         productItems: List<ProductItem>.from(
//             json['productItems'].map((x) => ProductItem.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'description': description,
//         'image': image,
//         'unit_Price': unitPrice,
//         'selling_Price': sellingPrice,
//         'status': status.name,
//         'categoryId': categoryId,
//         'category': category.toJson(),
//         'userId': userId,
//         'user': user.toJson(),
//         'productItems': productItems.map((x) => x.toJson()).toList(),
//       };
}
