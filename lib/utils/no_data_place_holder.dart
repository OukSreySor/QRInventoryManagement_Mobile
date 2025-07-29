import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_inventory_management/theme/theme.dart'; 

class NoDataPlaceholder extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final double iconSize; 
  final Color iconColor; 
  const NoDataPlaceholder({
    super.key,
    required this.title,
    this.message,
    this.icon = LucideIcons.package, 
    this.iconSize = 60.0,
    this.iconColor = AppColors.textDark, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28.0), 
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10.0), 
        border: Border.all(color: AppColors.textFieldBorder, width: 1.0)
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 4.0),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}