import 'dart:typed_data';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/player_profile_set_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class PlayerProfileViewScreen extends ConsumerWidget {
  final int userId;

  PlayerProfileViewScreen({super.key, required this.userId});

  final AvailabilityData available = AvailabilityData(
      AvailabilityStatus.Available,
      "Available",
      Icons.check_circle,
      AppColours.green);
  final AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow);
  final AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.Unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: userRole == UserRole.player ? false : true,
          title: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Players",
                      style: TextStyle(
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  smallButton(Icons.edit, "Edit", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPlayerProfileScreen()),
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
                  child: Column(children: [
                    if (ref.read(teamIdProvider.notifier).state == -1)
                      FutureBuilder<PlayerData>(
                          future: getPlayerById(userId),
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
                              PlayerData player = snapshot.data!;
                              String firstName = player.player_firstname;
                              String surname = player.player_surname;
                              DateTime dob = player.player_dob;
                              String height = player.player_height;
                              String gender = player.player_gender;
                              Uint8List? profilePicture = player.player_image;

                              String formattedDate =
                                  "${dob.toLocal()}".split(' ')[0];

                              return playerProfileNoTeam(
                                  firstName,
                                  surname,
                                  formattedDate,
                                  height,
                                  gender,
                                  profilePicture);
                            } else {
                              return Text('No data available');
                            }
                          }),
                    if (ref.read(teamIdProvider.notifier).state != -1)
                      FutureBuilder<PlayerProfile>(
                          future: getPlayerTeamProfile(
                              ref.read(teamIdProvider), userId),
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
                              PlayerProfile player = snapshot.data!;
                              String firstName = player.firstName;
                              String surname = player.surname;
                              String dob = player.dob;
                              String height = player.height;
                              String gender = player.gender;
                              Uint8List? profilePicture = player.imageBytes;
                              int playerNumber = player.teamNumber;
                              AvailabilityStatus availability = player.status;
                              AvailabilityData availabilityData =
                                  availability == AvailabilityStatus.Available
                                      ? available
                                      : availability ==
                                              AvailabilityStatus.Limited
                                          ? limited
                                          : unavailable;

                              return playerProfile(
                                  firstName,
                                  surname,
                                  playerNumber,
                                  dob,
                                  height,
                                  gender,
                                  availabilityData,
                                  profilePicture);
                            } else {
                              return Text('No data available');
                            }
                          }),
                    const SizedBox(height: 20),
                    divider(),
                    const SizedBox(height: 20),
                    const Text("Teams",
                        style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontWeight: FontWeight.bold,
                            color: AppColours.darkBlue,
                            fontSize: 30)),
                    const SizedBox(height: 20),
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
                                    builder: (context) => TeamProfileScreen()),
                              );
                            });
                          } else {
                            return emptySection(Icons.group_off, "No team yet");
                          }
                        }),
                    const SizedBox(height: 20),
                    divider(),
                    const SizedBox(height: 20),
                    const Text("Injuries",
                        style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontWeight: FontWeight.bold,
                            color: AppColours.darkBlue,
                            fontSize: 30)),
                    FutureBuilder<List<AllPlayerInjuriesData>>(
                        future: getAllPlayerInjuriesByUserId(userId),
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
                            List<AllPlayerInjuriesData> playerInjuriesData =
                                snapshot.data!;
                            int numPlayerIds = playerInjuriesData.length;

                            return injuriesSection(
                                numPlayerIds, playerInjuriesData);
                          } else {
                            return Text('No data available');
                          }
                        }),
                    //_injuriesSection(3),
                    divider(),
                    const SizedBox(height: 20),
                    const Text("Statistics",
                        style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontWeight: FontWeight.bold,
                            color: AppColours.darkBlue,
                            fontSize: 30)),
                    const SizedBox(height: 20),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: FutureBuilder<StatisticsData>(
                            future: getStatisticsData(userId),
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
                                StatisticsData statistics = snapshot.data!;
                                return Column(
                                  children: [
                                    statisticsDetailWithDivider(
                                        "Matches played",
                                        statistics.matchesPlayed.toString(),
                                        available),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Matches started",
                                        statistics.matchesStarted.toString(),
                                        limited),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Matches off the bench",
                                        statistics.matchesOffTheBench
                                            .toString(),
                                        unavailable),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Total minutes played",
                                        statistics.totalMinutesPlayed
                                            .toString(),
                                        unavailable),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Injury Prone",
                                        statistics.injuryProne ? "Yes" : "No",
                                        null)
                                  ],
                                );
                              } else {
                                return Text('No data available');
                              }
                            })),
                    const SizedBox(height: 20),
                    if (userRole == UserRole.player)
                      bigButton("Log Out", () {
                        ref.read(userRoleProvider.notifier).state =
                            UserRole.manager;
                        ref.read(userIdProvider.notifier).state = 0;
                        ref.read(profilePictureProvider.notifier).state = null;
                        ref.read(dobProvider.notifier).state = DateTime.now();
                        ref.read(genderProvider.notifier).state = "Male";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingScreen()),
                        );
                      }),
                    const SizedBox(height: 25),
                  ]),
                ))));
  }
}
