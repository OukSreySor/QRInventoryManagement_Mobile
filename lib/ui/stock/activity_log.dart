import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'package:intl/intl.dart';

class ActivityLog extends StatelessWidget {
  final int itemId;
  final String? itemName;
  final String? qrCode;
  final String serialNumber;
  final String transactionType;
  final DateTime transactionDate;
  final String userName;

  const ActivityLog({
    super.key,
    required this.itemId,
    this.itemName,
    this.qrCode,
    required this.serialNumber,
    required this.transactionType,
    required this.transactionDate,
    required this.userName,
  });

  Color _getStockColor(String transactionType) {
    if (transactionType == 'Stock Out') {
      return AppColors.pinkRedIcon;
    } else if (transactionType == 'Stock In') {
      return AppColors.greenIcon;
    }
    return AppColors.orangeIcon;
  }

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('M/d/yyyy, h:mm:ss a').format(transactionDate);

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  LucideIcons.activity,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  'Activity Log (2 entries)',
                  style: AppTextStyles.cardHeader
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Row(
                      children: [
                        Icon(
                          transactionType == 'Stock Out'
                              ? LucideIcons.trendingDown
                              : LucideIcons.trendingUp, 
                          color: _getStockColor(transactionType), 
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          itemName ?? 'Unknown Item', 
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, 
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          transactionType == 'Stock Out' ? '-1' : '+1',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _getStockColor(transactionType)), 
                        ),
                        Text(
                          'units',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0), 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: _getStockColor(transactionType),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    transactionType,
                    style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600), 
                  ),
                ),
                const SizedBox(height: 16.0), 

                Row(
                  children: [
                    Icon(LucideIcons.box, size: 18, color: Colors.grey), 
                    SizedBox(width: 8.0),
                    Text(serialNumber, style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(LucideIcons.user2, size: 18, color: Colors.grey),
                    SizedBox(width: 8.0),
                    Text('By: $userName', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(LucideIcons.calendar, size: 18, color: Colors.grey),
                    SizedBox(width: 8.0),
                    Text(formattedDate, style: TextStyle(color: Colors.grey[700])), 
                  ],
                ),
                Divider(height: 24.0, thickness: 1.0, color: Colors.grey[300]),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transaction Value:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)), 
                    Text(
                      '\$160.00', 
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkBlue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
