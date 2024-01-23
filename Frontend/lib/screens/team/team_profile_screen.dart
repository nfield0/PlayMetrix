import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/physio/add_physio_screen.dart';
import 'package:play_metrix/screens/team/edit_team_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class TeamData {
  final int team_id;
  final String team_name;
  final Uint8List? team_logo;
  final int manager_id;
  final int league_id;
  final int sport_id;
  final String team_location;

  TeamData({
    required this.team_id,
    required this.team_name,
    required this.team_logo,
    required this.manager_id,
    required this.sport_id,
    required this.league_id,
    required this.team_location,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      team_id: json['team_id'],
      team_name: json['team_name'],
      team_logo: json['team_logo'],
      manager_id: json['manager_id'],
      sport_id: json['sport_id'],
      league_id: json['league_id'],
      team_location: json['team_location'],
    );
  }
}

Future<TeamData> getTeamById(int id) async {
  final apiUrl = 'http://127.0.0.1:8000/teams/info/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      TeamData teamData = TeamData.fromJson(jsonDecode(response.body));

      // Access individual variables
      print('${teamData.team_id}');
      print('${teamData.team_name}');
      print('${teamData.team_logo}');
      print('${teamData.manager_id}');
      print('${teamData.sport_id}');
      print('${teamData.league_id}');
      print('${teamData.team_location}');
      return teamData;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve team data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve team data');
  }
}

class ManagerData {
  final String manager_email;
  final String manager_password;
  final String manager_firstname;
  final String manager_surname;
  final String manager_contact_number;
  final Uint8List? manager_image;

  ManagerData({
    required this.manager_email,
    required this.manager_password,
    required this.manager_firstname,
    required this.manager_surname,
    required this.manager_contact_number,
    required this.manager_image,
  });

  factory ManagerData.fromJson(Map<String, dynamic> json) {
    return ManagerData(
      manager_email: json['manager_email'],
      manager_password: json['manager_password'],
      manager_firstname: json['manager_firstname'],
      manager_surname: json['manager_surname'],
      manager_contact_number: json['manager_contact_number'],
      manager_image: json['manager_image'],
    );
  }
}

Future<ManagerData> getManagerById(int managerID) async {
  final apiUrl = 'http://127.0.0.1:8000/teams/info/$managerID'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      ManagerData managerData = ManagerData.fromJson(jsonDecode(response.body));

      
      return managerData;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve team data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve team data');
  }
}

// class TeamProfileScreen extends ConsumerWidget {
//   const TeamProfileScreen({Key? key}) : super(key: key);

//   @override
//   _TeamProfileScreenState createState() => _TeamProfileScreenState();

// }

final managerIdProvider = StateProvider<int>((ref) => 0);

class TeamProfileScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;
    final teamId = ref.watch(teamIdProvider.notifier).state;
    final managerId = ref.watch(managerIdProvider.notifier).state;
    final division = ref.watch(divisionProvider.notifier).state;
    Uint8List? profilePicture = ref.watch(profilePictureProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBarTitlePreviousPage("Team Profile"),
                smallButton(Icons.edit, "Edit", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditTeamScreen()),
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
                child: Column(
                  children: [
                     FutureBuilder<TeamData>(
                        future: getTeamById(teamId),
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
                            int managerId = team.manager_id;
                            ref.read(managerIdProvider.notifier).state = managerId;
                            return Text(
                                        teamName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: AppFonts.gabarito,
                                          fontSize: 32,
                                        ),
                                      );
                          } else {
                            return Text('No data available');
                          }
                        }),
                
                    const SizedBox(height: 50),
                    Image.asset(
                      'lib/assets/icons/logo_placeholder.png',
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    smallPill("Senior Football"),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pin_drop, color: Colors.red, size: 28),
                        SizedBox(width: 10),
                        Text("Louth", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Divison 1", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    divider(),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Manager",
                            style: TextStyle(
                                color: AppColours.darkBlue,
                                fontFamily: AppFonts.gabarito,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<ManagerData>(
                        future: getManagerById(managerId),
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
                            ManagerData manager = snapshot.data!;
                            String manager_firstname = manager.manager_firstname;
                            String manager_contact_number = manager.manager_contact_number;

                            ref.read(managerIdProvider.notifier).state = managerId;
                            return profilePill(manager_firstname, manager_contact_number,
                        "lib/assets/icons/profile_placeholder.png", () {});
                          } else {
                            return Text('No data available');
                          }
                        }),
                   
                    const SizedBox(height: 20),
                    divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
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
                          smallButton(Icons.person_add, "Add", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddPhysioScreen()),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    profilePill("Sophia Bloggs", "sophiabloggs@louthgaa.com",
                        "lib/assets/icons/profile_placeholder.png", () {}),
                    const SizedBox(height: 20),
                    divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
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
                          smallButton(Icons.person_add, "Add", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddCoachScreen()),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    emptySection(Icons.person_off, "No coaches added yet"),
                    const SizedBox(height: 50),
                    
                  ],
                ),
              ))),
      bottomNavigationBar: managerBottomNavBar(context, 0),
    );
  }
}
