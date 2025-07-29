import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/activity_log_entry.dart';
import '../../services/dio_client.dart';
import '../../theme/theme.dart';


import '../../utils/date_formatter.dart';

class ActivityLog extends StatefulWidget {

  const ActivityLog({
    super.key,
  });

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  late Future<List<ActivityLogEntry>> _activityLogFuture;

  @override
  void initState() {
    super.initState();
    _activityLogFuture = _fetchActivityLog();
  }

  Future<List<ActivityLogEntry>> _fetchActivityLog() async {
    final response = await DioClient.dio.get('/Transaction/activity-log');
    if (response.statusCode == 200 && response.data['success']) {
      return (response.data['data'] as List)
        .map((json) => ActivityLogEntry.fromJson(json))
        .toList();
      
      
    } else {
      throw Exception('Failed to load report');
    }
 
  }

  Color _getStockColor(String transactionType) {
    if (transactionType == 'StockOut') {
      return AppColors.pinkRedIcon;
    } else if (transactionType == 'StockIn') {
      return AppColors.greenIcon;
    }
    return AppColors.orangeIcon;
  }
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ActivityLogEntry>>(
      future: _activityLogFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No activity log entries found.'));
        }

        final List<ActivityLogEntry> entries = snapshot.data!;
        return Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
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
                      'Activity Log (${entries.length} entries)',
                      style: AppTextStyles.cardHeader
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries.map((entry) {
                final formattedDate = DateFormatter.formatDateTimeLong(entry.transactionDate);
                return
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container( 
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 16.0, left: 16.0, right: 16.0 ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      entry.transactionType == 'StockOut'
                                          ? LucideIcons.trendingDown
                                          : LucideIcons.trendingUp, 
                                      color: _getStockColor(entry.transactionType), 
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      entry.itemName,
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
                                      entry.transactionType == 'StockOut' ? '-1' : '+1',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: _getStockColor(entry.transactionType)), 
                                    ),
                                    Text(
                                      'units',
                                      style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: _getStockColor(entry.transactionType),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                entry.transactionType,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600), 
                              ),
                            ),
                            const SizedBox(height: 16.0), 
                    
                            Row(
                              children: [
                                Icon(LucideIcons.hash, size: 16, color: AppColors.primaryBlue), 
                                const SizedBox(width: 8.0),
                                Text(entry.serialNumber, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(LucideIcons.user2, size: 16, color: AppColors.textBlack),
                                const SizedBox(width: 8.0),
                                Text(entry.userName, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(LucideIcons.calendar, size: 16, color: AppColors.purpleIcon),
                                const SizedBox(width: 8.0),
                                Text(formattedDate, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)), 
                              ],
                            ),
                            Divider(height: 24.0, thickness: 1.0, color: AppColors.textFieldBorder),
                    
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Transaction Value:',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)), 
                                Text(
                                  '\$${entry.transactionValue.toStringAsFixed(2)}', 
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkBlue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ]
          );
        }
      );         
    }          
}
        
      
    
  

