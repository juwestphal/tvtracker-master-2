import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_login.dart'; // Importa a tela de login do administrador

const Color customPurple = Color(0xFFCBB7F9); // Define your custom purple color

void main() {
  runApp(const MovieSeriesTrackerApp());
}

class MovieSeriesTrackerApp extends StatelessWidget {
  const MovieSeriesTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Mate',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: customPurple), // Custom purple for labels
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: customPurple, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) =>
            HomeScreen(userId: "123456"), // Passando userId para HomeScreen
        '/admin_login': (context) => AdminLoginPage(),
      },
    );
  }
}
