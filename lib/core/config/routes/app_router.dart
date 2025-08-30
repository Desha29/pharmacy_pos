import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../feature/auth/presentation/pages/login_page.dart';
import '../../../feature/auth/presentation/pages/sign_up_page.dart';
import '../../../feature/pos/presentation/pages/dashboard_page.dart';
import '../../../feature/pos/presentation/pages/sales_pos_page.dart';
import '../../../feature/admin/presentation/pages/admin_dashboard.dart';
import '../../../feature/admin/presentation/pages/admin_inventory_page.dart';

abstract class AppRouter {
  static const String kLogin = '/login';
  static const String kSignUp = '/signUp';
  static const String kDashboard = '/dashboard';
  static const String kSalesPos = '/salesPos';
  static const String kAdminDashboard = '/adminDashboard';
  static const String kAdminInventory = '/adminInventory';

  static final router = GoRouter(
    initialLocation: kLogin,

   
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    routes: [
      GoRoute(path: kLogin, builder: (context, state) => const LoginPage()),
      GoRoute(path: kSignUp, builder: (context, state) => const SignUpPage()),
      GoRoute(path: kDashboard, builder: (context, state) => const PharmacyDashboard()),
      GoRoute(path: kSalesPos, builder: (context, state) => SalesPOSPage()),
      GoRoute(path: kAdminDashboard, builder: (context, state) => const AdminDashboard()),
      GoRoute(path: kAdminInventory, builder: (context, state) =>  AdminInventoryPage()),
    ],

    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.matchedLocation == kLogin || state.matchedLocation == kSignUp;


      if (user == null) {
        return loggingIn ? null : kLogin;
      }

     
      if (loggingIn) {
      
        if (user.email == "admin@pharmpos.com") {
          return kAdminDashboard;
        } else {
          return kDashboard;
        }
      }

      return null; 
    },
  );
}


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
