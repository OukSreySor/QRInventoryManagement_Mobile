import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/controllers/auth_controller.dart';
import 'package:qr_inventory_management/ui/manage/categories.dart';
import 'package:qr_inventory_management/ui/manage/products.dart';
import 'package:qr_inventory_management/ui/reports/inventory_report.dart';
import 'package:qr_inventory_management/ui/stock/product_stock_summary.dart';
import 'package:qr_inventory_management/ui/stock/stock_in.dart';
import 'package:qr_inventory_management/ui/stock/stock_out.dart';
import '../../models/user.dart';
import '../../theme/theme.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/navigation_tabs.dart';
import '../manage/user_setting.dart';
import '../stock/activity_log.dart';
import '../stock/product_item_details.dart';
import '../../widgets/info_card_grid.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/call_to_action_banner.dart';

class DashboardScreen extends StatefulWidget {
  final int? initialMainTabIndex;
  final int? initialSubTabIndex;

  DashboardScreen({
    super.key,
    this.initialMainTabIndex,
    this.initialSubTabIndex,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthController authController = Get.find<AuthController>();

  int _mainTabIndex = 0;
  int _subTabIndex = 0;
  int _subTab2Index = 0;

  bool _showAddProductForm = false;

  int? _selectedProductId;

  void _handleViewDetails(int productId) {
    setState(() {
      _selectedProductId = productId;
      _subTabIndex = 4; 
    });
  }


  final List<InfoCardData> cards = [
    InfoCardData(
      icon: LucideIcons.package,
      title: 'Total Units',
      value: '0',
      iconColor: AppColors.purpleIcon,
    ),
    InfoCardData(
      icon: LucideIcons.dollarSign,
      title: 'Total Value',
      value: '\$0.00',
      iconColor: AppColors.greenIcon,
    ),
    InfoCardData(
      icon: LucideIcons.activity,
      title: 'Today\'s Activity',
      value: '0',
      iconColor: AppColors.pinkRedIcon,
    ),
    InfoCardData(
      icon: LucideIcons.alertTriangle,
      title: 'Low Stock',
      value: '0',
      iconColor: AppColors.orangeIcon,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainTabIndex = widget.initialMainTabIndex ?? 0;

    if (_mainTabIndex == 1) {
      _subTabIndex = widget.initialSubTabIndex ?? 0;
    } else if (_mainTabIndex == 3) {
      _subTab2Index = widget.initialSubTabIndex ?? 0;
    }
  }
  String _roleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'user':
        return 'User';
      default:
        return 'Member';
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
              NavigationTabs(
                tabs: [
                  TabItem(icon: LucideIcons.barChart3, label: 'Home'),
                  TabItem(icon: LucideIcons.package, label: 'Stock'),
                  TabItem(icon: LucideIcons.qrCode, label: 'QR Batch'),
                  TabItem(icon: LucideIcons.settings, label: 'Manage'),
                ],
                initialIndex: _mainTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _mainTabIndex = index;
                    _subTabIndex = 0;
                    _subTab2Index = 0; 
                  });
                },
              ),
              const SizedBox(height: 20.0),
              if (_mainTabIndex == 1 || _mainTabIndex == 3)
                Column(
                  children: [
                    NavigationTabs(
                      tabs: _mainTabIndex == 1
                        ? [
                            TabItem(icon: LucideIcons.plus, label: 'In'),
                            TabItem(icon: LucideIcons.minus, label: 'Out'),
                            TabItem(icon: LucideIcons.list, label: 'List'),
                            TabItem(icon: LucideIcons.activity, label: 'Activity'),
                          ]
                        : [
                            TabItem(icon: LucideIcons.folder, label: 'Categories'),
                            TabItem(icon: LucideIcons.package, label: 'Products'),
                            TabItem(icon: LucideIcons.user, label: 'Users'),
                            TabItem(icon: LucideIcons.receipt, label: 'Report'),
                          ],
                      initialIndex: _mainTabIndex == 1 ? _subTabIndex : _subTab2Index,
                      onTabSelected: (index) {
                        setState(() {
                          if (_mainTabIndex == 1) {
                            _subTabIndex = index;
                          } else {
                            _subTab2Index = index;
                          }
                         
                          _showAddProductForm = false;
                        });
                      },
                    ),
                    const SizedBox(height: 28.0),
                  ],
                ),
              _buildMainContent(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMainContent() {
    if (_mainTabIndex == 0) {
      return Column(
        children: [
          InfoCardGrid(cards: cards),
          SizedBox(height: 18.0),
          SizedBox(width: double.infinity, child: RecentActivitySection()),
          SizedBox(height: 18.0),
          SizedBox(width: double.infinity, child: CallToActionBanner()),
        ],
      );
    }

    if (_mainTabIndex == 1) {
      switch (_subTabIndex) {
        case 0:
          return const StockInSection();
        case 1:
          return const StockOutSection();
        case 2:
          return ProductStockSummary(
            onViewDetails: _handleViewDetails,
          );
        case 3:
          return ActivityLog(itemId: 52, serialNumber: 'SDFWO9', transactionType: 'Stock In', transactionDate: DateTime.now(), userName: 'Dara'); 
        case 4: 
          if (_selectedProductId != null) {
            return ProductItemDetails(productId: _selectedProductId!);
          } else {
            return const Center(child: Text('No product selected.'));
          }
    }
}

    if (_mainTabIndex == 2) {
      return const Center(child: Text("QR Batch section"));
    }

    if (_mainTabIndex == 3) {
      switch (_subTab2Index) {
        case 0:
          return Categories();
        case 1:
          return ProductsManagementScreen(
            onAddPressed: () => setState(() => _showAddProductForm = true),
            showAddForm: _showAddProductForm,
            onCancelAddForm: () => setState(() => _showAddProductForm = false),
          );
        case 2:
          return const InviteCodesContainer();
        case 3:
          return InventoryReportsScreen();
      }
    }


    return const SizedBox.shrink(); // fallback
  }
}
