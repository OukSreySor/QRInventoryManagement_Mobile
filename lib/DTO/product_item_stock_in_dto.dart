class ProductItemStockInDto {
  final String serialNumber;
  final int productId;
  final DateTime manufacturingDate;
  final DateTime expiryDate;
  final DateTime addedDate;

  ProductItemStockInDto({
    required this.serialNumber,
    required this.productId,
    required this.manufacturingDate,
    required this.expiryDate,
    required this.addedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'Serial_Number': serialNumber,
      'ProductId': productId,
      'Manufacturing_Date': manufacturingDate.toIso8601String(),
      'Expiry_Date': expiryDate.toIso8601String(),
      'AddedDate': addedDate.toIso8601String(),
    };
  }
}
