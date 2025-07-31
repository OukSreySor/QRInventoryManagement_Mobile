import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/services/dio_client.dart';
import 'package:qr_inventory_management/widgets/icon_button.dart';
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

  DateTime? _startDate;
  DateTime? _endDate;

  Future<Report> _fetchReport() async {
    final queryParameters = <String, dynamic>{};
    if (_startDate != null) {
      queryParameters['startDate'] = _startDate!;
    }
    if (_endDate != null) {
      queryParameters['endDate'] = _endDate!;
    }

    final res = await DioClient.dio.get(
      '/Transaction/summary',
      queryParameters: queryParameters,
    );

    if (res.statusCode == 200 && res.data['success']) {
      print('API Response Data: ${res.data}');
      return Report.fromJson(res.data);
    } else {
      throw Exception('Failed to load report: ${res.data}');
    }
  }

  @override
  void initState() {
    super.initState();
    _reportFuture = _fetchReport(); 
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _refreshReport() {
    setState(() {
      _reportFuture = _fetchReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 8),
        // Date filter row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerField('Start Date', _startDate, _selectStartDate),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePickerField('End Date', _endDate, _selectEndDate),
                  ),
                  
                ],
              ),
              const SizedBox(height: 8),
              ActionIconButton(
                label: 'Apply', 
                icon: LucideIcons.check, 
                backgroundColor: AppColors.primaryBlue,
                onPressed: _refreshReport,
                width: 100,
              ),
              
            ],
          ),
        ),
        FutureBuilder<Report>(
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
        
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                InfoCardGrid(cards: cards),
                const SizedBox(height: 8.0),
                _buildStockMovement(report),
                const SizedBox(height: 8.0),
                _buildCategoryBreakdown(report),
                const SizedBox(height: 8.0),
                _buildLast7DaysActivity(report),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDatePickerField(String label, DateTime? date, VoidCallback onTap) {
    final text = date == null ? label : '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.textFieldBorder),
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(text, style: AppTextStyles.labelStyle),
            const Spacer(),
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
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
