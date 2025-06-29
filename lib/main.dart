
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, MultiBlocProvider, BlocProvider;
import 'package:pharmacy_pos/feature/pos/presentation/cubits/pos_cubit.dart';


import 'core/config/firebase/firebase_config.dart';
import 'core/config/routes/app_router.dart';
import 'core/constants/bloc_observer.dart';
import 'feature/pos/presentation/cubits/invoice_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<PosCubit>(
          create: (_) => PosCubit(),
        ),
        BlocProvider(
  create: (_) => InvoiceCubit(),
 
),

      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}
