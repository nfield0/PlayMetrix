import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/coach/coaches_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/add_player_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<PlayerData>> getAllPlayers() async {
  final apiUrl = '$apiBaseUrl/players/'; // URL for getting all players

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<PlayerData> players =
          responseData.map((json) => PlayerData.fromJson(json)).toList();

      // Access individual players
      for (var player in players) {
        print('Player ID: ${player.player_id}');
        print('Player First Name: ${player.player_firstname}');
        print('Player Surname: ${player.player_surname}');
        print('Player DOB: ${player.player_dob}');
        print('Player Contact Number: ${player.player_contact_number}');
        print('Player Image: ${player.player_image}');
        print('Player Height: ${player.player_height}');
        print('Player Gender: ${player.player_gender}');
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

class PlayersScreen extends ConsumerWidget {
  late List<PlayerData> players = [];
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
                  if (MediaQuery.of(context).size.longestSide >= 1000)
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: players.map((PlayerData player) {
                        return playerProfilePill(
                            context, // Assuming 'player_image' is an Image object
                            player.player_image.toString(),
                            player.player_firstname,
                            player.player_surname,
                            7,
                            AvailabilityStatus
                                .Available // Call a function to determine availability status
                            );
                      }).toList(),
                    )
                  else
                    Column(
                      children: players.map((PlayerData player) {
                        return playerProfilePill(
                            context, // Assuming 'player_image' is an Image object
                            player.player_image.toString(),
                            player.player_firstname,
                            player.player_surname,
                            7,
                            AvailabilityStatus
                                .Available // Call a function to determine availability status
                            );
                      }).toList(),
                    )
                ]))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 1));
  }
}

Widget playerProfilePill(
    BuildContext context,
    String imagePath,
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

  return Stack(
    clipBehavior: Clip.none,
    children: [
      InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerProfileScreen()),
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
                Image.asset(
                  imagePath,
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
  );
}
