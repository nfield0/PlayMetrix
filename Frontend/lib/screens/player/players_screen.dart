import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/coach/coaches_screen.dart';
import 'package:play_metrix/screens/player/add_player_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerData {
  final int player_id;
  final String player_firstname;
  final String player_surname;
  final String player_dob;
  final String player_contact_number;
  final String player_image;
  final String player_height;
  final String player_gender;

  PlayerData({
    required this.player_id,
    required this.player_firstname,
    required this.player_surname,
    required this.player_dob,
    required this.player_contact_number,
    required this.player_image,
    required this.player_height,
    required this.player_gender,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      player_id: json['player_id'],
      player_firstname: json['player_firstname'],
      player_surname: json['player_surname'],
      player_dob: json['player_dob'],
      player_contact_number: json['player_contact_number'],
      player_image: json['player_image'],
      player_height: json['player_height'],
      player_gender: json['player_gender'],
    );
  }
}

Future<List<PlayerData>> getAllPlayers() async {
  final apiUrl = 'http://127.0.0.1:8000/players'; // URL for getting all players

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
                                const CoachesScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }),
                    ]),
                  const SizedBox(height: 10),
                  profilePill("Louth GAA", "Senior Football",
                      "lib/assets/icons/logo_placeholder.png", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeamProfileScreen()),
                    );
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
                                builder: (context) => const AddPlayerScreen()),
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
                            player.player_image,
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
                            player.player_image,
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
