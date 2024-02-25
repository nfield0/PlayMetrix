import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/api_clients/injury_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/physio/edit_injury_screen.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/player/statistics_constants.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class PlayerProfileScreen extends ConsumerWidget {
  final AvailabilityData available = AvailabilityData(
      AvailabilityStatus.available,
      "Available",
      Icons.check_circle,
      AppColours.green);
  final AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.limited, "Limited", Icons.warning, AppColours.yellow);
  final AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Player Profile",
                      style: TextStyle(
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  smallButton(Icons.edit, "Edit", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPlayerProfileScreen(
                                physioId: ref.read(userIdProvider),
                                teamId: ref.read(teamIdProvider),
                                userRole: userRole,
                                playerId: userId,
                              )),
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
                          future: getPlayerTeamProfile(ref.read(teamIdProvider),
                              ref.read(userIdProvider)),
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
                                  availability == AvailabilityStatus.available
                                      ? available
                                      : availability ==
                                              AvailabilityStatus.limited
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
                                numPlayerIds, playerInjuriesData, userRole);
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
                                StatisticsData statisticsData = snapshot.data!;
                                return statisticsSection(statisticsData,
                                    available, limited, unavailable);
                              } else {
                                return Text('No data available');
                              }
                            })),
                    const SizedBox(height: 20),
                    if (userRole == UserRole.player)
                      bigButton("Log Out", () async {
                        logOut(ref, context);
                      }),
                    const SizedBox(height: 25),
                  ]),
                ))),
        bottomNavigationBar: playerBottomNavBar(context, 2));
  }
}

Widget playerProfile(
    String firstName,
    String surname,
    int playerNumber,
    String dob,
    String height,
    String gender,
    AvailabilityData availability,
    Uint8List? profilePicture) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            availability.icon,
            color: availability.color,
            size: 36,
          ),
          const SizedBox(width: 15),
          Text(availability.message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
        ],
      ),
      const SizedBox(height: 25),
      Text("#$playerNumber",
          style: TextStyle(
            color: availability.color,
            fontFamily: AppFonts.gabarito,
            fontWeight: FontWeight.bold,
            fontSize: 42,
          )),
      const SizedBox(height: 25),
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: availability.color, // Set the border color
            width: 5, // Set the border width
          ),
          borderRadius: BorderRadius.circular(20), // Set the border radius
        ),
        child: profilePicture != null && profilePicture.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  profilePicture,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                "lib/assets/icons/profile_placeholder.png",
                width: 150,
              ),
      ),
      const SizedBox(height: 20),
      Text(firstName,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.gabarito,
            fontSize: 36,
          )),
      Text(surname,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.gabarito,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          )),
      const SizedBox(height: 30),
      profileDetails("Date of Birth", dob),
      const SizedBox(height: 15),
      profileDetails("Height", "${height}cm"),
      const SizedBox(height: 15),
      profileDetails("Gender", gender),
      const SizedBox(height: 35),
      availabilityTrafficLight(availability.status),
    ]),
  );
}

Widget playerProfileNoTeam(String firstName, String surname, String dob,
    String height, String gender, Uint8List? profilePicture) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      Container(
        child: profilePicture != null && profilePicture.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  profilePicture,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                "lib/assets/icons/profile_placeholder.png",
                width: 150,
              ),
      ),
      const SizedBox(height: 20),
      Text(firstName,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.gabarito,
            fontSize: 36,
          )),
      Text(surname,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.gabarito,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          )),
      const SizedBox(height: 30),
      profileDetails("Date of Birth", dob),
      const SizedBox(height: 15),
      profileDetails("Height", "${height}cm"),
      const SizedBox(height: 15),
      profileDetails("Gender", gender),
    ]),
  );
}

Widget profileDetails(String title, String desc) {
  return Text.rich(
    TextSpan(
      text: "$title: ",
      style: const TextStyle(
        fontSize: 16,
      ),
      children: [
        TextSpan(
          text: desc,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget availabilityTrafficLight(AvailabilityStatus playerStatus) {
  List<AvailabilityData> availability = [
    AvailabilityData(AvailabilityStatus.available, "Available",
        Icons.check_circle, AppColours.green),
    AvailabilityData(AvailabilityStatus.limited, "Limited", Icons.warning,
        AppColours.yellow),
    AvailabilityData(AvailabilityStatus.unavailable, "Unavailable",
        Icons.cancel, AppColours.red)
  ];
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      availabilityTrafficLightItem(availability[0], playerStatus),
      availabilityTrafficLightItem(availability[1], playerStatus),
      availabilityTrafficLightItem(availability[2], playerStatus)
    ],
  );
}

Widget availabilityTrafficLightItem(
    AvailabilityData availability, AvailabilityStatus playerStatus) {
  double opacity = availability.status == playerStatus ? 1.0 : 0.4;

  return Column(
    children: [
      Opacity(
        opacity: opacity,
        child: Icon(
          availability.icon,
          color: availability.color,
          size: 24,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        availability.message,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}

Widget injuriesSection(int numInjuries,
    List<AllPlayerInjuriesData> playerInjuriesData, UserRole userRole) {
  return Column(children: [
    Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Number of Injuries",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              numInjuries.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        )),
    ExpansionPanelList.radio(
      elevation: 0,
      expandedHeaderPadding: const EdgeInsets.all(0),
      children: playerInjuriesData
          .map<ExpansionPanelRadio>((AllPlayerInjuriesData injury) {
        return ExpansionPanelRadio(
          value: injury.injury_id,
          backgroundColor: Colors.transparent,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text(injury.date_of_injury,
                      style: const TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold)),
                  if (userRole == UserRole.physio)
                    smallButton(Icons.edit, "Edit", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditInjuryScreen(
                                  injuryId: injury.injury_id,
                                  playerId: injury.player_id,
                                )),
                      );
                    })
                ]));
          },
          body: ListTile(
            title: injuryDetails(injury),
          ),
        );
      }).toList(),
    ),
  ]);
}

Widget injuryDetails(AllPlayerInjuriesData injury) {
  return Column(
    children: [
      greyDivider(),
      const SizedBox(height: 10),
      detailWithDivider("Date of Injury", injury.date_of_injury.toString()),
      const SizedBox(height: 10),
      detailWithDivider("Date of Recovery", injury.date_of_recovery.toString()),
      const SizedBox(height: 10),
      detailWithDivider("Injury Type", injury.injury_type),
      const SizedBox(height: 10),
      detailWithDivider("Injury Location", injury.injury_location),
      const SizedBox(height: 10),
      detailWithDivider(
          "Expected Recovery Time", injury.expected_recovery_time),
      const SizedBox(height: 10),
      detailWithDivider("Recovery Method", injury.recovery_method),
      underlineButtonTransparent("View player report", () {}),
    ],
  );
}

class Statistics {
  int matchesPlayed;
  int matchesStarted;
  int matchesOffBench;
  int totalMinutesPlayed;
  int numInjuries;

  Statistics(
    this.matchesPlayed,
    this.matchesStarted,
    this.matchesOffBench,
    this.totalMinutesPlayed,
    this.numInjuries,
  );
}

Widget statisticsSection(StatisticsData statistics, AvailabilityData available,
    AvailabilityData limited, AvailabilityData unavailable) {
  AvailabilityData matchesPlayed = statistics.matchesPlayed > matchesPlayedLimit
      ? unavailable
      : statistics.matchesPlayed < matchesPlayedLimit
          ? available
          : limited;

  AvailabilityData totalMinutesPlayed =
      statistics.totalMinutesPlayed >= totalMinutesPlayedLimit[0] &&
              statistics.totalMinutesPlayed <= totalMinutesPlayedLimit[1]
          ? limited
          : statistics.totalMinutesPlayed > totalMinutesPlayedLimit[1]
              ? unavailable
              : available;

  return Column(
    children: [
      statisticsDetailWithDivider(
          "Matches played", statistics.matchesPlayed.toString(), matchesPlayed),
      const SizedBox(
        height: 7,
      ),
      statisticsDetailWithDivider(
          "Matches started", statistics.matchesStarted.toString(), null),
      const SizedBox(
        height: 7,
      ),
      statisticsDetailWithDivider("Matches off the bench",
          statistics.matchesOffTheBench.toString(), null),
      const SizedBox(
        height: 7,
      ),
      statisticsDetailWithDivider("Total minutes played",
          statistics.totalMinutesPlayed.toString(), totalMinutesPlayed),
      const SizedBox(
        height: 7,
      ),
      statisticsDetailWithDivider(
          "Injury Prone", statistics.injuryProne ? "Yes" : "No", null)
    ],
  );
}
