class ProductItemDetailDTO {
  final int id;
  final String serialNumber;
  final DateTime manufacturingDate;
  final DateTime expiryDate;
  final double unitPrice;
  final double sellingPrice;
  final String qrCode;
  final String qrImageUrl;
  final String productName;
  final String userName;
  final DateTime addedDate;
  final String status;

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
    required this.status
  });

  factory ProductItemDetailDTO.fromJson(Map<String, dynamic> json) {
    return ProductItemDetailDTO(
      id: json['id'],
      serialNumber: json['serial_Number'],
      manufacturingDate: DateTime.parse(json['manufacturing_Date']),
      expiryDate: DateTime.parse(json['expiry_Date']),
      unitPrice: (json['unit_Price'] as num).toDouble(),
      sellingPrice: (json['selling_Price'] as num).toDouble(),
      qrCode: json['qR_Code'],
      qrImageUrl: json['qrImageUrl'],
      productName: json['productName'],
      userName: json['userName'],
      addedDate: DateTime.parse(json['addedDate']),
      status: json['status']
    );
  }
}
