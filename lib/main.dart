import 'package:flutter/material.dart';
import 'screens/landing_screen.dart'; // Import your landing page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayMetrix',
      theme: ThemeData(
          // Define your app's theme here
          ),
      home: const LandingScreen(), // Set your landing page here
    );
  }
}
