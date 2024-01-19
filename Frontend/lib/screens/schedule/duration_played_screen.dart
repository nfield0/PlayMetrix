import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/notifications_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class DurationPlayedScreen extends StatefulWidget {
  const DurationPlayedScreen({Key? key}) : super(key: key);

  @override
  _DurationPlayedScreenState createState() => _DurationPlayedScreenState();
}

class _DurationPlayedScreenState extends State<DurationPlayedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitlePreviousPage("Match Line Up"),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 45),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Duration Played",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.gabarito,
                  ),
                ),
                const SizedBox(height: 5),
                const Text("Matchday | Tuesday, 2 October 2023"),
                const SizedBox(height: 20),
                timePickerWithDivider(
                  context,
                  "Match start time",
                  TimeOfDay.now(),
                  (p0) {},
                ),
                timePickerWithDivider(
                  context,
                  "First half end time",
                  TimeOfDay.now(),
                  (p0) {},
                ),
                timePickerWithDivider(
                  context,
                  "Second half start time",
                  TimeOfDay.now(),
                  (p0) {},
                ),
                timePickerWithDivider(
                  context,
                  "Match end time",
                  TimeOfDay.now(),
                  (p0) {},
                ),
                const SizedBox(height: 30),
                const Text(
                  "All Players",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.gabarito,
                  ),
                ),
                _playerSearchBar(),
                _playerDurationPlayedBox(
                  context,
                  "lib/assets/icons/profile_placeholder.png",
                  "Luana",
                  "Kimley",
                  7,
                ),
                const SizedBox(height: 20),
                _playerDurationPlayedBox(
                  context,
                  "lib/assets/icons/profile_placeholder.png",
                  "Luana",
                  "Kimley",
                  7,
                ),
                const SizedBox(height: 20),
                _playerSearchBar(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: managerBottomNavBar(context, 2),
    );
  }
}

Widget _playerSearchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search players...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}

Widget _playerDurationPlayedBox(
  BuildContext context,
  String imagePath,
  String firstName,
  String surname,
  int playerNum,
) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColours.darkBlue, width: 4),
      borderRadius: BorderRadius.circular(15),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              imagePath,
              width: 65,
            ),
            const SizedBox(
              width: 25,
            ),
            Text(
              "#$playerNum",
              style: const TextStyle(
                color: AppColours.darkBlue,
                fontSize: 36,
                fontFamily: AppFonts.gabarito,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: AppFonts.gabarito,
                  ),
                ),
                Text(
                  surname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: AppFonts.gabarito,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: Column(
            children: [
              timePickerWithDivider(
                context,
                "Start time",
                TimeOfDay.now(),
                (p0) {},
              ),
              timePickerWithDivider(
                context,
                "End time",
                TimeOfDay.now(),
                (p0) {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
