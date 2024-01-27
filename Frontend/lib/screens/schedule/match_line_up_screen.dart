import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/schedule/duration_played_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class MatchLineUpScreen extends StatefulWidget {
  const MatchLineUpScreen({Key? key}) : super(key: key);

  @override
  _MatchLineUpScreenState createState() => _MatchLineUpScreenState();
}

class _MatchLineUpScreenState extends State<MatchLineUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("{Event Name}"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(35),
              child: Center(
                  child: Column(children: [
                const Text("Match Line Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.gabarito)),
                const SizedBox(height: 5),
                const Text("Training | Tuesday, 2 October 2023"),
                const SizedBox(height: 20),
                underlineButtonTransparent("Record duration played", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DurationPlayedScreen(),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text("Starting Players",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.gabarito)),
                const SizedBox(height: 20),
                // playerProfilePill(
                //     context,
                //     "lib/assets/icons/profile_placeholder.png",
                //     "Luana",
                //     "Kimley",
                //     7,
                //     AvailabilityStatus.Available),
                // const SizedBox(height: 20),
                // playerProfilePill(
                //     context,
                //     "lib/assets/icons/profile_placeholder.png",
                //     "Luana",
                //     "Kimley",
                //     7,
                //     AvailabilityStatus.Available),
                const SizedBox(height: 25),
                const Text("Substitutes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.gabarito)),
                const SizedBox(height: 20),
                // playerProfilePill(
                //     context,
                //     "lib/assets/icons/profile_placeholder.png",
                //     "Luana",
                //     "Kimley",
                //     7,
                //     AvailabilityStatus.Available),
                // const SizedBox(height: 20),
                // playerProfilePill(
                //     context,
                //     "lib/assets/icons/profile_placeholder.png",
                //     "Luana",
                //     "Kimley",
                //     7,
                //     AvailabilityStatus.Available),
              ]))),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
