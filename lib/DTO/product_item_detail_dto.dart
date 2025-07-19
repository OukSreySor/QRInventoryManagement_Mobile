class ProductItemDetailDTO {
  final int id;
  final String serialNumber;
  final String manufacturingDate;
  final String expiryDate;
  final double unitPrice;
  final double sellingPrice;
  final String qrCode;
  final String qrImageUrl;
  final String productName;
  final String userName;
  final String addedDate;

  ProductItemDetailDTO({
    required this.id,
    required this.serialNumber,
    required this.manufacturingDate,
    required this.expiryDate,
    required this.unitPrice,
    required this.sellingPrice,
    required this.qrCode,
    required this.qrImageUrl,
    required this.productName,
    required this.userName,
    required this.addedDate,
  });

  factory ProductItemDetailDTO.fromJson(Map<String, dynamic> json) {
    return ProductItemDetailDTO(
      id: json['id'],
      serialNumber: json['serial_Number'],
      manufacturingDate: json['manufacturing_Date'],
      expiryDate: json['expiry_Date'],
      unitPrice: (json['unit_Price'] as num).toDouble(),
      sellingPrice: (json['selling_Price'] as num).toDouble(),
      qrCode: json['qR_Code'],
      qrImageUrl: json['qrImageUrl'],
      productName: json['productName'],
      userName: json['userName'],
      addedDate: json['addedDate'],
    );
  }
}
