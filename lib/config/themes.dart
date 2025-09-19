import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(AppConstants.primaryColor),
        brightness: Brightness.light,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Card Theme (for ATS-friendly design)
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        color: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(AppConstants.lightGrayColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Color(AppConstants.darkGrayColor)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Color(AppConstants.lightGrayColor)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Color(AppConstants.primaryColor), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        labelStyle: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Color(AppConstants.textColor),
        ),
        hintStyle: TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: Color(AppConstants.darkGrayColor),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(AppConstants.primaryColor),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          textStyle: TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(AppConstants.primaryColor),
          textStyle: TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(AppConstants.primaryColor),
          side: BorderSide(color: Color(AppConstants.primaryColor)),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          textStyle: TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Text Theme (ATS-friendly typography)
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(AppConstants.textColor),
        ),
        displayMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(AppConstants.textColor),
        ),
        displaySmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textColor),
        ),
        headlineLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textColor),
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textColor),
        ),
        headlineSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textColor),
        ),
        titleLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textColor),
        ),
        titleMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textColor),
        ),
        titleSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textColor),
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.secondaryFont,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(AppConstants.textColor),
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.secondaryFont,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(AppConstants.textColor),
        ),
        bodySmall: TextStyle(
          fontFamily: AppConstants.secondaryFont,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(AppConstants.darkGrayColor),
        ),
        labelLarge: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textColor),
        ),
        labelMedium: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.textColor),
        ),
        labelSmall: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(AppConstants.darkGrayColor),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Color(AppConstants.lightGrayColor),
        selectedColor: Color(AppConstants.accentColor),
        disabledColor: Color(AppConstants.darkGrayColor),
        labelStyle: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 12,
          color: Color(AppConstants.textColor),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingSmall,
          vertical: AppConstants.paddingSmall / 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Color(AppConstants.primaryColor),
        linearTrackColor: Color(AppConstants.lightGrayColor),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Color(AppConstants.lightGrayColor),
        thickness: 1,
        space: AppConstants.paddingMedium,
      ),
      
      // Background Color
      scaffoldBackgroundColor: Color(AppConstants.backgroundColor),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(AppConstants.primaryColor),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}

// Custom Colors for specific use cases
class JobLensColors {
  static const Color atsGreen = Color(0xFF27AE60);
  static const Color atsOrange = Color(0xFFF39C12);
  static const Color atsRed = Color(0xFFE74C3C);
  
  static const Color skillBeginner = Color(0xFFE8F5E8);
  static const Color skillIntermediate = Color(0xFFFFF3E0);
  static const Color skillAdvanced = Color(0xFFE3F2FD);
  static const Color skillExpert = Color(0xFFF3E5F5);
  
  // ATS Score Color Scale
  static Color getATSScoreColor(double score) {
    if (score >= 80) return atsGreen;
    if (score >= 60) return atsOrange;
    return atsRed;
  }
  
  // Skill Level Colors
  static Color getSkillLevelColor(int level) {
    switch (level) {
      case 1:
      case 2:
        return skillBeginner;
      case 3:
        return skillIntermediate;
      case 4:
        return skillAdvanced;
      case 5:
        return skillExpert;
      default:
        return skillBeginner;
    }
  }
}