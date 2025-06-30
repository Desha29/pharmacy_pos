import 'package:flutter/material.dart';
import 'package:pharmacy_pos/feature/pos/presentation/widgets/connection_status_Indicator.dart';
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
                      Flexible(
                        child: FittedBox(
                          child: Container(
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
                                  "User",
                                  style: AppStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "admin@pharmpos.com",
                                  style: AppStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
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
    final isMobile = widget.isMobile;
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
          // Title & Menu
          Expanded(
            flex: 5,
            child: Row(
              children: [
                if (isMobile)
                  Flexible(
                    child: FittedBox(
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: Material(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: widget.onToggleSidebar,
                            borderRadius: BorderRadius.circular(8),
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(Icons.menu, size: 20, color: AppColors.textSecondary),
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

        
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Wrap(
                  spacing: isMobile ? 12 : 20,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                 
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16,
                            vertical: isMobile ? 6 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ConnectionStatusIndicator()
                        );
                      },
                    ),

                 
                    CompositedTransformTarget(
                      link: _layerLink,
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
                  ],
                ),
              ),
            ),
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
