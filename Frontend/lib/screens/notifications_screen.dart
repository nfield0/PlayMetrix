import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          title: const Text("Notifications",
              style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.gabarito,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700)),
        ),
        body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(children: [
            announcementBox(
              icon: Icons.notifications_active,
              iconColor: AppColours.darkBlue,
              title: "Matchday tomorrow",
              description: "Date: 13/10/2023\nTime: 19:00-20:30",
              date: "12/10/2023",
              onDeletePressed: () {},
            ),
            announcementBox(
              icon: Icons.cancel,
              iconColor: AppColours.red,
              title: "Reece James is injured",
              description:
                  "Date of injury: 26/10/2023\nInjury type: Sprained ankle",
              date: "10/10/2023",
              onDeletePressed: () {},
            ),
          ]),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 0));
  }
}
