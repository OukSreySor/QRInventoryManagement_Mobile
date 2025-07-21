import 'package:flutter/material.dart';
import '../theme/theme.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  Color? confirmColor,
  IconData? icon,
  Color? iconColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.lightBlue.shade50,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) 
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primaryBlue,
                size: 24.0,
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleStyle.copyWith(
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0), 

      content: Text(
        content,
        style: AppTextStyles.authSectionDescription.copyWith(
          color: AppColors.textBlack,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0), 
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), 
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: AppColors.textFieldBorder),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              const Icon(Icons.close, color: AppColors.textBlack, size: 18.0),
              const SizedBox(width: 8.0), 
              Text(
                cancelText,
                style: TextStyle(
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0), 
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? AppColors.primaryBlue,
            foregroundColor: Colors.white, 
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Row( 
            mainAxisSize: MainAxisSize.min, 
            children: [
              const Icon(Icons.check, color: Colors.white, size: 18.0), 
              const SizedBox(width: 8.0), 
              Text(
                confirmText,
                style: TextStyle(
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  return result ?? false; 
}