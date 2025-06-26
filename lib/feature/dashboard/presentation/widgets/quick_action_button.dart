import 'dart:math' as math;

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
                        child: CustomPaint(
                          painter: IconPainter(
                            widget.action.iconPath,
                            _isHovered ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
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

class IconPainter extends CustomPainter {
  final String pathData;
  final Color color;

  IconPainter(this.pathData, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Simplified icon drawing based on path data
    if (pathData.contains('M7 4V2C7 1.45')) {
      // Shopping bag icon for New Sale
      _drawShoppingBag(canvas, size, paint);
    } else if (pathData.contains('M19 13H13V19H11V13H5V11H11V5H13V11H19V13Z')) {
      // Plus icon for Add Inventory
      _drawPlus(canvas, size, paint);
    } else if (pathData.contains('M14 2H6C4.9')) {
      // Document icon for Generate Invoice
      _drawDocument(canvas, size, paint);
    } else if (pathData.contains('M12 4V1L8 5L12 9V6C15.31')) {
      // Sync icon for Sync Data
      _drawSync(canvas, size, paint);
    } else {
      // Default rectangle
      _drawRectangle(canvas, size, paint);
    }
  }

  void _drawShoppingBag(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );

    // Handle
    final handlePath = Path();
    handlePath.moveTo(size.width * 0.35, size.height * 0.3);
    handlePath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.65, size.height * 0.3,
    );

    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(handlePath, handlePaint);
  }

  void _drawPlus(Canvas canvas, Size size, Paint paint) {
    final strokeWidth = size.width * 0.15;

    // Horizontal line
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.5 - strokeWidth / 2,
        size.width * 0.6,
        strokeWidth,
      ),
      paint,
    );

    // Vertical line
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5 - strokeWidth / 2,
        size.height * 0.2,
        strokeWidth,
        size.width * 0.6,
      ),
      paint,
    );
  }

  void _drawDocument(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );

    // Corner fold
    final foldPath = Path();
    foldPath.moveTo(size.width * 0.6, size.height * 0.1);
    foldPath.lineTo(size.width * 0.75, size.height * 0.25);
    foldPath.lineTo(size.width * 0.6, size.height * 0.25);
    foldPath.close();
    canvas.drawPath(foldPath, paint);
  }

  void _drawSync(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    final path = Path();
    path.addArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 1.5,
    );

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Arrow
    final arrowPath = Path();
    arrowPath.moveTo(center.dx + radius * 0.7, center.dy - radius * 0.7);
    arrowPath.lineTo(center.dx + radius, center.dy - radius * 0.3);
    arrowPath.lineTo(center.dx + radius * 0.7, center.dy);
    canvas.drawPath(arrowPath, strokePaint);
  }

  void _drawRectangle(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

