import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/animations.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';
import '../cubits/sign_up_cubit.dart';
import '../cubits/sign_up_state.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_logo_section.dart';
import '../widgets/custom_button.dart';
import '../widgets/email_field.dart';
import '../widgets/fade_in_widget.dart';
import '../cubits/login_cubit.dart';
import '../cubits/login_state.dart';
import '../widgets/password_field.dart';
import '../widgets/sign_link.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late AnimationController _backgroundController;
  late AnimationController _errorController;
  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _errorSlideAnimation;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _errorController = AnimationController(
      duration: AnimationConstants.medium,
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _errorSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _errorController,
            curve: AnimationConstants.bounceOut,
          ),
        );

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _backgroundController.dispose();
    _errorController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorAnimation() {
    _errorController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _errorController.reverse();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      AppColors.gradientStart,
                      AppColors.gradientEnd,
                      _backgroundAnimation.value * 0.3,
                    )!,
                    Color.lerp(
                      AppColors.gradientEnd,
                      AppColors.gradientStart,
                      _backgroundAnimation.value * 0.3,
                    )!,
                  ],
                ),
              ),
              child: SafeArea(
                child: ResponsiveWidget(
                  mobile: _buildMobileLayout(),
                  tablet: _buildTabletLayout(),
                  desktop: _buildDesktopLayout(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              32,
        ),
        child: _buildMainContent(),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getResponsiveCardWidth(context),
            minHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: ResponsiveHelper.isLandscape(context)
              ? _buildHorizontalLayout()
              : _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200, minHeight: 600),
          child: _buildHorizontalLayout(),
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: _handleStateChanges,
      child: Row(
        children: [
          // Left side - Branding
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    child: AuthLogoSection(),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 20),
                  ),
                 
                  FadeInWidget(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      'Create an account to start managing your pharmacy\'s sales, invoices, and inventory — even while offline.',
                      style: AppTextStyles.bodyText(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side - Login form
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInWidget(
                    delay: const Duration(milliseconds: 400),
                    child: _buildLoginForm(),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 15),
                  ),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 800),
                    child: AuthFooter(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: _handleStateChanges,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo and branding section
          FadeInWidget(
            delay: const Duration(milliseconds: 200),
            child: AuthLogoSection(),
          ),

          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 40)),

          // Login form
          FadeInWidget(
            delay: const Duration(milliseconds: 400),
            child: _buildLoginForm(),
          ),

          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 40)),

          // Footer
          FadeInWidget(
            delay: const Duration(milliseconds: 600),
            child: AuthFooter(),
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, SignUpState state) {
    if (state is SignUpSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Account created successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: ResponsiveHelper.getResponsivePadding(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else if (state is SignUpError) {
      _showErrorAnimation();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(state.errorMessage)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: ResponsiveHelper.getResponsivePadding(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else if (state is SignUpValidationError) {
      if (state.emailError != null) {}
      if (state.passwordError != null) {}
      if (state.confirmPasswordError != null) {}
    }
  }

  Widget _buildLoginForm() {
    final cardWidth = ResponsiveHelper.getResponsiveCardWidth(context);
    final cardPadding = ResponsiveHelper.isMobile(context) ? 24.0 : 40.0;
    final borderRadius = ResponsiveHelper.isMobile(context) ? 12.0 : 16.0;

    return AnimatedContainer(
      duration: AnimationConstants.medium,
      width: cardWidth,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveHelper.isMobile(context) ? 16 : 32,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      padding: EdgeInsets.all(cardPadding),
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          _updateControllers(state);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Welcome text
              Center(
                child: Column(
                  children: [
                    FadeInWidget(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'Create Account',
                        style: AppTextStyles.welcomeTitle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(context, 8),
                    ),
                    FadeInWidget(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        'Sign up to get started',
                        style: AppTextStyles.welcomeSubtitle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 32),
              ),

              // Email field
              FadeInWidget(
                delay: const Duration(milliseconds: 600),
                child: _buildEmailField(context, state),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),

              // Password field
              FadeInWidget(
                delay: const Duration(milliseconds: 700),
                child: _buildPasswordField(context, state),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 24),
              ),

              // Sign in button
              FadeInWidget(
                delay: const Duration(milliseconds: 900),
                child: _buildSignUpButton(context, state),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 24),
              ),

              // Sign up link
              FadeInWidget(
                delay: const Duration(milliseconds: 1000),
                child: SignLink(
                  onTap: () {
                    context.push(AppRouter.kLogin);
                  },
                  label: "Already have an account?",
                  linkText: "Log in",
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateControllers(SignUpState state) {
    if (state is SignUpInitial ||
        state is SignUpError ||
        state is SignUpValidationError) {
      final email = state is SignUpInitial
          ? state.email
          : state is SignUpError
          ? state.email
          : (state as SignUpValidationError).email;
      final password = state is SignUpInitial
          ? state.password
          : state is SignUpError
          ? state.password
          : (state as SignUpValidationError).password;
      final confirmPassword = state is SignUpInitial
          ? state.confirmPassword
          : state is SignUpError
          ? state.confirmPassword
          : (state as SignUpValidationError).confirmPassword;

      if (_emailController.text != email) {
        _emailController.text = email;
      }
      if (_passwordController.text != password) {
        _passwordController.text = password;
      }
      if (_confirmPasswordController.text != confirmPassword) {
        _confirmPasswordController.text = confirmPassword;
      }
    }
  }

  Widget _buildEmailField(BuildContext context, SignUpState state) {
    String? errorText;
    if (state is SignUpValidationError) {
      errorText = state.emailError;
    }

    return EmailField(
      controller: _emailController,
      onChanged: (value) => context.read<SignUpCubit>().updateEmail(value),
      onSubmitted: () => context.read<SignUpCubit>().signUp(),
      errorSlideAnimation: _errorSlideAnimation,
      errorText: errorText,
    );
  }

  Widget _buildPasswordField(BuildContext context, SignUpState state) {
    String? passwordError;
    String? confirmPasswordError;

    if (state is SignUpValidationError) {
      passwordError = state.passwordError;
      confirmPasswordError = state.confirmPasswordError;
    }

    return Column(
      children: [
        PasswordField(
          label: 'Password',
          controller: _passwordController,
          onChanged: (value) =>
              context.read<SignUpCubit>().updatePassword(value),
          onSubmitted: context.read<SignUpCubit>().signUp,
          errorText: passwordError,
          errorSlideAnimation: _errorSlideAnimation,
        ),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 20)),
        PasswordField(
          label: 'Confirm Password',
          placeholder: 'Re-enter your password',
          controller: _confirmPasswordController,
          onChanged: (value) =>
              context.read<SignUpCubit>().updateConfirmPassword(value),
          onSubmitted: context.read<SignUpCubit>().signUp,
          errorText: confirmPasswordError,
          errorSlideAnimation: _errorSlideAnimation,
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context, SignUpState state) {
    final isLoading = state is SignUpLoading;

    return CustomButton(
      text: 'Sign Up',
      onPressed: () => context.read<SignUpCubit>().signUp(),
      isLoading: isLoading,
    );
  }
}
