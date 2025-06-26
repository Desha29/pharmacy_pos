
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;


import 'core/config/firebase/firebase_config.dart';
import 'core/config/routes/app_router.dart';
import 'core/constants/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
   await initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pharma POS',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
