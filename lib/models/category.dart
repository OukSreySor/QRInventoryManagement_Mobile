import 'user.dart';
import 'product.dart';

class Category {
  int id;
  String name;
  String description;
  List<Product>? products;
  String userId; 
  User? user;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.products,
    required this.userId,
    this.user,
  });

  // factory Category.fromJson(Map<String, dynamic> json) {
  //   return Category(
  //     id: json['id'],
  //     name: json['name'],
  //     description: json['description'],
  //     products: json['products'] != null
  //         ? List<Product>.from(json['products'].map((x) => Product.fromJson(x)))
  //         : null,
  //     userId: json['userId'],
  //     user: json['user'] != null ? User.fromJson(json['user']) : null,
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'products': products?.map((x) => x.toJson()).toList(),
  //     'userId': userId,
  //     'user': user?.toJson(),
  //   };
  // }
}
