import 'package:flutter/material.dart';

import '../../../../core/animations/animations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';

class Header extends StatefulWidget {
  final String activeNavItem;
  final VoidCallback onToggleSidebar;
  final bool isMobile;

  const Header({
    super.key,
    required this.activeNavItem,
    required this.onToggleSidebar,
    required this.isMobile,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  bool _showUserMenu = false;
  OverlayEntry? _overlayEntry;
  late AnimationController _menuAnimationController;
  late Animation<double> _menuScaleAnimation;
  late Animation<double> _menuOpacityAnimation;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(
      duration: AnimationConstants.fast,
      vsync: this,
    );

    _menuScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _menuAnimationController,
        curve: AnimationConstants.easeOut,
      ),
    );

    _menuOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _menuAnimationController,
        curve: AnimationConstants.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlayMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.isMobile ? 180 : 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(-140, 50),
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _menuOpacityAnimation,
              child: ScaleTransition(
                scale: _menuScaleAnimation,
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admin User",
                              style: ResponsiveHelper.getResponsiveTextStyle(
                                context,
                                AppStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "admin@pharmpos.com",
                              style: ResponsiveHelper.getResponsiveTextStyle(
                                context,
                                AppStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children:
                              [
                                    "Profile Settings",
                                    "Account Preferences",
                                    "Help & Support",
                                  ]
                                  .map(
                                    (item) => Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () =>
                                            _toggleUserMenu(forceClose: true),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: widget.isMobile
                                                ? 12
                                                : 16,
                                            vertical: widget.isMobile ? 10 : 12,
                                          ),
                                          child: Text(
                                            item,
                                            style:
                                                ResponsiveHelper.getResponsiveTextStyle(
                                                  context,
                                                  AppStyles.bodySmall.copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _menuAnimationController.forward();
  }

  void _removeOverlay() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry?.remove();
    }
  }

  void _toggleUserMenu({bool? forceClose}) {
    final shouldShow = forceClose == true ? false : !_showUserMenu;
    setState(() {
      _showUserMenu = shouldShow;
      if (_showUserMenu) {
        _showOverlayMenu();
      } else {
        _menuAnimationController.reverse();
        _removeOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final horizontalPadding = isMobile ? 16.0 : 24.0;
    final verticalPadding = isMobile ? 12.0 : 16.0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.isMobile)
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Material(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: widget.onToggleSidebar,
                          borderRadius: BorderRadius.circular(8),
                          child: AnimatedContainer(
                            duration: AnimationConstants.fast,
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.menu,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: AnimatedSwitcher(
                    duration: AnimationConstants.medium,
                    child: Text(
                      _getPageTitle(widget.activeNavItem),
                      key: ValueKey(widget.activeNavItem),
                      style: ResponsiveHelper.getResponsiveTextStyle(
                        context,
                        AppStyles.heading1,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: isMobile ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success.withOpacity(
                                      0.5 * value,
                                    ),
                                    blurRadius: 4 * value,
                                    spreadRadius: 2 * value,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(child: SizedBox(width: isMobile ? 6 : 8)),
                          Flexible(
                            child: Text(
                              "Online",
                              style: ResponsiveHelper.getResponsiveTextStyle(
                                context,
                                AppStyles.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Flexible(child: SizedBox(width: isMobile ? 12 : 16)),
              Flexible(
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleUserMenu,
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: AnimationConstants.fast,
                        width: 40,
                        height: 40,
                        decoration: AppStyles.primaryGradient.copyWith(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "A",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPageTitle(String navItem) {
    switch (navItem) {
      case 'sales':
        return 'Sales POS';
      case 'sync':
        return 'Cloud Sync';
      default:
        return navItem[0].toUpperCase() + navItem.substring(1);
    }
  }
}
