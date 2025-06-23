import 'package:flutter/material.dart';

import '../../../core/utils/animations.dart' show AnimationConstants;
import '../../../core/utils/colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';


class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {

  late AnimationController _pressController;
  late AnimationController _loadingController;
  late AnimationController _rippleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _loadingRotation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: AnimationConstants.fast,
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: AnimationConstants.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: AnimationConstants.easeOut,
    ));

    _loadingRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingController);

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _loadingController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _loadingController.stop();
      _loadingController.reset();
    }
  }

  void _handleTapDown() {
    _pressController.forward();
    _rippleController.forward();
  }

  void _handleTapUp() {
    _pressController.reverse();
    _rippleController.reset();
  }

  void _handleTapCancel() {
    _pressController.reverse();
    _rippleController.reset();
  }

  @override
  void dispose() {
    _pressController.dispose();
    _loadingController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsivePadding = ResponsiveHelper.getResponsiveSpacing(context, 14);
    final borderRadius = ResponsiveHelper.isMobile(context) ? 8.0 : 10.0;
    final loadingSize = ResponsiveHelper.isMobile(context) ? 20.0 : 22.0;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _pressController,
        _loadingController,
        _rippleController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: _elevationAnimation.value * 2,
                  offset: Offset(0, _elevationAnimation.value),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main button
                AnimatedContainer(
                  duration: AnimationConstants.fast,
                  padding: EdgeInsets.symmetric(vertical: responsivePadding),
                  decoration: BoxDecoration(
                    color: widget.isLoading
                        ? AppColors.secondaryBlueDark  .withOpacity(0.8)
                        : AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.isLoading ? null : widget.onPressed,
                      onTapDown: (_) => _handleTapDown(),
                      onTapUp: (_) => _handleTapUp(),
                      onTapCancel: _handleTapCancel,
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: AnimationConstants.medium,
                          child: widget.isLoading
                              ? RotationTransition(
                                  turns: _loadingRotation,
                                  child: SizedBox(
                                    width: loadingSize,
                                    height: loadingSize,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  widget.text,
                                  key: ValueKey(widget.text),
                                  style: AppTextStyles.buttonText(context),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Ripple effect
                if (_rippleAnimation.value > 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: Colors.white.withOpacity(
                          0.3 * (1 - _rippleAnimation.value),
                        ),
                      ),
                      transform: Matrix4.identity()
                        ..scale(_rippleAnimation.value),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
