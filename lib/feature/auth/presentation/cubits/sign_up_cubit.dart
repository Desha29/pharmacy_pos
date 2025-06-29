import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/helpers/firebase_helper.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpInitial());

  




  void signUp(String email, String password, String confirmPassword) async {

    emit(
      SignUpLoading(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    try {
 FirebaseHelper.signUpWithEmailAndPassword(email, password).then((_) {
        emit(SignUpSuccess());
      }).catchError((error) {
        emit(
          SignUpError(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            errorMessage: error.toString(),
          ),
        );
      });
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
