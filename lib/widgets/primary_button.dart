import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;  
  final VoidCallback onPressed;   
  final Color backgroundColor;  
  final Color textColor;  

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.buttonDark, 
    this.textColor = AppColors.textWhite, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, 
          padding: const EdgeInsets.symmetric(vertical: 8.0),  
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),  
          ),
          shadowColor: backgroundColor,
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(color: textColor), 
        ),
      ),
    );
  }
}
