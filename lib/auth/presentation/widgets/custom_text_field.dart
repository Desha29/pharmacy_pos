import 'package:flutter/material.dart';

import '../../../core/utils/animations.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final IconData prefixIcon;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function()? onSubmitted;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    required this.prefixIcon,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  late AnimationController _focusController;
  late AnimationController _shakeController;
  late Animation<double> _borderAnimation;
  late Animation<double> _labelAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    _focusController = AnimationController(
      duration: AnimationConstants.fast,
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _borderAnimation = Tween<double>(
      begin: 2.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: AnimationConstants.easeOut,
    ));

    _labelAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: AnimationConstants.easeOut,
    ));

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      if (_isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });
  }

  void shake() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsivePadding = ResponsiveHelper.getResponsiveSpacing(context, 12);
    final iconSize = ResponsiveHelper.isMobile(context) ? 16.0 : 18.0;
    final borderRadius = ResponsiveHelper.isMobile(context) ? 8.0 : 10.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_focusController, _shakeController]),
      builder: (context, child) {
        return SlideTransition(
          position: _shakeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: ResponsiveHelper.getResponsiveSpacing(context, 8),
                ),
                child: Transform.scale(
                  scale: _labelAnimation.value,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.label,
                    style: AppTextStyles.inputLabel(context).copyWith(
                      color: _isFocused
                          ? AppColors.secondaryBlue
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: AnimationConstants.fast,
                curve: AnimationConstants.easeOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: _isFocused
                        ? AppColors.secondaryBlue
                        : AppColors.borderGray,
                    width: _borderAnimation.value,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppColors.secondaryBlue.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.isPassword ? _obscureText : false,
                  keyboardType: widget.keyboardType,
                  style: AppTextStyles.inputText(context),
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted != null
                      ? (_) => widget.onSubmitted!()
                      : null,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTextStyles.inputText(context).copyWith(
                      color: AppColors.lightGray,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: ResponsiveHelper.isMobile(context) ? 44 : 48,
                      right: widget.isPassword
                          ? (ResponsiveHelper.isMobile(context) ? 48 : 52)
                          : (ResponsiveHelper.isMobile(context) ? 16 : 20),
                      top: responsivePadding,
                      bottom: responsivePadding,
                    ),
                    prefixIcon: AnimatedContainer(
                      duration: AnimationConstants.fast,
                      padding: EdgeInsets.only(
                        left: ResponsiveHelper.isMobile(context) ? 16 : 18,
                        right: ResponsiveHelper.isMobile(context) ? 12 : 14,
                      ),
                      child: Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? AppColors.secondaryBlue
                            : AppColors.lightGray,
                        size: iconSize,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: ResponsiveHelper.isMobile(context) ? 44 : 48,
                      minHeight: iconSize,
                    ),
                    suffixIcon: widget.isPassword
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: ResponsiveHelper.isMobile(context) ? 16 : 18,
                            ),
                            child: AnimatedSwitcher(
                              duration: AnimationConstants.fast,
                              child: IconButton(
                                key: ValueKey(_obscureText),
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: _isFocused
                                      ? AppColors.secondaryBlue
                                      : AppColors.lightGray,
                                  size: iconSize,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: iconSize,
                                  minHeight: iconSize,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
