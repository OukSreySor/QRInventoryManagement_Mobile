import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/theme.dart';

class DashboardHeader extends StatelessWidget {
  final String subtitle;
  final VoidCallback? onLogout;

  const DashboardHeader({super.key, required this.subtitle, this.onLogout});

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
        SizedBox(
          width: double.infinity, 
          child: Stack(
            alignment: Alignment.center, 
            children: [
              // Subtitle (always centered within the Stack's full width)
              Text(
                subtitle,
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center, 
                overflow: TextOverflow.ellipsis, 
                maxLines: 1, 
              ),
              if (onLogout != null) 
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: onLogout, 
                    icon: const Icon(
                      LucideIcons.logOut,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                    tooltip: 'Logout',
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}

