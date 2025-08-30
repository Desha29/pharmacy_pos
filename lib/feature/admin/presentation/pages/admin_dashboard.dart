// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_pos/core/config/routes/app_router.dart';
import 'package:pharmacy_pos/core/widgets/toast_helper.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';

import '../../../auth/data/helpers/firebase_helper.dart';
import '../../../pos/presentation/widgets/animated_page_transition.dart';
import '../../../pos/presentation/widgets/dashboard_content.dart';
import '../../../pos/presentation/widgets/header.dart';
import '../../../pos/presentation/widgets/sidebar.dart';


// Admin-specific pages
import 'admin_inventory_page.dart';
import 'admin_invoice_page.dart';

import 'settings_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  String _activeNavItem = 'dashboard';
  bool _isSidebarCollapsed = false;
  bool _showMobileSidebar = false;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarSlideAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarAnimationController = AnimationController(
      duration: AnimationConstants.medium,
      vsync: this,
    );

    _sidebarSlideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sidebarAnimationController,
        curve: AnimationConstants.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Container(
            decoration: AppStyles.backgroundGradient,
            child: Row(
              children: [
                // Desktop sidebar
                if (!_isMobile || ResponsiveHelper.isTablet(context))
                  AnimatedContainer(
                    duration: AnimationConstants.medium,
                    curve: AnimationConstants.easeOut,
                    width: ResponsiveHelper.getSidebarWidth(
                      context,
                      _isSidebarCollapsed,
                    ),
                    child: Sidebar(
                      isCollapsed: _isSidebarCollapsed,
                      activeNavItem: _activeNavItem,
                      onNavigate: _setActiveNavItem,
                      onLogout: _handleLogout,
                    ),
                  ),

                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      Header(
                        email: FirebaseHelper.getCurrentUser()?.email ?? "admin@pharmpos.com",
                        activeNavItem: _activeNavItem,
                        onToggleSidebar: _toggleSidebar,
                        isMobile: _isMobile,
                      ),

                      // Content area with page transitions
                      Expanded(
                        child: AnimatedPageTransition(
                          pageKey: _activeNavItem,
                          child: _getActivePage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mobile sidebar overlay and sidebar
          if (_isMobile) ...[
            // Overlay
            if (_showMobileSidebar)
              GestureDetector(
                onTap: _toggleSidebar,
                child: AnimatedContainer(
                  duration: AnimationConstants.fast,
                  color: _showMobileSidebar
                      ? AppColors.overlay
                      : Colors.transparent,
                ),
              ),

            // Mobile sidebar
            AnimatedBuilder(
              animation: _sidebarAnimationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(280 * _sidebarSlideAnimation.value, 0),
                  child: SizedBox(
                    width: 280,
                    height: double.infinity,
                    child: Sidebar(
                      isCollapsed: false,
                      activeNavItem: _activeNavItem,
                      onNavigate: _setActiveNavItem,
                      onLogout: _handleLogout,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    final padding = ResponsiveHelper.getScreenPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder<double>(
      duration: AnimationConstants.slow,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: padding,
              decoration: AppStyles.cardDecoration,
              padding: EdgeInsets.all(isMobile ? 32 : 48),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: AnimationConstants.medium,
                      child: Icon(
                        _getModuleIcon(_activeNavItem),
                        size: isMobile ? 48 : 64,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: isMobile ? 16 : 24),
                    Text(
                      "${_getPageTitle(_activeNavItem)} Module",
                      style: ResponsiveHelper.getResponsiveTextStyle(
                        context,
                        AppStyles.heading1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    Text(
                      "This section is ready for your $_activeNavItem functionality implementation.",
                      style: ResponsiveHelper.getResponsiveTextStyle(
                        context,
                        AppStyles.bodyLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

Widget _getActivePage() {
  switch (_activeNavItem) {
    case 'dashboard':
      return DashboardContent(onNavigate: _setActiveNavItem);

    case 'inventory': // 🔹 instead of reports
      return  AdminInventoryPage();

    case 'invoice': // 🔹 new invoice page
      return const AdminInvoicePage();

    case 'settings':
      return const SettingsPage();

    default:
      return _buildPlaceholderContent();
  }
}


  IconData _getModuleIcon(String navItem) {
    switch (navItem) {
      case 'users':
        return Icons.people;
      case 'reports':
        return Icons.bar_chart;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.dashboard;
    }
  }

  bool get _isMobile => ResponsiveHelper.isMobile(context);

  String _getPageTitle(String navItem) {
    switch (navItem) {
      case 'users':
        return 'Manage Users';
      case 'reports':
        return 'Reports';
      case 'settings':
        return 'Settings';
      default:
        return navItem[0].toUpperCase() + navItem.substring(1);
    }
  }

  void _setActiveNavItem(String item) {
    setState(() {
      _activeNavItem = item;
      if (_isMobile) {
        _showMobileSidebar = false;
        _sidebarAnimationController.reverse();
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      if (_isMobile) {
        _showMobileSidebar = !_showMobileSidebar;
        if (_showMobileSidebar) {
          _sidebarAnimationController.forward();
        } else {
          _sidebarAnimationController.reverse();
        }
      } else {
        _isSidebarCollapsed = !_isSidebarCollapsed;
      }
    });
  }


void _handleLogout() async {
  // Small delay for animation consistency
  await Future.delayed(AnimationConstants.fast);

  _activeNavItem = 'dashboard';
  _isSidebarCollapsed = false;
  _showMobileSidebar = false;
  _sidebarAnimationController.reverse();

  // 🔑 Sign out using FirebaseHelper
  await FirebaseHelper.signOut();

  // Redirect to login
  if (context.mounted) {
    context.go(AppRouter.kLogin);
    motionSnackBarSuccess(context, 'Logout successful');
  }
}
}


