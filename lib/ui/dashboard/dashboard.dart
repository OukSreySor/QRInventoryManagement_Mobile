import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_inventory_management/controllers/auth_controller.dart';
import '../../models/user.dart';
import '../../theme/theme.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/navigation_tabs.dart';
import 'widgets/info_card_grid.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/call_to_action_banner.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
    
  String _roleDisplayName(String role) {
    switch(role.toLowerCase()) {
      case 'admin': return 'Administrator';
      case 'user': return 'User';
      default: return 'Member';
    }
  }

  String _getSubtitle(User? user) {
    if (user == null) return 'Welcome';

    final roleName = _roleDisplayName(user.role);
    final name = user.username;

    return '$roleName Panel - $name';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = authController.user.value;

      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(
                subtitle: _getSubtitle(currentUser),
                onLogout: () {
                  if (!Get.isRegistered<AuthController>()) {
                    Get.put(AuthController()); // recreate if disposed
                  }
                  Get.find<AuthController>().logout();     
                },
              ),
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
  );
  }
}
