import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppColors {
  static const Color primaryBlue = Color(0xFF2563EB); 
  static const Color lightBackground = Color(0xFFE7EEFF); 
  static const Color cardBackground = Colors.white; 
  static const Color textDark = Color(0xFF4B5563); 
  static Color textMedium = Color(0xFF757575);
  static Color textLight = Color(0xFF9E9E9E); 
  static const Color textWhite = Colors.white; 
  static const Color textBlack = Colors.black; 

  static const Color bannerGradientStart = Color(0xFF6B8BFB);
  static const Color bannerGradientEnd = Color(0xFF8A6CFB);

  static const Color purpleIcon = Color(0xFF6A1B9A);
  static const Color greenIcon = Color(0xFF16A34A);
  static const Color pinkRedIcon = Color(0xFFEF4444);
  static const Color orangeIcon = Color(0xFFF47914);

  static const Color buttonDark = Color(0xFF212121); 
  static const Color textFieldBorder = Color(0xFFE2E8F0); 
  static const Color borderContainer = Color(0xFFE2E8F0);
  static const Color tabBackground = Color(0xFFF1F5F9); 
  static const Color tabSelectedBackground = Colors.white;
  static const Color tabUnselectedBackground = Colors.transparent;
}

class AppTextStyles {
  static TextStyle headline = GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textBlack,
  );

  static TextStyle subtitle = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle tabSelected = GoogleFonts.montserrat(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlue,
  );

  static TextStyle tabUnselected = GoogleFonts.montserrat(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle infoCardTitle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle infoCardValue = GoogleFonts.montserrat(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle sectionTitle = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle sectionDescription = GoogleFonts.montserrat(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static TextStyle bannerHeadline = GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle bannerDescription = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle authSectionTitle = GoogleFonts.montserrat(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );

  static TextStyle authSectionDescription = GoogleFonts.montserrat(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle textFieldLabel = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle buttonText = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle secondaryButtonText = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
}

class AppSpacings {
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 40;

  static const double radius = 16;
  static const double radiusLarge = 24;
}

class AppSizes {
  static const double icon = 24;
  static const double buttonHeight = 48;
}


ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.lightBackground,
  fontFamily: GoogleFonts.montserrat().fontFamily,
);
