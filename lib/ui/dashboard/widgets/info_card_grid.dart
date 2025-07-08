import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';

class InfoCardGrid extends StatelessWidget {
  const InfoCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cardData = [
      {
        'icon': LucideIcons.package, 
        'title': 'Total Units',
        'value': '0',
        'iconColor': AppColors.purpleIcon,
      },
      {
        'icon': LucideIcons.dollarSign,   
        'title': 'Total Value',
        'value': '\$0.00',
        'iconColor': AppColors.greenIcon,
      },
      {
        'icon': LucideIcons.activity,   
        'title': 'Today\'s Activity',
        'value': '0',
        'iconColor': AppColors.pinkRedIcon,
      },
      {
        'icon': LucideIcons.alertTriangle,  
        'title': 'Low Stock',
        'value': '0',
        'iconColor': AppColors.orangeIcon,
      },
    ];

    return GridView.builder(
      shrinkWrap: true, // Allows GridView to take only the space it needs
      physics: const NeverScrollableScrollPhysics(), // Prevents GridView from having its own scroll physics
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  
        crossAxisSpacing: 18.0,   
        mainAxisSpacing: 18.0,  
        childAspectRatio: 1.4,  
      ),
      itemCount: cardData.length,   
      itemBuilder: (context, index) {
        return _buildInfoCard(
          cardData[index]['icon'],
          cardData[index]['title'],
          cardData[index]['value'],
          cardData[index]['iconColor'],
        );
      },
    );
  }

  Widget _buildInfoCard(
      IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,  
        borderRadius: BorderRadius.circular(16.0), 
        border: Border.all(color: AppColors.borderContainer, width: 1) 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
        children: [
          Icon(
            icon,
            size: 32.0,
            color: iconColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.infoCardTitle,   
              ),
              const SizedBox(height: 4.0), 
              Text(
                value,
                style: AppTextStyles.infoCardValue,   
              ),
            ],
          ),
        ],
      ),
    );
  }
}

