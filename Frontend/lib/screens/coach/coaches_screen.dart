import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/profile/profile_view_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class CoachesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  const SizedBox(height: 25),
                  FutureBuilder(
                      future:
                          getTeamById(ref.read(teamIdProvider.notifier).state),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          TeamData team = snapshot.data!;
                          return profilePill(
                              team.team_name,
                              team.team_location,
                              "lib/assets/icons/logo_placeholder.png",
                              team.team_logo, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeamProfileScreen()),
                            );
                          });
                        } else {
                          return emptySection(Icons.group_off, "No team yet");
                        }
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
                              builder: (context) => AddCoachScreen()),
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 25),
                  FutureBuilder(
                      future: getCoachesForTeam(
                          ref.read(teamIdProvider.notifier).state),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<Profile> coaches =
                              snapshot.data as List<Profile>;
                          return coaches.isNotEmpty
                              ? Column(
                                  children: [
                                    for (Profile coach in coaches)
                                      profilePill(
                                          "${coach.firstName} ${coach.surname}",
                                          coach.email,
                                          "lib/assets/icons/profile_placeholder.png",
                                          coach.imageBytes, () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileViewScreen(
                                                    userId: coach.id,
                                                    userRole: UserRole.coach,
                                                  )),
                                        );
                                      }),
                                  ],
                                )
                              : emptySection(
                                  Icons.person_off, "No coaches added yet");
                        } else {
                          return const Text('No data available');
                        }
                      }),
                ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
