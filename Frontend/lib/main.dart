import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/schedule/add_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/schedule/daily_schedule_screen.dart';
import 'screens/authentication/landing_screen.dart'; // Import your landing page

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
        colorScheme: const ColorScheme.light(primary: AppColours.darkBlue),
        appBarTheme: const AppBarTheme(surfaceTintColor: AppColours.mediumBlue),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Colors.white,
          rangeSelectionBackgroundColor: AppColours.darkBlue,
          surfaceTintColor: AppColours.lightBlue,
          headerBackgroundColor: AppColours.darkBlue,
          headerForegroundColor: Colors.white,
          todayBackgroundColor:
              MaterialStateProperty.all<Color>(AppColours.darkBlue),
          todayForegroundColor: MaterialStateProperty.all<Color>(Colors.white),
          headerHeadlineStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.gabarito),
        ),
      ),
      home: const LandingScreen(), // Set your landing page here
    );
  }
}
