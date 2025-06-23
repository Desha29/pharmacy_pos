import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/animations.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/text_styles.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_logo_section.dart';
import '../widgets/custom_button.dart';
import '../widgets/email_field.dart';
import '../widgets/fade_in_widget.dart';
import '../cubits/login_cubit.dart';
import '../cubits/login_state.dart';
import '../widgets/password_field.dart';
import '../widgets/sign_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      create: (context) => LoginCubit(),
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
    return BlocListener<LoginCubit, LoginState>(
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
                    height: ResponsiveHelper.getResponsiveSpacing(context, 40),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 8),
                  ),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      'Welcome to your pharmacy\'s POS system. Sign in to manage sales, invoices, and inventory—online or offline.',
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
                    height: ResponsiveHelper.getResponsiveSpacing(context, 20),
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
    return BlocListener<LoginCubit, LoginState>(
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

  void _handleStateChanges(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(state.message),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: ResponsiveHelper.getResponsivePadding(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else if (state is LoginError) {
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
    } else if (state is LoginValidationError) {
      if (state.emailError != null) {}
      if (state.passwordError != null) {}
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
      child: BlocBuilder<LoginCubit, LoginState>(
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
                        'Welcome Back',
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
                        'Sign in to your account to continue',
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

              // Remember me and forgot password
              FadeInWidget(
                delay: const Duration(milliseconds: 800),
                child: _buildRememberMeSection(context, state),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 24),
              ),

              // Sign in button
              FadeInWidget(
                delay: const Duration(milliseconds: 900),
                child: _buildSignInButton(context, state),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 24),
              ),

              // Sign up link
              FadeInWidget(
                delay: const Duration(milliseconds: 1000),
                child: SignLink(
                  onTap: () {
                    context.push(AppRouter.kSignUp);
                  },
                  label: "Don't have an account?",
                  linkText: "Sign up here",
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateControllers(LoginState state) {
    if (state is LoginInitial ||
        state is LoginError ||
        state is LoginValidationError) {
      final email = state is LoginInitial
          ? state.email
          : state is LoginError
          ? state.email
          : (state as LoginValidationError).email;
      final password = state is LoginInitial
          ? state.password
          : state is LoginError
          ? state.password
          : (state as LoginValidationError).password;

      if (_emailController.text != email) {
        _emailController.text = email;
      }
      if (_passwordController.text != password) {
        _passwordController.text = password;
      }
    }
  }

  Widget _buildEmailField(BuildContext context, LoginState state) {
    String? errorText;
    if (state is LoginValidationError) {
      errorText = state.emailError;
    }

    return EmailField(
      controller: _emailController,
      onChanged: (value) => context.read<LoginCubit>().updateEmail(value),
      onSubmitted: () => context.read<LoginCubit>().signIn(),
      errorSlideAnimation: _errorSlideAnimation,
      errorText: errorText,
    );
  }

  Widget _buildPasswordField(BuildContext context, LoginState state) {
    String? errorText;
    if (state is LoginValidationError) {
      errorText = state.passwordError;
    }

    return PasswordField(
      label: 'Password',
      controller: _passwordController,
      onChanged: (value) => context.read<LoginCubit>().updatePassword(value),
      onSubmitted: context.read<LoginCubit>().signIn,
      errorText: errorText,

      errorSlideAnimation: _errorSlideAnimation,
    );
  }

  Widget _buildRememberMeSection(BuildContext context, LoginState state) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => context.read<LoginCubit>().forgotPassword(),
        child: AnimatedDefaultTextStyle(
          duration: AnimationConstants.fast,
          style: AppTextStyles.linkText(context),
          child: const Text('Forgot password?'),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, LoginState state) {
    final isLoading = state is LoginLoading;

    return CustomButton(
      text: 'Sign In',
      onPressed: () => context.read<LoginCubit>().signIn(),
      isLoading: isLoading,
    );
  }
}
