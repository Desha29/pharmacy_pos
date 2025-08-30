import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/helpers/firebase_helper.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());


  void signIn(String email, String password) async {
    emit(LoginLoading(email: email));

    try {

      if (email == "admin@pharmpos.com" && password == "admin123") {
   
        await FirebaseHelper.signInWithEmailAndPassword(email, password);

        emit(LoginSuccess(
          email: email,
          message: 'Admin login successful',
          isAdmin: true,
        ));
        return;
      }

      // ----------------- HARDCODED DEMO USER -----------------
      if (email == "user@pharmpos.com" && password == "123456") {
        await FirebaseHelper.signInWithEmailAndPassword(email, password);

        emit(LoginSuccess(
          email: email,
          message: 'Demo user login successful',
          isAdmin: false,
        ));
        return;
      }

      // ----------------- NORMAL FIREBASE LOGIN -----------------
      await FirebaseHelper.signInWithEmailAndPassword(email, password);

     
      emit(LoginSuccess(
        email: email,
        message: 'Login successful',
        isAdmin: false,
      ));
    } catch (e) {
      emit(LoginError(
        email: email,
        password: password,
        errorMessage: e.toString(),
      ));
    }
  }

 
  void forgotPassword(String email) async {
    emit(LoginLoading(email: email));

    try {
      await FirebaseHelper.sendPasswordReset(email);
      emit(LoginSuccess(
        email: email,
        message: 'Password reset email sent. Check your inbox!',
      ));
    } catch (e) {
      emit(LoginError(
        email: email,
        password: '',
        errorMessage: e.toString(),
      ));
    }
  }

 
  void resetToInitial() {
    emit(const LoginInitial());
  }
}
