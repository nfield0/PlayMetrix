import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/profile/profile_view_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class CoachesScreen extends ConsumerWidget {
  const CoachesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Team",
              style: TextStyle(
                color: AppColours.darkBlue,
                fontFamily: AppFonts.gabarito,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              )),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 35, left: 35),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.sync_alt,
                                    color: AppColours.darkBlue, size: 24),
                                underlineButtonTransparent("Switch to Players",
                                    () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              PlayersScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                }),
                              ]),
                          const SizedBox(height: 25),
                          FutureBuilder(
                              future: getTeamById(
                                  ref.read(teamIdProvider.notifier).state),
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
                                          builder: (context) =>
                                              TeamProfileScreen()),
                                    );
                                  });
                                } else {
                                  return emptySection(
                                      Icons.group_off, "No team yet");
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
                                              Dismissible(
                                                direction: DismissDirection.endToStart,
                                                background: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: AppColours.red),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          "Remove coach from team",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily: AppFonts
                                                                  .gabarito)),
                                                      SizedBox(width: 20),
                                                      Icon(Icons.delete,
                                                          color: Colors.white,
                                                          size: 30),
                                                      SizedBox(width: 30),
                                                    ],
                                                  ),
                                                ),
                                                confirmDismiss:
                                                    (direction) async {
                                                  return await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Remove Coach",
                                                          style: TextStyle(
                                                            color: AppColours
                                                                .darkBlue,
                                                            fontFamily: AppFonts
                                                                .gabarito,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "Are you sure you want to remove ${coach.firstName} ${coach.surname} from your team?",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                            child: const Text(
                                                                "Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: const Text(
                                                                "Remove"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                key: Key(coach.id.toString()),
                                                child: profilePill(
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
                                                              userRole: UserRole
                                                                  .coach,
                                                            )),
                                                  );
                                                }),
                                              )
                                          ],
                                        )
                                      : emptySection(Icons.person_off,
                                          "No coaches added yet");
                                } else {
                                  return const Text('No data available');
                                }
                              }),
                        ]))))),
        bottomNavigationBar: managerBottomNavBar(context, 0));
  }
}
