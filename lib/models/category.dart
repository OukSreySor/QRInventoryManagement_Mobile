class Category {
  final int id;
  final String name;
  final String description;
  final String userId;
   final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    this.createdAt
  });


}
