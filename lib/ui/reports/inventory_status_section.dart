import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class InventoryStatsSection extends StatelessWidget {
  const InventoryStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                icon: Icons.inventory,
                label: 'Total Units',
                value: '5',
                color: AppColors.darkBlue,
              ),
              _buildStatCard(
                icon: Icons.attach_money,
                label: 'Inventory Value',
                value: '\$250.00',
                color: AppColors.greenIcon,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                icon: Icons.trending_up,
                label: 'Total Sales',
                value: '\$160.00',
                color: AppColors.greenIcon,
              ),
              _buildStatCard(
                icon: Icons.trending_up,
                label: 'Potential Profit',
                value: '\$30.00',
                color: AppColors.greenIcon,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,  
          borderRadius: BorderRadius.circular(16.0), 
          border: Border.all(color: AppColors.borderContainer, width: 1) 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(label, style: AppTextStyles.labelStyle),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.valueStyle.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
