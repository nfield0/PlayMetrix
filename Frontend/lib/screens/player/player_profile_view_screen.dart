import 'dart:typed_data';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class PlayerProfileViewScreen extends ConsumerWidget {
  final int userId;

  PlayerProfileViewScreen({super.key, required this.userId});

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
    return await getAllPlayerInjuriesByUserId(ref.read(userIdProvider));
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    AsyncValue<List<AllPlayerInjuriesData>> allPlayersInjuriesData =
        ref.watch(allPlayerInjuriesProvider);

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
                          builder: (context) => EditPlayerProfileScreen(
                                userRole: userRole,
                                playerId: userId,
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
                    allPlayersInjuriesData.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text('Error: $err'),
                      data: (data) {
                        return injuriesSection(data.length, data, userRole);
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
                                return statisticsSection(statistics, available,
                                    limited, unavailable);
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
