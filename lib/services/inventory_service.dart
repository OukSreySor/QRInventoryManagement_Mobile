import 'package:dio/dio.dart';
import 'package:qr_inventory_management/models/recent_activity.dart';

import '../models/report.dart';
import 'dio_client.dart';

class InventoryService {
  Future<Report> fetchInventoryReport() async {
    try {
      final response = await DioClient.dio.get('/Transaction/summary');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return Report.fromJson(response.data);

      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<RecentActivity>> fetchRecentActivities({int limit = 5}) async {
    try {
      final response = await DioClient.dio.get(
        '/Transaction/recent-activity', 
        queryParameters: {'limit': limit}, 
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> activityData = response.data['data'];
       
        return activityData.map((json) => RecentActivity.fromJson(json)).toList();
      } else {
        final String errorMessage = response.data['message'] ?? "Failed to load recent activities";
        throw Exception(errorMessage);
      }
    } on DioException catch (e) { 
      String errorMessage = "Error fetching recent activities: ";
      if (e.response != null) {

        errorMessage += "Status: ${e.response!.statusCode}, Data: ${e.response!.data}";
      } else {

        errorMessage += e.message ?? "Unknown Dio error";
      }
      print(errorMessage);
      rethrow;
    } catch (e) {
      
      print('Unexpected error fetching recent activities: $e');
      rethrow;
    }
  }
}