import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/manager_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/physio/add_physio_screen.dart';
import 'package:play_metrix/screens/profile/profile_view_screen.dart';
import 'package:play_metrix/screens/team/edit_team_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';

class TeamProfileScreen extends ConsumerWidget {
  const TeamProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBarTitlePreviousPage("Team Profile"),
                if (ref.read(userRoleProvider.notifier).state ==
                    UserRole.manager)
                  smallButton(Icons.edit, "Edit", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTeamScreen(
                              teamId: ref.read(teamIdProvider.notifier).state,
                              managerId:
                                  ref.read(userIdProvider.notifier).state),
                        ));
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
                    FutureBuilder<TeamData?>(
                        future: getTeamById(
                            ref.read(teamIdProvider.notifier).state),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Display a loading indicator while the data is being fetched
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Display an error message if the data fetching fails
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            // Data has been successfully fetched, use it here
                            TeamData team = snapshot.data!;
                            String teamName = team.team_name;
                            String teamLocation = team.team_location;
                            int managerId = team.manager_id;
                            Uint8List? logo = team.team_logo;

                            return Column(children: [
                              Text(
                                teamName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.gabarito,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 25),
                              logo.isNotEmpty
                                  ? Image.memory(
                                      logo,
                                      width: 150,
                                    )
                                  : Image.asset(
                                      "lib/assets/icons/logo_placeholder.png",
                                      width: 150,
                                    ),
                              // const SizedBox(height: 40),
                              // smallPill("Senior Football"),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.pin_drop,
                                      color: Colors.red, size: 28),
                                  const SizedBox(width: 10),
                                  Text(teamLocation,
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              FutureBuilder(
                                  future: getTeamLeagueName(
                                      ref.read(teamIdProvider.notifier).state),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Display a loading indicator while the data is being fetched
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // Display an error message if the data fetching fails
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      return Text(snapshot.data.toString(),
                                          style: const TextStyle(fontSize: 18));
                                    } else {
                                      return const Text('No data available');
                                    }
                                  }),
                              const SizedBox(height: 20),
                              divider(),
                              FutureBuilder(
                                  future: getManagerProfile(managerId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Display a loading indicator while the data is being fetched
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // Display an error message if the data fetching fails
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      Profile manager = snapshot.data!;
                                      return Column(children: [
                                        const Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "Manager",
                                                style: TextStyle(
                                                    color: AppColours.darkBlue,
                                                    fontFamily:
                                                        AppFonts.gabarito,
                                                    fontSize: 28,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        profilePill(
                                            "${manager.firstName} ${manager.surname}",
                                            manager.email,
                                            "lib/assets/icons/profile_placeholder.png",
                                            manager.imageBytes, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileViewScreen(
                                                      userId: manager.id,
                                                      userRole:
                                                          UserRole.manager,
                                                    )),
                                          );
                                        }),
                                        const SizedBox(height: 20),
                                      ]);
                                    } else {
                                      return Text('No data available');
                                    }
                                  })
                            ]);
                          } else {
                            return Text('No data available');
                          }
                        }),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
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
                          if (ref.read(userRoleProvider.notifier).state ==
                              UserRole.manager)
                            smallButton(Icons.person_add, "Add", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPhysioScreen()),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: getPhysiosForTeam(
                            ref.read(teamIdProvider.notifier).state),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            List<Profile> physios =
                                snapshot.data as List<Profile>;
                            return physios.isNotEmpty
                                ? Column(
                                    children: [
                                      for (Profile physio in physios)
                                        profilePill(
                                            "${physio.firstName} ${physio.surname}",
                                            physio.email,
                                            "lib/assets/icons/profile_placeholder.png",
                                            physio.imageBytes, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileViewScreen(
                                                      userId: physio.id,
                                                      userRole: UserRole.physio,
                                                    )),
                                          );
                                        }),
                                    ],
                                  )
                                : emptySection(
                                    Icons.person_off, "No physios added yet");
                          } else {
                            return const Text('No data available');
                          }
                        }),
                    const SizedBox(height: 20),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
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
                          if (ref.read(userRoleProvider.notifier).state ==
                              UserRole.manager)
                            smallButton(Icons.person_add, "Add", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCoachScreen()),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 50),
                  ],
                ),
              ))),
      bottomNavigationBar:
          roleBasedBottomNavBar(ref.read(userRoleProvider), context, 0),
    );
  }
}
