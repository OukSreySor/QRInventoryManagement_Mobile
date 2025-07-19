import '../models/category.dart';

class CategoryDTO {
  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      userId: json['userId'],
      createdAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
    );
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'description': category.description,
    };
  }
}
