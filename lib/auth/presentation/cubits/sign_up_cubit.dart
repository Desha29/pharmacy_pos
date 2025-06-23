import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpInitial());

  void updateEmail(String email) {
    final currentState = state;
    if (currentState is SignUpInitial) {
      emit(currentState.copyWith(email: email));
    } else if (currentState is SignUpError) {
      emit(
        SignUpInitial(
          email: email,
          password: currentState.password,
          confirmPassword: currentState.confirmPassword,
        ),
      );
    } else if (currentState is SignUpValidationError) {
      emit(
        SignUpInitial(
          email: email,
          password: currentState.password,
          confirmPassword: currentState.confirmPassword,
        ),
      );
    }
  }

  void updatePassword(String password) {
    final currentState = state;
    if (currentState is SignUpInitial) {
      emit(currentState.copyWith(password: password));
    } else if (currentState is SignUpError) {
      emit(SignUpInitial(email: currentState.email, password: password,
        confirmPassword: currentState.confirmPassword,
      ));
    } else if (currentState is SignUpValidationError) {
      emit(
        SignUpInitial(
          email: currentState.email,
          password: password,
          confirmPassword: currentState.confirmPassword,
        ),
      );
    }
  }

  void updateConfirmPassword(String confirmPassword) {
    final currentState = state;
    if (currentState is SignUpInitial) {
      emit(currentState.copyWith(confirmPassword: confirmPassword));
    } else if (currentState is SignUpError) {
      emit(SignUpInitial(email: currentState.email, password:currentState. password,confirmPassword: confirmPassword));
    } else if (currentState is SignUpValidationError) {
      emit(
        SignUpInitial(
          email: currentState.email,
          password: currentState.password,
          confirmPassword: confirmPassword,
        ),
      );
    }
  }

  void signUp() async {
    final currentState = state;
    if (currentState is! SignUpInitial) return;

    final email = currentState.email;
    final password = currentState.password;
    final confirmPassword = currentState.confirmPassword;

    // Validate
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);
    final confirmPasswordError =
        password != confirmPassword ? 'Passwords do not match' : null;

    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(
        SignUpValidationError(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
        ),
      );
      return;
    }

    emit(
      SignUpLoading(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Fake success
      emit(const SignUpSuccess());
    } catch (e) {
      emit(
        SignUpError(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          errorMessage: 'An error occurred: ${e.toString()}',
        ),
      );
    }
  }

  void resetToInitial() {
    emit(const SignUpInitial());
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
