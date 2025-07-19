import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;   
  final String hintText;  
  final bool obscureText;   
  final TextEditingController controller;  
  final TextInputType keyboardType;  
  final String? Function(String?)? validator; 
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final double? hintFontSize;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,   
    this.obscureText = false,   
    required this.controller,
    this.keyboardType = TextInputType.text,  
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.hintFontSize,
    this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,   
      children: [
        Text(
          label,
          style: AppTextStyles.textFieldLabel,  
        ),
        const SizedBox(height: 8.0),  
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(color: AppColors.textBlack),  
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 16.0, color: AppColors.textLight).copyWith(fontSize: hintFontSize), 
            suffixIcon: suffixIcon,  
            filled: true,
            fillColor: AppColors.cardBackground,  
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0), 
            border: OutlineInputBorder(   
              borderRadius: BorderRadius.circular(10.0),  
              borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1.0),   
            ),
            enabledBorder: OutlineInputBorder(  
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(  
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.0), 
            ),
          ),
        ),
      ],
    );
  }
}
