class QrStockOutDto {
  final String qrCode;
  final DateTime soldDate;

  QrStockOutDto({required this.qrCode, required this.soldDate});

  Map<String, dynamic> toJson() {
    return {
      'QrCode': qrCode,
      'SoldDate': soldDate.toIso8601String(),
    };
  }
}
