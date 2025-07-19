class ProductStockSummaryDTO {
  final int id;
  final String name;
  final String categoryName;
  final int quantityInStock;

  ProductStockSummaryDTO({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.quantityInStock,
  });

  factory ProductStockSummaryDTO.fromJson(Map<String, dynamic> json) {
    return ProductStockSummaryDTO(
      id: json['id'],
      name: json['name'],
      categoryName: json['categoryName'],
      quantityInStock: json['quantityInStock'],
    );
  }
}