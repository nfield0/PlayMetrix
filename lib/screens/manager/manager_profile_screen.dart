import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/manager/edit_manager_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class ManagerProfileScreen extends StatefulWidget {
  const ManagerProfileScreen({Key? key}) : super(key: key);

  @override
  _ManagerProfileScreenState createState() => _ManagerProfileScreenState();
}

class _ManagerProfileScreenState extends State<ManagerProfileScreen> {
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
                padding: const EdgeInsets.only(top: 30, right: 35, left: 35),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontFamily: AppFonts.gabarito,
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      smallButton(Icons.edit, "Edit", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EditManagerProfileScreen()),
                        );
                      }),
                    ],
                  ),
                  Center(
                    child: Column(children: [
                      const SizedBox(height: 20),
                      Text(
                        "Brian Smith",
                        style: const TextStyle(
                          fontFamily: AppFonts.gabarito,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset("lib/assets/icons/profile_placeholder.png",
                          width: 150),
                      const SizedBox(height: 20),
                      smallPill("Manager"),
                      const SizedBox(height: 40),
                      profilePill("Louth GAA", "Senior Football",
                          "lib/assets/icons/logo_placeholder.png", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TeamProfileScreen()),
                        );
                      }),
                      const SizedBox(height: 20),
                      divider(),
                      const SizedBox(height: 20),
                      const Text("Contacts",
                          style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontSize: 32,
                            color: AppColours.darkBlue,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      detailWithDivider("Phone", "+353829381823"),
                      const SizedBox(height: 10),
                      detailWithDivider("Email", "bsmith@louthgaa.com"),
                      const SizedBox(height: 25),
                      bigButton("Log Out", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingScreen()),
                        );
                      }),
                      const SizedBox(height: 25),
                    ]),
                  )
                ]))),
        bottomNavigationBar: managerBottomNavBar(context, 3));
  }
}
