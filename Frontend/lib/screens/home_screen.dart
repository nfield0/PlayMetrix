import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/notifications_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerData {
  final int player_id;
  final String player_firstname;
  final String player_surname;
  final DateTime player_dob;
  final String player_contact_number;
  final Uint8List? player_image;
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
      player_dob: DateTime.parse(json['player_dob']),
      player_contact_number: json['player_contact_number'],
      player_image: base64.decode(json['player_image']),
      player_height: json['player_height'],
      player_gender: json['player_gender'],
    );
  }
}

Future<PlayerData> getPlayerById(int id) async {
  final apiUrl =
      '$apiBaseUrl/players/info/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      PlayerData player = PlayerData.fromJson(jsonDecode(response.body));

      return player;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print("user");
    print('Error: $error');
  }
  throw Exception('Failed to retrieve player data');
}

Future<Profile> getProfileDetails(int userId, UserRole userRole) async {
  if (userRole == UserRole.manager) {
    return await getManagerProfile(userId);
  } else if (userRole == UserRole.physio) {
    return await getPhysioProfile(userId);
  } else if (userRole == UserRole.coach) {
    return await getCoachProfile(userId);
  } else if (userRole == UserRole.player) {
    return await getPlayerProfile(userId);
  }

  return Profile(
      -1, "firstName", "surname", "contactNumber", "email", Uint8List(0));
}

class HomeScreen extends ConsumerWidget {
  int selectedMenuIndex = 0;
  late Profile profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    return FutureBuilder<Profile>(
        future: getProfileDetails(userId, userRole),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            profile = snapshot.data!;

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
                padding: const EdgeInsets.only(top: 30, right: 35, left: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          smallPill(userRoleText(userRole)),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const NotificationsScreen(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.notifications,
                              color: AppColours.darkBlue,
                              size: 32,
                            ),
                          )
                        ]),
                    const SizedBox(height: 40),
                    Text(
                      "Hey, ${profile.firstName}!",
                      style: TextStyle(
                        fontFamily: AppFonts.gabarito,
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _menu(userRole, context)
                  ],
                ),
              )),
              bottomNavigationBar:
                  roleBasedBottomNavBar(userRole, context, selectedMenuIndex),
            );
          } else {
            return Text('No data available');
          }
        });
  }

  Widget _buildMenuItem(
      String text, String imagePath, Color colour, VoidCallback onPressed) {
    return InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          decoration: BoxDecoration(
            // color: AppColours.darkBlue,
            border: Border.all(color: colour, width: 5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
              Flexible(
                child: Wrap(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: colour,
                        fontFamily: AppFonts.gabarito,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _menu(UserRole userRole, BuildContext context) {
    switch (userRole) {
      case UserRole.manager:
        return _managerMenu(context);
      case UserRole.coach:
        return _coachMenu(context);
      case UserRole.player:
        return _playerMenu(context);
      case UserRole.physio:
        return _physioMenu(context);
    }
  }

  Widget _coachMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Players', 'lib/assets/icons/players_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
          AppColours.mediumBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }

  Widget _playerMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Statistics', 'lib/assets/icons/statistics_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
          AppColours.mediumBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/players_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                PlayerProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }

  Widget _physioMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Players & Coaches', 'lib/assets/icons/players_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }

  Widget _managerMenu(BuildContext context) {
    return Column(children: [
      _buildMenuItem('Players & Coaches', 'lib/assets/icons/players_menu.png',
          AppColours.mediumDarkBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
          AppColours.mediumBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
      const SizedBox(height: 20),
      _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
          AppColours.lightBlue, () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }),
    ]);
  }
}
