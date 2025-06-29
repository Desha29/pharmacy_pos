import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/helpers/firebase_helper.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());







  void signIn(String email, String password) async {

    // Start loading
    emit(LoginLoading(
      email: email,
      password: password,
     
    ));

    try {
      FirebaseHelper.signInWithEmailAndPassword(email, password).then((_) {
        // Emit success state
        emit(LoginSuccess(email: email, message: 'Login successful'));
      }).catchError((error) {
        // Emit error state
        emit(LoginError(
          email: email,
          password: password,

          errorMessage: error.toString(),
        ));
      });
      // Simulate API call
      // await Future.delayed(const Duration(seconds: 2));

      // // Simulate login logic
      // if (email.isNotEmpty && password.isNotEmpty) {
      //   // Simulate successful login
      //   if (email == "mstfo23mr5@gmail.com" && password == "123456") {
      //     emit(LoginSuccess(email: email, message: 'Login successful'));

      //   }else{
       
      //     emit(LoginError(
      //       email: email,
      //       password: password,
         
      //       errorMessage: 'Invalid credentials',
      //     ));
      //   }
        
     
      // } else {
      //   emit(LoginError(
      //     email: email,
      //     password: password,
       
      //     errorMessage: 'Invalid credentials',
      //   ));
      // }
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
