import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  final String email;
  final String password;


  const LoginInitial({
    this.email = '',
    this.password = '',
   
  });

  LoginInitial copyWith({
    String? email,
    String? password,
    bool? rememberMe,
  }) {
    return LoginInitial(
      email: email ?? this.email,
      password: password ?? this.password,
   
    );
  }

  @override
  List<Object?> get props => [email, password];
}

class LoginLoading extends LoginState {
  final String email;
  final String password;


  const LoginLoading({
    required this.email,
    required this.password,
  
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginSuccess extends LoginState {
  final String email;
  final String message;

  const LoginSuccess({
    required this.email,
    this.message = 'Login successful',
  });

  @override
  List<Object?> get props => [email, message];
}

class LoginError extends LoginState {
  final String email;
  final String password;
  
  final String errorMessage;

  const LoginError({
    required this.email,
    required this.password,
  
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [email, password,  errorMessage];
}

class LoginValidationError extends LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;

  const LoginValidationError({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
  });

  @override
  List<Object?> get props => [email, password, emailError, passwordError];
}
