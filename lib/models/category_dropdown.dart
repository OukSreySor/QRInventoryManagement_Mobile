class CategoryDropdown {
  final int id;
  final String name;

  CategoryDropdown({required this.id, required this.name});

  factory CategoryDropdown.fromJson(Map<String, dynamic> json) {
    return CategoryDropdown(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() => name;
}
