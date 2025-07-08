import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/theme.dart';

class DashboardHeader extends StatelessWidget {
  final String subtitle;
  const DashboardHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.package,
              size: 48.0,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 10.0),
            Text(
              'StockFlow',
              style: AppTextStyles.headline,
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        Text(
          subtitle,
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}