import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryBlue = Color(0xFF3572DF); // Main Blue
  static const Color secondaryBlue = Color(0xFF3778E7); // Slightly lighter blue
  static const Color white = Color(0xFFFFFFFF);

  
  static const Color textGray = Color(0xFF7F8C8D); // For muted text
  static const Color lightGray = Color(0xFFBDC3C7); // Backgrounds
  static const Color borderGray = Color(0xFFE5E8EC); // Input borders
  static const Color backgroundGray = Color(0xFFF5F6FA); // Cards, pages

  static const Color cardBackground = Color(0xFFF5F6FA);
  static const Color border = Color(0xFFE5E8EC);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color success = Color(0xFF10B981);
  static const Color successBackground = Color(0xFFF0FDF4);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBackground = Color(0xFFFEF2F2);
  static const Color logout = Color(0xFFE74C3C);
  static const Color logoutHover = Color(0xFFFEF2F2);
  static const Color overlay = Color(0x80000000);
  
  static const Color primaryBlueHover = Color(
    0xFF2E64C8,
  ); 
  static const Color secondaryBlueDark = Color(
    0xFF2F6FD2,
  ); 

  static const Color primaryGradientEnd = Color(0xFF3778E7);
  static const Color background = Color(0xFFEAF1F8);
  static const Color backgroundGradientEnd = Color(0xFFD6E6F2);
  static const Color gradientStart = Color(0xFFEAF1F8); 
  static const Color gradientEnd = Color(0xFFD6E6F2); 

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}
