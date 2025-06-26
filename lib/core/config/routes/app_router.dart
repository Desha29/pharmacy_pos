import 'package:go_router/go_router.dart';
import 'package:pharmacy_pos/feature/dashboard/presentation/pages/dashboard_page.dart';
import 'package:pharmacy_pos/feature/pos/presentation/pages/sales_pos_page.dart';

import '../../../feature/auth/presentation/pages/login_page.dart';
import '../../../feature/auth/presentation/pages/sign_up_page.dart';

abstract class AppRouter {
  static const String kLogin = '/login';
  static const String kSignUp = '/signUp';
  static const String kDashboard = '/dashboard';
  static const String kSalesPos = '/salesPos';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => PharmacyDashboard()),
      GoRoute(path: kSignUp, builder: (context, state) => const SignUpPage()),
      GoRoute(path: kLogin, builder: (context, state) => const LoginPage()),
      GoRoute(
        path: kDashboard,
        builder: (context, state) => const PharmacyDashboard(),
      ),
      GoRoute(
        path: kSalesPos,
        builder: (context, state) => SalesPOSPage(),
      ),
    ],
  );
}
