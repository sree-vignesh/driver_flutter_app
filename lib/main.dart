import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/order_screen.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/order': (context) => const OrderScreen(),
      },
    );
  }
}
