import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:pharmacy_pos/firebase_options.dart';

import 'core/utils/app_router.dart';
import 'core/utils/bloc_observer.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyBlocObserver();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pharma POS',
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Montserrat'),

      debugShowCheckedModeBanner: false,

      routerConfig: AppRouter.router,
    );
  }
}
