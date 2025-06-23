import 'package:go_router/go_router.dart';

import '../../auth/presentation/screens/login_screen.dart';
import '../../auth/presentation/screens/sign_up_screen.dart';


abstract class AppRouter {
  static const String kLogin = '/login';
  static const String kSignUp = '/signUp';
  static const String kHomePage = '/homepage';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => LoginScreen()),
      GoRoute(path: kSignUp, builder: (context, state) => const SignUpScreen()),
      GoRoute(path: kLogin, builder: (context, state) => const LoginScreen()),
    ],
  );
}
