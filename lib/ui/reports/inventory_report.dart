import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/services/dio_client.dart';
import 'package:qr_inventory_management/widgets/info_card_grid.dart';
import '../../models/report.dart';
import '../../theme/theme.dart';

class InventoryReportsScreen extends StatefulWidget {
  const InventoryReportsScreen({super.key});

  @override
  State<InventoryReportsScreen> createState() => _InventoryReportsScreenState();
}

class _InventoryReportsScreenState extends State<InventoryReportsScreen> {
  late Future<Report> _reportFuture;

  Future<Report> _fetchReport() async {
    final res = await DioClient.dio.get('/Transaction/summary');
    if (res.statusCode == 200 && res.data['success']) {
      return Report.fromJson(res.data);
    } else {
      throw Exception('Failed to load report');
    }
  }

  @override
  void initState() {
    super.initState();
    _reportFuture = _fetchReport(); 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Report>(
      future: _reportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final report = snapshot.data!;

        final List<InfoCardData> cards = [
          InfoCardData(
            icon: LucideIcons.package,
            title: 'Total Units',
            value: report.totalInStock.toString(),
            iconColor: AppColors.primaryBlue,
          ),
          InfoCardData(
            icon: LucideIcons.dollarSign,
            title: 'Inventory Value',
            value: '\$${report.inventoryValue.toStringAsFixed(2)}',
            iconColor: AppColors.greenIcon,
          ),
          InfoCardData(
            icon: LucideIcons.trendingUp,
            title: 'Total Sales',
            value: '\$${report.totalSalesValue.toStringAsFixed(2)}',
            iconColor: AppColors.greenIcon,
          ),
          InfoCardData(
            icon: LucideIcons.trendingUp,
            title: 'Potential Profit',
            value: '\$${report.potentialProfit.toStringAsFixed(2)}',
            iconColor: AppColors.greenIcon,
          ),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 16.0),
              InfoCardGrid(cards: cards),
              const SizedBox(height: 16.0),
              _buildStockMovement(report),
              const SizedBox(height: 16),
              _buildCategoryBreakdown(report),
              const SizedBox(height: 16),
              _buildLast7DaysActivity(report),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.inventory_sharp, size: 24, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              'Inventory Report',
              style: AppTextStyles.cardHeader
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockMovement(Report report) {
    return _styledSection(
      title: 'Stock Movement Summary',
      children: [
        _buildStockMovementItem('Total Stock In', '+${report.totalStockIns} units', AppColors.greenIcon),
        _buildStockMovementItem('Total Stock Out', '-${report.totalStockOuts} units', AppColors.pinkRedIcon),
        const Divider(color: AppColors.textFieldBorder, thickness: 1.0),
        _buildStockMovementItem('Net Stock', '${report.netStock} units', AppColors.darkBlue),
      ],
    );
  }

  Widget _buildCategoryBreakdown(Report report) {
    return _styledSection(
      title: 'Category Breakdown',
      children: report.categoryBreakdown.map((c) {
        final detail = '${c.productCount} product${c.productCount > 1 ? 's' : ''}, ${c.totalUnits} units';
        return _buildCategoryBreakdownItem(c.categoryName, detail, '');
      }).toList(),
    );
  }

  Widget _buildLast7DaysActivity(Report report) {
    final totalTrans = report.recentStockInsLast7Days + report.recentStockOutsLast7Days;
    return _styledSection(
      title: 'Last 7 Days Activity',
      children: [
        _buildActivityItem('Total Transactions:', '$totalTrans'),
        _buildActivityItem('Units In:', '+${report.recentStockInsLast7Days}', AppColors.greenIcon),
        _buildActivityItem('Units Out:', '-${report.recentStockOutsLast7Days}', AppColors.pinkRedIcon),
      ],
    );
  }

  Widget _styledSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.textFieldBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.titleStyle),
          const SizedBox(height: 8.0),
          ...children,
        ]),
      ),
    );
  }

  Widget _buildStockMovementItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.labelStyle),
          Text(value, style: AppTextStyles.valueStyle.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownItem(String category, String details, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: AppTextStyles.labelStyle.copyWith(color: AppColors.darkBlue)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(details, style: AppTextStyles.labelStyle),
              Text(value, style: AppTextStyles.valueStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.labelStyle),
          Text(value, style: AppTextStyles.valueStyle.copyWith(color: color)),
        ],
      ),
    );
  }
}
