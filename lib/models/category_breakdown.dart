class CategoryBreakdown {
  final String categoryName;
  final int productCount;
  final int totalUnits;

  CategoryBreakdown({
    required this.categoryName,
    required this.productCount,
    required this.totalUnits,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      categoryName: json['categoryName'],
      productCount: json['productCount'],
      totalUnits: json['totalUnits'],
    );
  }
}