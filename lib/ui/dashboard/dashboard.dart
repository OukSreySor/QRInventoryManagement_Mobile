
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/navigation_tabs.dart';
import 'widgets/info_card_grid.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/call_to_action_banner.dart';

class DashboardScreen extends StatelessWidget {
  final String userRole;

  const DashboardScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(subtitle: _getSubtitle(userRole)),
            const SizedBox(height: 28.0),
            const NavigationTabs(),
            const SizedBox(height: 28.0),
            const InfoCardGrid(),
            const SizedBox(height: 28.0),
            const RecentActivitySection(),
            const SizedBox(height: 28.0),
            const CallToActionBanner(),
          ],
        ),
      ),
    );
  }

  String _getSubtitle(String role) {
    return role == 'admin'
        ? 'Admin Panel - John Doe (admin)'
        : 'Demo Company - John Doe (user)';
  }
}
