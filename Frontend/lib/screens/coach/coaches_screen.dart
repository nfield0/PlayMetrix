import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class CoachesScreen extends StatefulWidget {
  const CoachesScreen({Key? key}) : super(key: key);

  @override
  _CoachesScreenState createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 35, left: 35),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.sync_alt,
                        color: AppColours.darkBlue, size: 24),
                    underlineButtonTransparent("Switch to Players", () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              PlayersScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }),
                  ]),
                  const SizedBox(height: 10),
                  profilePill("Louth GAA", "Senior Football",
                      "lib/assets/icons/logo_placeholder.png", null, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeamProfileScreen()),
                    );
                  }),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Coaches",
                        style: TextStyle(
                          fontFamily: AppFonts.gabarito,
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      smallButton(Icons.person_add, "Add", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddCoachScreen()),
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 25),
                  profilePill("John Smith", "jsmith@louthgaa.com",
                      "lib/assets/icons/profile_placeholder.png", null, () {}),
                ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
