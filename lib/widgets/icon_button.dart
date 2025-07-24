import 'package:flutter/material.dart';
import '../theme/theme.dart'; 

class ActionIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;

  const ActionIconButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.onPressed,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: AppColors.textWhite),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
