import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/push_notification_manager.dart';
import 'package:play_metrix/screens/onboarding_screen.dart';

void main() async {
  initialiseNotifications();
  await configureLocalTimeZone();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayMetrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(
            margin: EdgeInsets.symmetric(horizontal: 10)),
        colorScheme: const ColorScheme.light(
            primary: AppColours.darkBlue, secondary: AppColours.darkBlue),
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
      home: OnBoardingScreen(), // Set your landing page here
    );
  }
}
