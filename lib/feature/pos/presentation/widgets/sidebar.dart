

import 'package:flutter/material.dart';
import 'package:pharmacy_pos/core/widgets/logo_widget.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';

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
            "assets/images/dashboard.png",
      ),
      const NavItem(
        id: "sales",
        label: "Sales POS",
        iconPath:
            "assets/images/cart.png",
      ),
      const NavItem(
        id: "inventory",
        label: "Inventory",
        iconPath:
            "assets/images/inventory1.png",
      ),
      const NavItem(
        id: "invoices",
        label: "Invoices",
        iconPath:
            "assets/images/bill.png",
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
                    child: Image.asset(
                       item.iconPath,
                      color: isActive ? Colors.white : AppColors.primaryBlue,
                      fit: BoxFit.contain,
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

