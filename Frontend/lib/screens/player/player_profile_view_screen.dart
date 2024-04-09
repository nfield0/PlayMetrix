import 'dart:typed_data';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/api_clients/injury_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/screens/injury/add_injury_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class PlayerProfileViewScreen extends ConsumerWidget {
  final int playerId;

  PlayerProfileViewScreen({super.key, required this.playerId});

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

  final allPlayerInjuriesProvider =
      FutureProvider.autoDispose<List<AllPlayerInjuriesData>>((ref) async {
    return await getAllPlayerInjuriesByUserId(ref.read(playerIdProvider));
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    AsyncValue<List<AllPlayerInjuriesData>> allPlayersInjuriesData =
        ref.watch(allPlayerInjuriesProvider);

    return Scaffold(
        appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Players",
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
                                userRole: userRole,
                                playerId: playerId,
                                teamId: ref.read(teamIdProvider),
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
                                  future: getPlayerById(playerId),
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
                                      return const Text('No data available');
                                    }
                                  }),
                            if (ref.read(teamIdProvider.notifier).state != -1)
                              FutureBuilder<PlayerProfile>(
                                  future: getPlayerTeamProfile(
                                      ref.read(teamIdProvider), playerId),
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
                                      return const Text('No data available');
                                    }
                                  }),
                            const SizedBox(height: 20),
                            divider(),
                            const SizedBox(height: 20),
                            const Text("Team",
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
                            if (userRole == UserRole.manager)
                              Column(children: [
                                const SizedBox(height: 20),
                                underlineButtonTransparentRed(
                                    "Remove from team", () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Remove Player",
                                          style: TextStyle(
                                            color: AppColours.darkBlue,
                                            fontFamily: AppFonts.gabarito,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Text(
                                          "Are you sure you want to remove player from your team?",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlayersScreen()),
                                              );

                                              removePlayerFromTeam(
                                                  ref.read(teamIdProvider),
                                                  playerId);
                                            },
                                            child: const Text("Remove"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                              ]),
                            const SizedBox(height: 20),
                            divider(),
                            const SizedBox(height: 20),
                            const Text("Injuries",
                                style: TextStyle(
                                    fontFamily: AppFonts.gabarito,
                                    fontWeight: FontWeight.bold,
                                    color: AppColours.darkBlue,
                                    fontSize: 30)),
                            if (userRole == UserRole.physio)
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        smallButton(Icons.add_circle_outline,
                                            "Add Injury", () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddInjuryScreen(
                                                      physioId: ref
                                                          .read(userIdProvider),
                                                      userRole: userRole,
                                                      teamId: ref
                                                          .read(teamIdProvider),
                                                      playerId: playerId,
                                                    )),
                                          );
                                        }),
                                      ]),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            allPlayersInjuriesData.when(
                              loading: () => const CircularProgressIndicator(),
                              error: (err, stack) => Text('Error: $err'),
                              data: (data) {
                                return injuriesSection(
                                    data.length, data, userRole, context, ref);
                              },
                            ),
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
                                    future: getStatisticsData(playerId),
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
                                        StatisticsData statistics =
                                            snapshot.data!;
                                        return statisticsSection(statistics,
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
                        ))))));
  }
}
