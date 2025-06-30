
import 'package:hive_flutter/hive_flutter.dart';


Future<void> initializeApp() async {
  
  await Hive.initFlutter();

  await Hive.openBox('invoices');
  await Hive.openBox('products');
}

