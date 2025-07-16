import 'user.dart';
import 'product.dart';

class Category {
  int id;
  String name;
  String description;
  List<Product>? products;
  String userId; 
  User? user;
  DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.products,
    required this.userId,
    this.user,
    required this.createdAt
  });

  String get formattedCreatedAt {
    return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
  }

}
