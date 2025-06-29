import 'package:flutter/material.dart';
import '../../../../core/animations/animations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/stat_item.dart';

class StatCard extends StatefulWidget {
  final StatItem stat;
  final int index;

  const StatCard({super.key, required this.stat, this.index = 0});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationConstants.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AnimationConstants.hoverScale,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AnimationConstants.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails details) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = isMobile ? 14.0 : 20.0;
    final iconSize = isMobile ? 36.0 : 48.0;
    final iconInnerSize = isMobile ? 18.0 : 24.0;

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed
                  ? AnimationConstants.pressScale
                  : _scaleAnimation.value,
              child: AnimatedContainer(
                duration: AnimationConstants.fast,
                padding: EdgeInsets.all(padding),
                decoration: AppStyles.cardDecoration.copyWith(
                  boxShadow: _isHovered
                      ? [AppStyles.hoverShadow]
                      : _isPressed
                          ? [AppStyles.pressedShadow]
                          : [AppStyles.cardShadow],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView( // Handles overflow cases
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: AppStyles.primaryGradient.copyWith(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: iconInnerSize,
                                    height: iconInnerSize,
                                    child: Image.asset(widget.stat.iconPath),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.stat.isPositive
                                        ? AppColors.successBackground
                                        : AppColors.errorBackground,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.stat.change,
                                      style: widget.stat.isPositive
                                          ? AppStyles.changePositive
                                          : AppStyles.changeNegative,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.stat.value,
                              style: AppStyles.statValue.copyWith(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.stat.title,
                              style: AppStyles.bodyLarge.copyWith(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
