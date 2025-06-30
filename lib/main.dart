
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_pos/feature/pos/domain/repositories/invoice_repository.dart';
import 'package:pharmacy_pos/feature/pos/presentation/cubits/pos_cubit.dart';

import 'core/config/firebase/firebase_options.dart';
import 'core/config/routes/app_router.dart';
import 'core/constants/bloc_observer.dart';
import 'feature/pos/data/repositories/invoice_repository_impl.dart';
import 'feature/pos/data/sources/local_data_source.dart';
import 'feature/pos/data/sources/remote_data_source.dart';
import 'feature/pos/presentation/cubits/invoice_cubit.dart';
import 'init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await initializeApp();

  final local = LocalDataSource();
  final remote = RemoteDataSource();
  final invoiceRepo = InvoiceRepositoryImpl(local, remote);

  runApp(MyApp(
    invoiceRepository: invoiceRepo,
    remoteDataSource: remote,
    localDataSource: local,
  ));
}

class MyApp extends StatelessWidget {
  final InvoiceRepository invoiceRepository;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  const MyApp({
    super.key,
    required this.invoiceRepository,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InvoiceCubit(
            invoiceRepository,
            remoteDataSource,
            localDataSource,
          )..initializeInvoices(),
        ),
        BlocProvider(
          create: (_) => PosCubit(
            invoiceRepository,
            remoteDataSource,
            localDataSource,
          )..initializeProducts(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }
}

