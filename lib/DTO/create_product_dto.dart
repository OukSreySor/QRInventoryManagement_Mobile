class CreateProductDTO {
  final String name;
  final String description;
  final double unitPrice;
  final double sellingPrice;
  final int categoryId;

  CreateProductDTO({
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.sellingPrice,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'unit_Price': unitPrice,
      'selling_Price': sellingPrice,
      'CategoryId': categoryId, 
    };
  }
}
