import 'package:flutter/material.dart';
import 'colors.dart';
import 'responsive.dart';

class AppTextStyles {
  static const String fontFamily = 'Montserrat'; // Matches logo

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
