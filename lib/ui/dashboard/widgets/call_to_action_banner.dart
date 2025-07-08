import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';

class CallToActionBanner extends StatelessWidget {
  const CallToActionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), 
        gradient: const LinearGradient( 
          colors: [
            AppColors.bannerGradientStart,
            AppColors.bannerGradientEnd,
          ],
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight, 
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          const Icon(
            LucideIcons.trendingUp, 
            size: 60.0,
            color: AppColors.textWhite, 
          ),
          const SizedBox(height: 16.0), 
          Text(
            'Ready to manage your inventory?',
            textAlign: TextAlign.center, 
            style: AppTextStyles.bannerHeadline, 
          ),
          const SizedBox(height: 8.0), 
          Text(
            'Use the tabs below to add or remove items',
            textAlign: TextAlign.center, 
            style: AppTextStyles.bannerDescription, 
          ),
        ],
      ),
    );
  }
}
