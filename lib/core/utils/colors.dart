import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryBlue = Color(0xFF3572DF); // Main Blue
  static const Color secondaryBlue = Color(0xFF3778E7); // Slightly lighter blue
  static const Color white = Color(0xFFFFFFFF);

  
  static const Color textGray = Color(0xFF7F8C8D); // For muted text
  static const Color lightGray = Color(0xFFBDC3C7); // Backgrounds
  static const Color borderGray = Color(0xFFE5E8EC); // Input borders
  static const Color backgroundGray = Color(0xFFF5F6FA); // Cards, pages

  
  static const Color primaryBlueHover = Color(
    0xFF2E64C8,
  ); 
  static const Color secondaryBlueDark = Color(
    0xFF2F6FD2,
  ); 

 
  static const Color gradientStart = Color(0xFFEAF1F8); // very light blue
  static const Color gradientEnd = Color(0xFFD6E6F2); // pale blue

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}
