import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  AvailabilityData available = AvailabilityData(AvailabilityStatus.Available,
      "Available", Icons.check_circle, AppColours.green);
  AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow);
  AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.Unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'lib/assets/logo.png',
            width: 150,
            fit: BoxFit.contain,
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Statistics',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 20),
                      const Text('All Activities',
                          style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      _statisticsDetailWithDivider(
                          "Matches played", "10", available),
                      const SizedBox(
                        height: 7,
                      ),
                      _statisticsDetailWithDivider(
                          "Matches started", "4", limited),
                      const SizedBox(
                        height: 7,
                      ),
                      _statisticsDetailWithDivider(
                          "Matches off the bench", "6", unavailable),
                      const SizedBox(
                        height: 7,
                      ),
                      _statisticsDetailWithDivider(
                          "Total minutes played", "230", unavailable),
                      const SizedBox(
                        height: 7,
                      ),
                      _statisticsDetailWithDivider(
                          "Number of injuries", "1", available)
                    ]))),
        bottomNavigationBar: playerBottomNavBar(context, 1));
  }
}

Widget _statisticsDetailWithDivider(
    String title, String detail, AvailabilityData availability) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(detail,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 7),
              Icon(availability.icon, color: availability.color, size: 16),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10),
      greyDivider(),
    ],
  );
}
