import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,  
        borderRadius: BorderRadius.circular(12.0),  
        border: Border.all(color: AppColors.borderContainer, width: 1)
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
          Text(
            'No activity yet. Start by adding some inventory!',
            style: AppTextStyles.sectionDescription, 
          ),
        ],
      ),
    );
  }
}

