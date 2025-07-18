class ProductDropdown {
  final int id;
  final String name;

  ProductDropdown({required this.id, required this.name});

  factory ProductDropdown.fromJson(Map<String, dynamic> json) {
    return ProductDropdown(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() => name;
}
