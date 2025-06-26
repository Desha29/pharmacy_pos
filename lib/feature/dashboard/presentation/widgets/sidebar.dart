import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pharmacy_pos/core/widgets/logo_widget.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/icon_painter.dart';
import '../../data/models/nav_item.dart';
import 'animated_page_transition.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final String activeNavItem;
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.isCollapsed,
    required this.activeNavItem,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final sidebarPadding = isMobile ? 16.0 : 20.0;
    final logoSize = ResponsiveHelper.getResponsiveLogoSize(context);

    final navItems = [
      const NavItem(
        id: "dashboard",
        label: "Dashboard",
        iconPath:
            "M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z",
      ),
      const NavItem(
        id: "sales",
        label: "Sales POS",
        iconPath:
            "M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20C20.55 4 21 4.45 21 5S20.55 6 20 6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4C3.45 6 3 5.55 3 5S3.45 4 4 4H7ZM9 3V4H15V3H9ZM7 6V19H17V6H7Z",
      ),
      const NavItem(
        id: "inventory",
        label: "Inventory",
        iconPath:
            "M19 3H5C3.9 3 3 3.9 3 5V19C3 20.1 3.9 21 5 21H19C20.1 21 21 20.1 21 19V5C21 3.9 20.1 3 19 3ZM19 19H5V5H19V19ZM17 8.5L13.5 12L17 15.5L15.5 17L12 13.5L8.5 17L7 15.5L10.5 12L7 8.5L8.5 7L12 10.5L15.5 7L17 8.5Z",
      ),
      const NavItem(
        id: "invoices",
        label: "Invoices",
        iconPath:
            "M14 2H6C4.9 2 4 2.9 4 4V20C4 21.1 4.89 22 5.99 22H18C19.1 22 20 21.1 20 20V8L14 2ZM18 20H6V4H13V9H18V20Z",
      ),
      const NavItem(
        id: "sync",
        label: "Cloud Sync",
        iconPath:
            "M19.35 10.04C18.67 6.59 15.64 4 12 4C9.11 4 6.6 5.64 5.35 8.04C2.34 8.36 0 10.91 0 14C0 17.31 2.69 20 6 20H19C21.76 20 24 17.76 24 15C24 12.36 21.95 10.22 19.35 10.04ZM17 13L12 18L7 13H10V9H14V13H17Z",
      ),
      const NavItem(
        id: "settings",
        label: "Settings",
        iconPath:
            "M19.14 12.94C19.18 12.64 19.2 12.33 19.2 12S19.18 11.36 19.14 11.06L21.16 9.48C21.34 9.34 21.39 9.07 21.28 8.87L19.36 5.55C19.24 5.33 18.99 5.26 18.77 5.33L16.38 6.29C15.88 5.91 15.35 5.59 14.76 5.35L14.4 2.81C14.36 2.57 14.16 2.4 13.92 2.4H10.08C9.84 2.4 9.64 2.57 9.6 2.81L9.24 5.35C8.65 5.59 8.12 5.92 7.62 6.29L5.23 5.33C5.01 5.26 4.76 5.33 4.64 5.55L2.72 8.87C2.61 9.07 2.66 9.34 2.84 9.48L4.86 11.06C4.82 11.36 4.8 11.67 4.8 12S4.82 12.64 4.86 12.94L2.84 14.52C2.66 14.66 2.61 14.93 2.72 15.13L4.64 18.45C4.76 18.67 5.01 18.74 5.23 18.67L7.62 17.71C8.12 18.08 8.65 18.41 9.24 18.65L9.6 21.19C9.64 21.43 9.84 21.6 10.08 21.6H13.92C14.16 21.6 14.36 21.43 14.4 21.19L14.76 18.65C15.35 18.41 15.88 18.08 16.38 17.71L18.77 18.67C18.99 18.74 19.24 18.67 19.36 18.45L21.28 15.13C21.39 14.93 21.34 14.66 21.16 14.52L19.14 12.94ZM12 15.6C10.02 15.6 8.4 13.98 8.4 12S10.02 8.4 12 8.4S15.6 10.02 15.6 12S13.98 15.6 12 15.6Z",
      ),
    ];

    return AnimatedContainer(
      duration: AnimationConstants.medium,
      curve: AnimationConstants.easeOut,
      width: ResponsiveHelper.getSidebarWidth(context, isCollapsed),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(right: BorderSide(color: AppColors.border)),
        boxShadow: [AppStyles.cardShadow],
      ),
      child: Column(
        children: [
          // Header with Animation
          AnimatedContainer(
            duration: AnimationConstants.medium,
            padding: EdgeInsets.all(sidebarPadding),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  duration: AnimationConstants.medium,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: LogoWidget(size: logoSize * 0.3),
                    );
                  },
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedOpacity(
                      duration: AnimationConstants.fast,
                      opacity: isCollapsed ? 0.0 : 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PharmaPOS",
                            style: ResponsiveHelper.getResponsiveTextStyle(
                              context,
                              AppStyles.heading2,
                            ),
                          ),
                          Text(
                            "Pharmacy Management",
                            style: ResponsiveHelper.getResponsiveTextStyle(
                              context,
                              AppStyles.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation Items with Staggered Animation
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: sidebarPadding),
              child: StaggeredAnimationWrapper(
                delay: const Duration(milliseconds: 50),
                children: navItems
                    .map((item) => _buildNavItem(context, item))
                    .toList(),
              ),
            ),
          ),

          // Logout Button with Animation
          TweenAnimationBuilder<double>(
            duration: AnimationConstants.slow,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: sidebarPadding),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: _buildLogoutButton(context),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item) {
    final isActive = activeNavItem == item.id;
    final isMobile = ResponsiveHelper.isMobile(context);
    final horizontalPadding = isCollapsed
        ? (isMobile ? 16.0 : 20.0)
        : (isMobile ? 20.0 : 24.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onNavigate(item.id),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: AnimationConstants.fast,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 0 : 16,
              vertical: isMobile ? 14 : 16,
            ),
            decoration: isActive
                ? AppStyles.primaryGradient.copyWith(
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: AnimationConstants.fast,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CustomPaint(
                      painter: IconPainter(
                        item.iconPath,
                        isActive ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: AnimationConstants.fast,
                      style: ResponsiveHelper.getResponsiveTextStyle(
                        context,
                        AppStyles.bodyMedium.copyWith(
                          color: isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                      child: Text(item.label),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final horizontalPadding = isCollapsed
        ? (isMobile ? 16.0 : 20.0)
        : (isMobile ? 20.0 : 24.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onLogout,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: AnimationConstants.fast,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 0 : 16,
              vertical: isMobile ? 14 : 16,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                const AnimatedSwitcher(
                  duration: AnimationConstants.fast,
                  child: Icon(Icons.logout, size: 20, color: AppColors.logout),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: AnimationConstants.fast,
                      style: ResponsiveHelper.getResponsiveTextStyle(
                        context,
                        AppStyles.bodyMedium.copyWith(color: AppColors.logout),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

