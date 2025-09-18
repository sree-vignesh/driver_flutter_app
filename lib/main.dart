import 'package:driver_app/core/colors.dart';
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
      theme: ThemeData(
        // primarySwatch: Colors.orange,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.scaffoldBackgroundColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            backgroundColor: AppColors.primary, // button background
            foregroundColor: Colors.white, // text color
            minimumSize: const Size(
              double.infinity,
              52,
            ), // full width, 48px tall
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // rounded corners
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          // elevation:0,
          dismissDirection: DismissDirection.vertical, // allows swipe down
          backgroundColor: AppColors.primary,
          contentTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
      ),
      initialRoute:
          '/', //using /order for development, change to / when submitting.
      routes: {
        '/': (context) => const LoginScreen(),
        '/order': (context) => const OrderScreen(),
      },
    );
  }
}
