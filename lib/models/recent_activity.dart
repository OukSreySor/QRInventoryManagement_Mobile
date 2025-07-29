import 'package:timeago/timeago.dart' as timeago;
import '../utils/date_formatter.dart'; 

class RecentActivity {
  final String productName;
  final String serialNumber;
  final String transactionType;
  final DateTime transactionDate;
  final String userName;

  RecentActivity({
    required this.productName,
    required this.serialNumber,
    required this.transactionType,
    required this.transactionDate,
    required this.userName,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      productName: json['productName'] as String,
      serialNumber: json['serialNumber'] as String,
      transactionType: json['transactionType'] as String,
      transactionDate: DateTime.parse(json['transactionDate']),
      userName: json['userName'] as String,
    );
  }

  // --- FOR RELATIVE TIME ---
  String get relativeTransactionTime {
    final now = DateTime.now(); 
    final difference = now.difference(transactionDate); 

    if (difference.inDays == 0) {
      return DateFormatter.formatTimeShort(transactionDate);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormatter.formatTimeShort(transactionDate)}';
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return '${difference.inDays} days ago ${DateFormatter.formatTimeShort(transactionDate)}';
    } else {
      return timeago.format(transactionDate, locale: 'en_short');
    }
  }

  String get formattedTransactionDate {
    return DateFormatter.formatDateTimeLong(transactionDate); 
  }
}