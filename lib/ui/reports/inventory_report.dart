import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/widgets/info_card_grid.dart';
import '../../theme/theme.dart';

class InventoryReportsScreen extends StatelessWidget {
  InventoryReportsScreen({super.key});

  final List<InfoCardData> myCards = [
  InfoCardData(
    icon: LucideIcons.package,
    title: 'Total Units',
    value: '5',
    iconColor: AppColors.primaryBlue
  ),
  InfoCardData(
    icon: LucideIcons.dollarSign,
    title: 'Inventory Value',
    value: '\$250.00',
    iconColor: AppColors.greenIcon,
  ),
  InfoCardData(
    icon: LucideIcons.trendingUp,
    title: 'Total Sales',
    value: '\$160.00',
    iconColor: AppColors.greenIcon,
  ),
  InfoCardData(
    icon: LucideIcons.trendingUp,
    title: 'Potential Profit',
    value: '\$30.00',
    iconColor: AppColors.greenIcon,
  ),
];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                )   
            ),
            const SizedBox(height: 16.0),
            InfoCardGrid(cards: myCards),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.textFieldBorder, width: 1.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock Movement Summary', style: AppTextStyles.titleStyle),
                    const SizedBox(height: 8),
                    _buildStockMovementItem('Total Stock In', '+6 units', AppColors.greenIcon),
                    _buildStockMovementItem('Total Stock Out', '-1 units', AppColors.pinkRedIcon),
                    const Divider(color: AppColors.textFieldBorder, thickness: 1.0,),
                    _buildStockMovementItem('Net Stock', '5 units', AppColors.darkBlue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.textFieldBorder, width: 1.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category Breakdown', style: AppTextStyles.titleStyle),
                    const SizedBox(height: 8.0),
                    _buildCategoryBreakdownItem('Electronics', '1 product, 5 units', '\$250.00'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.textFieldBorder, width: 1.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last 7 Days Activity', style: AppTextStyles.titleStyle),
                    const SizedBox(height: 8.0),
                    _buildActivityItem('Total Transactions:', '3'),
                    _buildActivityItem('Units In:', '+6', AppColors.greenIcon),
                    _buildActivityItem('Units Out:', '-1', AppColors.pinkRedIcon),
                  ],
                ),
              ),
            ),
          ],
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
          Text(category, style: AppTextStyles.labelStyle),
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
