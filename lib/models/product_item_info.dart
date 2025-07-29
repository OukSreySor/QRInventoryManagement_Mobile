class ProductInfo {
  final int productItemId;
  final String serialNumber;
  final String status;
  final DateTime? manufacturingDate;
  final DateTime? expiryDate;
  final String qrCode;

  final int productId;
  final String name;
  final String description;
  final double unitPrice;
  final double sellingPrice;

  ProductInfo({
    required this.productItemId,
    required this.serialNumber,
    required this.status,
    this.manufacturingDate,
    this.expiryDate,
    required this.qrCode,
    required this.productId,
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.sellingPrice,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return ProductInfo(
      productItemId: json['productItemId'],
      serialNumber: json['serial_Number'] ?? '',
      status: json['status'] ?? '',
      manufacturingDate: json['manufacturing_Date'] != null
          ? DateTime.tryParse(json['manufacturing_Date'])
          : null,
      expiryDate: json['expiry_Date'] != null
          ? DateTime.tryParse(json['expiry_Date'])
          : null,
      qrCode: json['qR_Code'] ?? '',
      productId: product['id'] ?? 0,
      name: product['name'] ?? 'Unknown',
      description: product['description'] ?? '',
      unitPrice: (product['unit_Price'] ?? 0).toDouble(),
      sellingPrice: (product['selling_Price'] ?? 0).toDouble(),
    );
  }
}
