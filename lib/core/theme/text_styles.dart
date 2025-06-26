// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../responsive/responsive_layout.dart';

class AppStyles {

  static const String fontFamily = 'Montserrat'; // Matches logo
 static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle statValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle changePositive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  static const TextStyle changeNegative = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static BoxDecoration primaryGradient = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primaryBlue, AppColors.primaryGradientEnd],
    ),
  );

  static BoxDecoration backgroundGradient = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.background, AppColors.backgroundGradientEnd],
    ),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
  );

  static BoxDecoration whiteCardDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(2, 0),
  );

  static BoxShadow elevatedShadow = BoxShadow(
    color: AppColors.primaryBlue.withOpacity(0.1),
    blurRadius: 25,
    offset: const Offset(0, 8),
  );

  static BoxShadow hoverShadow = BoxShadow(
    color: AppColors.primaryBlue.withOpacity(0.15),
    blurRadius: 30,
    offset: const Offset(0, 12),
  );

  static BoxShadow pressedShadow = BoxShadow(
  
    color: AppColors.primaryBlue.withOpacity(0.08),
    blurRadius: 15,
    offset: const Offset(0, 4),
  );
  static TextStyle logoTitle(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 28),
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
    letterSpacing: 1.0,
    fontFamily: fontFamily,
  );

  static TextStyle logoSubtitle(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
    color: AppColors.secondaryBlue,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  static TextStyle welcomeTitle(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
    fontFamily: fontFamily,
  );

  static TextStyle welcomeSubtitle(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    color: AppColors.textGray,
    fontFamily: fontFamily,
  );

  static TextStyle inputLabel(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
    fontFamily: fontFamily,
  );

  static TextStyle inputText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    fontFamily: fontFamily,
  );

  static TextStyle linkText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    color: AppColors.secondaryBlue,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  static TextStyle checkboxText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    color: AppColors.primaryBlue,
    fontFamily: fontFamily,
  );

  static TextStyle footerText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
    color: AppColors.lightGray,
    fontFamily: fontFamily,
  );

  static TextStyle bodyText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
    color: AppColors.textGray,
    fontFamily: fontFamily,
  );

  static TextStyle errorText(BuildContext context) => TextStyle(
    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
    color: Colors.red,
    fontFamily: fontFamily,
  );
}
