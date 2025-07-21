class ActivityLogEntry {
  final int itemId;
  final String itemName;
  final String qrCode;
  final String serialNumber;
  final String transactionType;
  final DateTime transactionDate;
  final String userName;
  final double transactionValue;

  ActivityLogEntry({
    required this.itemId,
    required this.itemName,
    required this.qrCode,
    required this.serialNumber,
    required this.transactionType,
    required this.transactionDate,
    required this.userName,
    required this.transactionValue,
  });

  factory ActivityLogEntry.fromJson(Map<String, dynamic> json) {
    return ActivityLogEntry(
      itemId: json['itemId'],
      itemName: json['itemName'] ?? 'Unknown',
      qrCode: json['qrCode'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      transactionType: json['transactionType'],
      transactionDate: DateTime.parse(json['transactionDate']),
      userName: json['userName'] ?? 'Unknown',
      transactionValue: (json['transactionValue'] as num).toDouble(),
    );
  }
}
