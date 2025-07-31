import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme.dart';
import '../../../models/recent_activity.dart'; 

class RecentActivitySection extends StatefulWidget {
  const RecentActivitySection({super.key});

  @override
  State<RecentActivitySection> createState() => _RecentActivitySectionState();
}

class _RecentActivitySectionState extends State<RecentActivitySection> {
  late Future<List<RecentActivity>> _recentActivitiesFuture;
  final ApiService _apiService = ApiService(); 

  Future<List<RecentActivity>> fetchRecentActivities({required BuildContext context, int limit = 5}) async {
  try {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/Transaction/recent-activity',
      queryParams: {'limit': limit},
      context: context,
      fromJson: (data) => data,
    );

    if (response != null && response['success'] == true) {
      final List<dynamic> activityData = response['data'];
      return activityData.map((json) => RecentActivity.fromJson(json)).toList();
    } else {
      final String errorMessage = response?['message'] ?? "Failed to load recent activities";
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Error fetching recent activities: $e');
    rethrow;
  }
}

  @override
  void initState() {
    super.initState();

    _recentActivitiesFuture = fetchRecentActivities(context: context, limit: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderContainer, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.history,
                size: 24.0,
                color: AppColors.textBlack,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Recent Activity',
                style: AppTextStyles.sectionTitle.copyWith(color: AppColors.textBlack),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          FutureBuilder<List<RecentActivity>>(
            future: _recentActivitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Failed to load activities: ${snapshot.error}',
                      style: AppTextStyles.sectionDescription.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text(
                  'No activity yet. Start by adding some inventory!',
                  style: AppTextStyles.sectionDescription,
                );
              } else {
                final List<RecentActivity> activities = snapshot.data!;

                return Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: activities.map((activity) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              activity.relativeTransactionTime,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: AppColors.textLight,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            width: 2,
                            height: 12,
                            color: AppColors.borderContainer,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(text: activity.productName),
                                      TextSpan(text: ' (Serial: ${activity.serialNumber}) '),
                                      TextSpan(text: activity.transactionType),
                                      TextSpan(text: ' ${activity.userName}'),
                                    ],
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),)
                        ]
                      )
                    );
                  }).toList(), 
                );
              }
            },
          ),
        ],
      ),
    );
  }
}