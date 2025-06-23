import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  void updateEmail(String email) {
    final currentState = state;
    if (currentState is LoginInitial) {
      emit(currentState.copyWith(email: email));
    } else if (currentState is LoginError) {
      emit(LoginInitial(
        email: email,
        password: currentState.password,
     
      ));
    } else if (currentState is LoginValidationError) {
      emit(LoginInitial(
        email: email,
        password: currentState.password,
       
      ));
    }
  }

  void updatePassword(String password) {
    final currentState = state;
    if (currentState is LoginInitial) {
      emit(currentState.copyWith(password: password));
    } else if (currentState is LoginError) {
      emit(LoginInitial(
        email: currentState.email,
        password: password,
       
      ));
    } else if (currentState is LoginValidationError) {
      emit(LoginInitial(
        email: currentState.email,
        password: password,
      
      ));
    }
  }



  void signIn() async {
    final currentState = state;
    String email = '';
    String password = '';
    bool rememberMe = false;

    if (currentState is LoginInitial) {
      email = currentState.email;
      password = currentState.password;
    
    } else if (currentState is LoginError) {
      email = currentState.email;
      password = currentState.password;
     
    } else if (currentState is LoginValidationError) {
      email = currentState.email;
      password = currentState.password;
    
    }

    // Validate inputs
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);

    if (emailError != null || passwordError != null) {
      emit(LoginValidationError(
        email: email,
        password: password,
      
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    // Start loading
    emit(LoginLoading(
      email: email,
      password: password,
      rememberMe: rememberMe,
    ));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate login logic
      if (email.isNotEmpty && password.isNotEmpty) {
        // Simulate successful login
        print('Signing in with: $email, $password');
        emit(LoginSuccess(email: email));
      } else {
        emit(LoginError(
          email: email,
          password: password,
       
          errorMessage: 'Invalid credentials',
        ));
      }
    } catch (e) {
      emit(LoginError(
        email: email,
        password: password,
       
        errorMessage: 'An error occurred during login: ${e.toString()}',
      ));
    }
  }

  void forgotPassword() {
    // Handle forgot password logic
    print('Forgot password clicked');
  }

  void navigateToSignUp() {
    // Handle navigation to sign up
  
   
  }

  void resetToInitial() {
    emit(const LoginInitial());
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
