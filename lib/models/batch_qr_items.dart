class BatchQrItems {
  final int id;
  final String productName;
  final String serialNumber;
  final String qrImageUrl;

  BatchQrItems({
    required this.id,
    required this.productName,
    required this.serialNumber,
    required this.qrImageUrl,
  });

  factory BatchQrItems.fromJson(Map<String, dynamic> json) {
    return BatchQrItems(
      id: json['id'],
      productName: json['productName'],
      serialNumber: json['serial_Number'],
      qrImageUrl: json['qrImageUrl'],
    );
  }
}
