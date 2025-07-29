import 'package:coin_api_and_admin_panel/views/admin_panel.dart';
import 'package:coin_api_and_admin_panel/views/dashboard.dart';
import 'package:coin_api_and_admin_panel/views/login.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/booking_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookingModelAdapter());
  await Hive.openBox('admin');

  // Open box before runApp
  await Hive.openBox<BookingModel>('bookings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}


