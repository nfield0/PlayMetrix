import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/physio/add_physio_screen.dart';
import 'package:play_metrix/screens/team/edit_team_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class TeamProfileScreen extends StatefulWidget {
  const TeamProfileScreen({Key? key}) : super(key: key);

  @override
  _TeamProfileScreenState createState() => _TeamProfileScreenState();
}

class _TeamProfileScreenState extends State<TeamProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Team Profile",
                    style: TextStyle(
                      color: AppColours.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                smallButton(Icons.edit, "Edit", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditTeamScreen()),
                  );
                })
              ],
            )),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 35, left: 35),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Louth GAA",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.gabarito,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Image.asset(
                      'lib/assets/icons/logo_placeholder.png',
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    smallPill("Senior Football"),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pin_drop, color: Colors.red, size: 28),
                        SizedBox(width: 10),
                        Text("Louth", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Divison 1", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    divider(),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Manager",
                            style: TextStyle(
                                color: AppColours.darkBlue,
                                fontFamily: AppFonts.gabarito,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    profilePill("Brian Smith", "briansmith@louthgaa.com",
                        "lib/assets/icons/profile_placeholder.png", () {}),
                    const SizedBox(height: 20),
                    divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Physio",
                            style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.gabarito,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          smallButton(Icons.person_add, "Add", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddPhysioScreen()),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    profilePill("Sophia Bloggs", "sophiabloggs@louthgaa.com",
                        "lib/assets/icons/profile_placeholder.png", () {}),
                    const SizedBox(height: 20),
                    divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Coaches",
                            style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.gabarito,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          smallButton(Icons.person_add, "Add", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddCoachScreen()),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    emptySection(Icons.person_off, "No coaches added yet"),
                    const SizedBox(height: 50),
                  ],
                ),
              ))),
      bottomNavigationBar: managerBottomNavBar(context, 0),
    );
  }
}
