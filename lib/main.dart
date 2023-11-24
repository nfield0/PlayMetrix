import 'package:flutter/material.dart';
import 'package:play_metrix/screens/home_screen.dart';
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
      home: const HomeScreen(), // Set your landing page here
    );
  }
}
