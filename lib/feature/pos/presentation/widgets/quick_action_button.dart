

import 'package:flutter/material.dart';
import '../../../../core/animations/animations.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/quick_action.dart';


class QuickActionButton extends StatefulWidget {
  final QuickAction action;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.action,
    required this.onTap,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
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
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationConstants.easeOut,
    ));

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

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = isMobile ? 16.0 : 20.0;
    final iconSize = isMobile ? 18.0 : 20.0;
    final spacing = isMobile ? 10.0 : 12.0;

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
              scale: _isPressed ? AnimationConstants.pressScale : _scaleAnimation.value,
              child: AnimatedContainer(
                duration: AnimationConstants.fast,
                decoration: AppStyles.whiteCardDecoration.copyWith(
                  gradient: _isHovered ? AppStyles.primaryGradient.gradient : null,
                  boxShadow: _isHovered
                      ? [AppStyles.hoverShadow]
                      : _isPressed
                          ? [AppStyles.pressedShadow]
                          : null,
                ),
                padding: EdgeInsets.all(padding),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: AnimationConstants.fast,
                      child: SizedBox(
                        width: iconSize,
                        height: iconSize,
                      child: Image.asset(widget.action.iconPath),
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: AnimationConstants.fast,
                        style: ResponsiveHelper.getResponsiveTextStyle(
                          context,
                          AppStyles.bodyLarge.copyWith(
                            color: _isHovered ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        child: Text(widget.action.label),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

