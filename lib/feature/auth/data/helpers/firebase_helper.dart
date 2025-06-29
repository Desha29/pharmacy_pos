import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/firebase/firebase_services.dart';

class FirebaseHelper {
  // Authentication
  User? get currentUser => FirebaseServices.auth.currentUser;
  bool get isSignedIn => currentUser != null;

  static Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseServices.auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('An error occurred while signing in: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  static Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseServices.auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else {
        throw Exception('An error occurred while signing up: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseServices.auth.signOut();
  }
}
