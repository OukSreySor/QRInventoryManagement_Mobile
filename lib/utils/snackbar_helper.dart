import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme.dart';

class SnackbarHelper {
  static void display({
    required String title,
    required String message,
    IconData icon = Icons.info_outline,
    Color backgroundColor = Colors.blue,
    Color textColor = Colors.white,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 5),
  }) {
    Get.snackbar(
      '', '',
      titleText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      snackPosition: position,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      duration: duration,
      icon: Icon(icon, color: textColor),
      shouldIconPulse: false,
    );
  }

  static void error(String message) => display(
        title: 'Error',
        message: message,
        icon: Icons.error_outline,
        backgroundColor: AppColors.pinkRedIcon,
      );

  static void warning(String message) => display(
        title: 'Warning',
        message: message,
        icon: Icons.warning_amber_rounded,
        backgroundColor: AppColors.orangeIcon,
      );

  static void success(String message) => display(
        title: 'Success',
        message: message,
        icon: Icons.check_circle_outline,
        backgroundColor: AppColors.greenIcon,
      );
}
