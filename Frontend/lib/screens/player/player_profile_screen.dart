import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
import 'package:play_metrix/screens/injury/edit_injury_screen.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/injury/injury_report_view.dart';
import 'package:play_metrix/screens/player/player_profile_view_screen.dart';
import 'package:play_metrix/screens/statistics/statistics_constants.dart';
import 'package:play_metrix/screens/statistics/statistics_screen.dart';
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
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Player Profile",
                      style: TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: AppFonts.gabarito)),
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
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 20, left: 20),
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
                                      String firstName = player.firstName;
                                      String surname = player.surname;
                                      DateTime dob = player.dob;
                                      String height = player.height;
                                      String gender = player.gender;
                                      Uint8List? profilePicture = player.image;

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
                                      ref.read(teamIdProvider),
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
                                      Uint8List? profilePicture =
                                          player.imageBytes;
                                      int playerNumber = player.teamNumber;
                                      AvailabilityStatus availability =
                                          player.status;
                                      AvailabilityData availabilityData =
                                          availability ==
                                                  AvailabilityStatus.available
                                              ? available
                                              : availability ==
                                                      AvailabilityStatus.limited
                                                  ? limited
                                                  : unavailable;
                                      String reasonForStatus =
                                          player.reasonForStatus;

                                      return playerProfile(
                                          firstName,
                                          surname,
                                          playerNumber,
                                          dob,
                                          height,
                                          gender,
                                          availabilityData,
                                          reasonForStatus,
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
                                            builder: (context) =>
                                                TeamProfileScreen()),
                                      );
                                    });
                                  } else {
                                    return emptySection(
                                        Icons.group_off, "No team yet");
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
                                    List<AllPlayerInjuriesData>
                                        playerInjuriesData = snapshot.data!;
                                    int numPlayerIds =
                                        playerInjuriesData.length;

                                    return injuriesSection(
                                        numPlayerIds,
                                        playerInjuriesData,
                                        userRole,
                                        context,
                                        ref);
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
                                        StatisticsData statisticsData =
                                            snapshot.data!;
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
                        ))))),
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
    String reasonForStatus,
    Uint8List? profilePicture) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(right: 20, left: 20),
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
      const SizedBox(
        height: 35,
      ),
      if (reasonForStatus.isNotEmpty)
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Reason: ",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColours.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: reasonForStatus,
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
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

Widget injuriesSection(
    int numInjuries,
    List<AllPlayerInjuriesData> playerInjuriesData,
    UserRole userRole,
    BuildContext context,
    WidgetRef ref) {
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        )),
    ExpansionPanelList.radio(
      elevation: 0,
      expandedHeaderPadding: const EdgeInsets.all(0),
      children: playerInjuriesData
          .map<ExpansionPanelRadio>((AllPlayerInjuriesData injury) {
        return ExpansionPanelRadio(
          value: injury.playerInjuryId,
          backgroundColor: Colors.transparent,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text(DateFormat('yyyy-MM-dd').format(injury.dateOfInjury),
                      style: const TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold)),
                  if (userRole == UserRole.physio)
                    smallButton(Icons.edit, "Edit", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditInjuryScreen(
                                  teamId: ref.read(teamIdProvider),
                                  physioId: injury.physioId,
                                  playerId: injury.playerId,
                                  playerInjuryId: injury.playerInjuryId,
                                )),
                      );
                    })
                ]));
          },
          body: ListTile(
            title: playerInjuryDetails(injury, context, ref),
          ),
        );
      }).toList(),
    ),
  ]);
}

Widget playerInjuryDetails(
    AllPlayerInjuriesData injury, BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      greyDivider(),
      const SizedBox(height: 10),
      detailWithDividerSmall("Injury Name", injury.nameAndGrade, context),
      const SizedBox(height: 10),
      detailWithDividerSmall("Date of Injury",
          DateFormat('yyyy-MM-dd').format(injury.dateOfInjury), context),
      const SizedBox(height: 10),
      detailWithDividerSmall(
          "Date of Recovery",
          DateFormat('yyyy-MM-dd').format(injury.expectedDateOfRecovery),
          context),
      const SizedBox(height: 10),
      detailWithDividerSmall("Injury Type", injury.type, context),
      const SizedBox(height: 10),
      detailWithDividerSmall("Injury Location", injury.location, context),
      const SizedBox(height: 10),
      detailWithDividerSmall(
          "Recovery Time",
          "${injury.expectedMinRecoveryTime}-"
              "${injury.expectedMaxRecoveryTime} weeks",
          context),
      ExpansionPanelList.radio(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        children: [
          ExpansionPanelRadio(
            value: injury.playerInjuryId,
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text("Potential Recovery Methods",
                    style: TextStyle(fontSize: 16)),
              );
            },
            body: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0;
                      i < injury.potentialRecoveryMethods.length;
                      i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                          '${i + 1}. ${injury.potentialRecoveryMethods[i]}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
      injury.playerInjuryReport != null
          ? underlineButtonTransparent("View player report", () {
              injury.playerInjuryReport != null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InjuryReportView(
                              data: injury.playerInjuryReport)),
                    )
                  : null;
            })
          : const SizedBox(),
      const SizedBox(height: 10),
      ref.read(userRoleProvider.notifier).state == UserRole.physio
          ? underlineButtonTransparentRed("Delete player injury", () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Injury",
                          style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.gabarito,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      content: const Text(
                        "Are you sure you want to delete this injury?",
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            deletePlayerInjury(injury.playerInjuryId);
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayerProfileViewScreen(
                                          playerId: injury.playerId,
                                        )));
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  });
            })
          : const SizedBox(),
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
      statisticsDetailWithDivider("Total minutes played",
          statistics.totalMinutesPlayed.toString(), totalMinutesPlayed),
      const SizedBox(
        height: 7,
      ),
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
    ],
  );
}
