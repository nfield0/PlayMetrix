import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/coach/coaches_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/add_player_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/player_profile_view_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

AvailabilityStatus stringToAvailabilityStatus(String status) {
  switch (status) {
    case "Available":
      return AvailabilityStatus.Available;
    case "Unavailable":
      return AvailabilityStatus.Unavailable;
    case "Limited":
      return AvailabilityStatus.Limited;
  }
  return AvailabilityStatus.Available;
}

class PlayerProfile {
  final int playerId;
  final String firstName;
  final String surname;
  final String dob;
  final String gender;
  final String height;
  final int teamNumber;
  final AvailabilityStatus status;
  final Uint8List? imageBytes;

  PlayerProfile(this.playerId, this.firstName, this.surname, this.dob,
      this.gender, this.height, this.teamNumber, this.status, this.imageBytes);
}

Future<List<PlayerProfile>> getAllPlayersForTeam(int teamId) async {
  final apiUrl = '$apiBaseUrl/team_player/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final List<Map<String, dynamic>> playersJsonList =
          List<Map<String, dynamic>>.from(responseData);

      List<PlayerProfile> players = [];

      for (Map<String, dynamic> playerJson in playersJsonList) {
        PlayerData player = await getPlayerById(playerJson['player_id']);

        players.add(PlayerProfile(
            player.player_id,
            player.player_firstname,
            player.player_surname,
            "${player.player_dob.toLocal()}".split(' ')[0],
            player.player_gender,
            player.player_height,
            playerJson['player_team_number'],
            stringToAvailabilityStatus(playerJson['playing_status']),
            player.player_image));
      }

      return players;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load players');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load players');
  }
}

Future<PlayerProfile> getPlayerTeamProfile(int teamId, int playerId) async {
  final apiUrl = '$apiBaseUrl/team_player/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final List<Map<String, dynamic>> playersJsonList =
          List<Map<String, dynamic>>.from(responseData);

      for (Map<String, dynamic> playerJson in playersJsonList) {
        if (playerJson['player_id'] == playerId) {
          PlayerData player = await getPlayerById(playerJson['player_id']);
          PlayerProfile playerProfile = PlayerProfile(
              playerJson['player_id'],
              player.player_firstname,
              player.player_surname,
              "${player.player_dob.toLocal()}".split(' ')[0],
              player.player_gender,
              player.player_height,
              playerJson['player_team_number'],
              stringToAvailabilityStatus(playerJson['playing_status']),
              player.player_image);
          return playerProfile;
        }
      }
      throw Exception('Player not found');
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load players');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load players');
  }
}

class PlayersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole userRole = ref.watch(userRoleProvider);

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
                padding: const EdgeInsets.only(top: 20, right: 35, left: 35),
                child: Column(children: [
                  if (userRole == UserRole.manager)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.sync_alt,
                          color: AppColours.darkBlue, size: 24),
                      underlineButtonTransparent("Switch to Coaches", () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                CoachesScreen(),
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
                        "Players",
                        style: TextStyle(
                          fontFamily: AppFonts.gabarito,
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      if (userRole == UserRole.manager)
                        smallButton(Icons.person_add, "Add", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPlayerScreen()),
                          );
                        })
                    ],
                  ),
                  const SizedBox(height: 35),
                  FutureBuilder(
                      future: getAllPlayersForTeam(
                          ref.read(teamIdProvider.notifier).state),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<PlayerProfile> players = snapshot.data!;

                          return players.isNotEmpty
                              ? MediaQuery.of(context).size.longestSide >= 1000
                                  ? Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 20.0,
                                      runSpacing: 20.0,
                                      children:
                                          players.map((PlayerProfile player) {
                                        return playerProfilePill(
                                          context,
                                          player.imageBytes,
                                          player.playerId,
                                          player.firstName,
                                          player.surname,
                                          player.teamNumber,
                                          player.status,
                                        );
                                      }).toList(),
                                    )
                                  : Column(
                                      children:
                                          players.map((PlayerProfile player) {
                                        return playerProfilePill(
                                          context,
                                          player.imageBytes,
                                          player.playerId,
                                          player.firstName,
                                          player.surname,
                                          player.teamNumber,
                                          player.status,
                                        );
                                      }).toList(),
                                    )
                              : emptySection(
                                  Icons.person_off, "No players added yet");
                        } else {
                          return emptySection(Icons.group_off, "No team yet");
                        }
                      }),
                ]))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 1));
  }
}

Widget playerProfilePill(
    BuildContext context,
    Uint8List? imageBytes,
    int playerId,
    String firstName,
    String surname,
    int playerNum,
    AvailabilityStatus status) {
  Color statusColour = AppColours.green;
  IconData statusIcon = Icons.check_circle;
  switch (status) {
    case AvailabilityStatus.Available:
      statusColour = AppColours.green;
      statusIcon = Icons.check_circle;
      break;
    case AvailabilityStatus.Unavailable:
      statusColour = AppColours.red;
      statusIcon = Icons.cancel;
      break;
    case AvailabilityStatus.Limited:
      statusColour = AppColours.yellow;
      statusIcon = Icons.warning;
      break;
  }

  return Column(children: [
    Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlayerProfileViewScreen(userId: playerId)),
              );
            },
            child: Container(
              // width: MediaQuery.of(context).size.longestSide >= 900 ? 500 : null,
              decoration: BoxDecoration(
                border: Border.all(color: statusColour, width: 4),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  imageBytes != null && imageBytes.isNotEmpty
                      ? Image.memory(
                          imageBytes,
                          width: 65,
                        )
                      : Image.asset(
                          "lib/assets/icons/profile_placeholder.png",
                          width: 65,
                        ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    "#$playerNum",
                    style: TextStyle(
                      color: statusColour,
                      fontSize: 36,
                      fontFamily: AppFonts.gabarito,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: AppFonts.gabarito,
                        ),
                      ),
                      Text(
                        surname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: AppFonts.gabarito,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Positioned(
          top: -10,
          right: -10,
          child: Container(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Color(0XFFfafafa),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColour,
              size: 40,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 20),
  ]);
}
