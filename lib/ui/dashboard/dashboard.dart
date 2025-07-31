import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/controllers/auth_controller.dart';
import 'package:qr_inventory_management/services/api_service.dart';
import 'package:qr_inventory_management/ui/dashboard/widgets/low_stock_alert.dart';
import 'package:qr_inventory_management/ui/dashboard/widgets/stock_trend_line_chart.dart';
import 'package:qr_inventory_management/ui/dashboard/widgets/top_sale_product.dart';
import 'package:qr_inventory_management/ui/manage/categories.dart';
import 'package:qr_inventory_management/ui/manage/products_management.dart';
import 'package:qr_inventory_management/ui/manage/inventory_report.dart';
import 'package:qr_inventory_management/ui/qrcode/batch_qr_code_generator.dart';
import 'package:qr_inventory_management/ui/stock/product_stock_summary.dart';
import 'package:qr_inventory_management/ui/stock/stock_in.dart';
import 'package:qr_inventory_management/ui/stock/stock_out.dart';
import '../../models/report.dart';
import '../../models/user.dart';
import '../../theme/theme.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/navigation_tabs.dart';
import '../../widgets/user_stats_card.dart';
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
  final _apiService = ApiService();

  final AuthController authController = Get.find<AuthController>();

  int _mainTabIndex = 0;
  int _subTabIndex = 0;
  int _subTab2Index = 0;

  int? _selectedProductId;

  Report? _dashboardSummary;
  StockCount? _stockCount;

  int stockInCount = 0;
  int stockOutCount = 0;

  void _handleViewDetails(int productId) {
    setState(() {
      _selectedProductId = productId;
      _subTabIndex = 4; 
    });
  }
   void _handleBackFromDetails() {
    setState(() {
      _subTabIndex = 2; // Go back to the 'Items' list tab
      _selectedProductId = null; // Clear selected product ID
    });
  }

  @override
  void initState() {
    super.initState();
    _mainTabIndex = widget.initialMainTabIndex ?? 0;

    if (_mainTabIndex == 1) {
      _subTabIndex = widget.initialSubTabIndex ?? 0;
    } else if (_mainTabIndex == 3) {
      _subTab2Index = widget.initialSubTabIndex ?? 0;
    }

    _fetchDashboardSummary();
    _fetchDailyStockCount();
  }

  Future<void> _fetchDashboardSummary() async {
  try {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/Transaction/summary',
      context: context,
      fromJson: (json) => json,
    );

    if (response != null && response['success'] == true) {
      final summary = Report.fromJson(response);
      setState(() {
        _dashboardSummary = summary;
      });
    } else {
      throw Exception('API returned invalid data or failure');
    }
  } catch (e) {
    print("Error loading dashboard summary: $e");
  }
}


  Future<void> _fetchDailyStockCount() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/Transaction/counts',
        context: context,
        fromJson: (data) => data,
      );

      if (response?['success'] == true) {
        setState(() {
          _stockCount = StockCount(
            stockInCount: response?['stockInCount'],
            stockOutCount: response?['stockOutCount'],
          );
        });
      }
    } catch (e) {
      print("Error fetching daily counts: $e");
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

    return '$roleName - $name';
  }

  List<InfoCardData> _buildInfoCards() {
    final summary = _dashboardSummary;

    return [
      InfoCardData(
        icon: LucideIcons.package,
        title: 'Total Items',
        value: summary != null ? summary.totalInStock.toString() : '-',
        iconColor: AppColors.purpleIcon,
      ),
      InfoCardData(
        icon: LucideIcons.dollarSign,
        title: 'Inventory Value',
        value: summary != null ? '\$${summary.inventoryValue.toStringAsFixed(2)}' : '-',
        iconColor: AppColors.greenIcon,
      ),
      InfoCardData(
        icon: LucideIcons.trendingUp,
        title: 'Stock In (Last 7 days)',
        value: summary != null ? summary.recentStockInsLast7Days.toString() : '-',
        iconColor: AppColors.greenIcon,
      ),
      InfoCardData(
        icon: LucideIcons.trendingDown,
        title: 'Stock Out (Last 7 days)',
        value: summary != null ? summary.recentStockOutsLast7Days.toString() : '-',
        iconColor: AppColors.pinkRedIcon,
      ),
    ];
    
  }

  List<CardData> _buildUserCardData() {
    final count = _stockCount;
    return [
      CardData(
        icon: LucideIcons.trendingUp,
        title: 'Stock In (Today)',
        value: count != null ? count.stockInCount.toString() : '-',
        iconColor: AppColors.greenIcon,
      ),
      CardData(
        icon: LucideIcons.trendingDown,
        title: 'Stock Out (Today)',
        value: count != null ? count.stockOutCount.toString() : '-',
        iconColor: AppColors.pinkRedIcon,
      ),
    ];
  }
  

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = authController.user.value;
      final isAdmin = currentUser?.role.toLowerCase() == 'admin';

      final mainTabs = [
        TabItem(icon: LucideIcons.barChart3, label: 'Home'),
        TabItem(icon: LucideIcons.package, label: 'Stock'),
        TabItem(icon: LucideIcons.qrCode, label: 'QR'),
      ];

      if (isAdmin) {
        mainTabs.add(TabItem(icon: LucideIcons.settings, label: 'Tools'));
      }
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
                tabs: mainTabs,
                initialIndex: _mainTabIndex >= mainTabs.length ? 0 : _mainTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _mainTabIndex = index;
                    _subTabIndex = 0;
                    _subTab2Index = 0; 
                  });
                  if (index == 0) {
                    _fetchDashboardSummary();
                    _fetchDailyStockCount(); 
                  }
                },
              ),
              const SizedBox(height: 16.0),
              if (_mainTabIndex == 1 || (_mainTabIndex == 3 && isAdmin))
                Column(
                  children: [
                    NavigationTabs(
                      key: ValueKey('subTabs_$_mainTabIndex'),
                      tabs: _mainTabIndex == 1
                        ? [
                            TabItem(icon: LucideIcons.plus, label: 'In'),
                            TabItem(icon: LucideIcons.minus, label: 'Out'),
                            TabItem(icon: LucideIcons.box, label: 'Items'),
                            TabItem(icon: LucideIcons.activity, label: 'Activity'),
                          ]
                        : [
                            TabItem(icon: LucideIcons.folder, label: 'Groups', labelStyle: TextStyle(fontSize: 12.0)),
                            TabItem(icon: LucideIcons.package, label: 'Goods'),
                            TabItem(icon: LucideIcons.user, label: 'User'),
                            TabItem(icon: LucideIcons.fileText, label: 'Report'),
                          ],
                      initialIndex: _mainTabIndex == 1 ? _subTabIndex : _subTab2Index,
                      onTabSelected: (index) {
                        setState(() {
                          if (_mainTabIndex == 1) {
                            _subTabIndex = index;
                          } else {
                            _subTab2Index = index;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              _buildMainContent(isAdmin),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMainContent(bool isAdmin) {
    if (_mainTabIndex == 0) {
      return Column(
        children: [

          if (isAdmin) ... [
            InfoCardGrid(cards: _buildInfoCards()),
            SizedBox(height: 8.0),
            LowStockAlert(
              lowStockProducts: _dashboardSummary?.lowStockProducts ?? [],
            ),
            SizedBox(height: 8.0),
            TopSaleProduct(
              hotProducts: _dashboardSummary?.hotProducts30Days ?? [],
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 300.0, 
              child: StockTrendLineChart()
            ),
            
          ] else ...[
            UserStatsCard(cards: _buildUserCardData(), cardWidth: 164),
            SizedBox(height: 16.0),
            SizedBox(width: double.infinity, child: RecentActivitySection()),
            
          ],
          SizedBox(height: 8.0),
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
          return ActivityLog(); 
        case 4: 
          if (_selectedProductId != null) {
            return ProductItemDetails(
              productId: _selectedProductId!,
              onBack: _handleBackFromDetails,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No product selected for details.'),
                  ElevatedButton(
                    onPressed: () => setState(() => _subTabIndex = 2),
                    child: const Text('Go to Product Items'),
                  ),
                ],
              ),
            );
          }
        default: 
          return const Center(child: Text('Invalid Stock Sub-tab Selected'));
      
    }
}

    if (_mainTabIndex == 2) {
      return Center(
        child: BatchQrCodeGenerator()
      );
    }

    if (_mainTabIndex == 3) {
      if (!isAdmin) {
        return Center(child: Text('Access Denied: You do not have permission to view this section.'));
      }
      switch (_subTab2Index) {
        case 0:
          return Categories();
        case 1:
          return ProductsManagementScreen();
        case 2:
          return InviteCodesContainer();
        case 3:
          return InventoryReportsScreen();
        default: 
          return const Center(child: Text('Invalid Manage Sub-tab Selected'));
      
      }
    }
    return const SizedBox.shrink(); // fallback
  }
}



    
 