import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpInitial({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  SignUpInitial copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return SignUpInitial(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [email, password, confirmPassword];
}

class SignUpLoading extends SignUpState {
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpLoading({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword];
}

class SignUpSuccess extends SignUpState {
  final String message;

  const SignUpSuccess({this.message = 'Account created successfully'});

  @override
  List<Object?> get props => [message];
}

class SignUpError extends SignUpState {
  final String email;
  final String password;
  final String confirmPassword;
  final String errorMessage;

  const SignUpError({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [email, password, confirmPassword, errorMessage];
}

class SignUpValidationError extends SignUpState {
  final String email;
  final String password;
  final String confirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  const SignUpValidationError({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        emailError,
        passwordError,
        confirmPasswordError,
      ];
}
