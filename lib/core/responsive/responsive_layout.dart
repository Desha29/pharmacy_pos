import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile &&
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context, int i) =>
      MediaQuery.of(context).size.height;

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  static double getResponsiveCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    if (isMobile(context)) {
      return screenWidth * 0.9;
    } else if (isTablet(context)) {
      return screenWidth * 0.6;
    } else {
      return 500; 
    }
  }
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < ResponsiveBreakpoints.mobile) return 1;
    if (width < ResponsiveBreakpoints.tablet) return 2;
    if (width < ResponsiveBreakpoints.largeDesktop) return 4;
    return 4;
  }
    static double getCardAspectRatio(BuildContext context) {
    if (isMobile(context)) return 2.5;
    if (isTablet(context)) return 1.8;
    return 1.2;
  }
    static TextStyle getResponsiveTextStyle(BuildContext context, TextStyle baseStyle) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenWidth = MediaQuery.of(context).size.width;

    double responsiveScale = 1.0;
    if (screenWidth <ResponsiveBreakpoints.mobile ) {
      responsiveScale = 0.9;
    } else if (screenWidth > ResponsiveBreakpoints.largeDesktop ) {
      responsiveScale = 1.1;
    }

    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize! * responsiveScale * scaleFactor.clamp(0.8, 1.2),
    );
  }
    static double getQuickActionAspectRatio(BuildContext context) {
    if (isMobile(context)) return 4.0;
    if (isTablet(context)) return 3.5;
    return 3.0;
  }
    static int getQuickActionColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < ResponsiveBreakpoints.mobile) return 1;
    if (width < ResponsiveBreakpoints.tablet) return 2;
    if (width < ResponsiveBreakpoints.desktop) return 3;
    return 4;
  }
    static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(24);
  }
    static double getSidebarWidth(BuildContext context, bool isCollapsed) {
    if (isMobile(context)) return 280;
    return isCollapsed ? 80 : 280;
  }
  static double getResponsiveLogoSize(BuildContext context) {
    if (isMobile(context)) {
      return 60;
    } else if (isTablet(context)) {
      return 80;
    } else {
      return 180;
    }
  }

  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    if (isMobile(context)) {
      return baseFontSize * 0.9;
    } else if (isTablet(context)) {
      return baseFontSize;
    } else {
      return baseFontSize * 1.1;
    }
  }

  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) {
      return baseSpacing * 0.8;
    } else if (isTablet(context)) {
      return baseSpacing;
    } else {
      return baseSpacing * 1.2;
    }
  }

  static bool shouldUseHorizontalLayout(BuildContext context) {
    return isDesktop(context) || (isTablet(context) && isLandscape(context));
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,  
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (ResponsiveHelper.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
