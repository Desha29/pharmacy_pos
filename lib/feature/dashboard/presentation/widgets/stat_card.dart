import 'dart:math' as math;
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

class _StatCardState extends State<StatCard> with SingleTickerProviderStateMixin {
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

  void _onTapDown(TapDownDetails details) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails details) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = isMobile ? 16.0 : 24.0;
    final iconSize = isMobile ? 40.0 : 48.0;
    final iconInnerSize = isMobile ? 20.0 : 24.0;

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
                decoration: AppStyles.cardDecoration.copyWith(
                  boxShadow: _isHovered
                      ? [AppStyles.hoverShadow]
                      : _isPressed
                          ? [AppStyles.pressedShadow]
                          : [AppStyles.cardShadow],
                ),
                padding: EdgeInsets.all(padding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          child: CustomPaint(
                                            painter: IconPainter(widget.stat.iconPath, Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 6 : 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.stat.isPositive
                                            ? AppColors.successBackground
                                            : AppColors.errorBackground,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        widget.stat.change,
                                        style: ResponsiveHelper.getResponsiveTextStyle(
                                          context,
                                          widget.stat.isPositive
                                              ? AppStyles.changePositive
                                              : AppStyles.changeNegative,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: isMobile ? 12 : 16),
                              TweenAnimationBuilder<double>(
                                duration: AnimationConstants.slow,
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: Text(
                                        widget.stat.value,
                                        style: ResponsiveHelper.getResponsiveTextStyle(
                                          context,
                                          AppStyles.statValue,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: isMobile ? 6 : 8),
                              TweenAnimationBuilder<double>(
                                duration: AnimationConstants.slow,
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 10 * (1 - value)),
                                      child: Text(
                                        widget.stat.title,
                                        style: ResponsiveHelper.getResponsiveTextStyle(
                                          context,
                                          AppStyles.bodyLarge,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
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

class IconPainter extends CustomPainter {
  final String pathData;
  final Color color;

  IconPainter(this.pathData, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (pathData.contains('M12 2L13.09')) {
      _drawStar(canvas, size, paint);
    } else if (pathData.contains('M19 3H5C3.9')) {
      _drawRectangle(canvas, size, paint);
    } else if (pathData.contains('M16 4C18.2')) {
      _drawPerson(canvas, size, paint);
    } else {
      _drawRectangle(canvas, size, paint);
    }
  }

  void _drawStar(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi) / 5 - math.pi / 2;
      final x = center.dx + radius * (i % 2 == 0 ? 1.0 : 0.5) * math.cos(angle);
      final y = center.dy + radius * (i % 2 == 0 ? 1.0 : 0.5) * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawRectangle(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint);
  }

  void _drawPerson(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.35),
      size.width * 0.15,
      paint,
    );
    final bodyRect = Rect.fromLTWH(
      size.width * 0.3,
      size.height * 0.55,
      size.width * 0.4,
      size.height * 0.3,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(8)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
