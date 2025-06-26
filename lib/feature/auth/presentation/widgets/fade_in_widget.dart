import 'package:flutter/material.dart';
import '../../../../core/animations/animations.dart';


class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset slideOffset;
  final bool slideAnimation;

  const FadeInWidget({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AnimationConstants.medium,
    this.curve = AnimationConstants.easeOut,
    this.slideOffset = const Offset(0, 0.3),
    this.slideAnimation = true,
  }) : super(key: key);

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = AnimationHelper.createFadeAnimation(
      _controller,
      curve: widget.curve,
    );

    _slideAnimation = AnimationHelper.createSlideAnimation(
      _controller,
      begin: widget.slideOffset,
      curve: widget.curve,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget animatedChild = FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        );

        if (widget.slideAnimation) {
          animatedChild = SlideTransition(
            position: _slideAnimation,
            child: animatedChild,
          );
        }

        return animatedChild;
      },
    );
  }
}
