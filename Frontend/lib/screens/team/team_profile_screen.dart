import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/coach/add_coach_screen.dart';
import 'package:play_metrix/screens/physio/add_physio_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/profile/profile_view_screen.dart';
import 'package:play_metrix/screens/team/edit_team_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
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
      team_logo: base64.decode(json['team_logo']),
      manager_id: json['manager_id'],
      sport_id: json['sport_id'],
      league_id: json['league_id'],
      team_location: json['team_location'],
    );
  }
}

Future<TeamData?> getTeamById(int id) async {
  if (id != -1) {
    final apiUrl =
        '$apiBaseUrl/teams/$id'; // Replace with your actual backend URL and provide the user ID

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
  return null;
}

Future<List<Profile>> getPhysiosForTeam(int teamId) async {
  final apiUrl = '$apiBaseUrl/team_physio/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> physiosJsonList =
          List<Map<String, dynamic>>.from(data);

      List<Profile> physios = [];

      for (Map<String, dynamic> physioJson in physiosJsonList) {
        Profile physio = await getPhysioProfile(physioJson['physio_id']);
        physios.add(physio);
      }

      return physios;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve physio data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve physio data');
  }
}

Future<List<Profile>> getCoachesForTeam(int teamId) async {
  final apiUrl = '$apiBaseUrl/team_coach/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> coachesJsonList =
          List<Map<String, dynamic>>.from(data);

      List<Profile> coaches = [];

      for (Map<String, dynamic> coachJson in coachesJsonList) {
        Profile coach = await getCoachProfile(coachJson['coach_id']);
        coaches.add(coach);
      }

      return coaches;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve physio data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve physio data');
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

final managerIdProvider = StateProvider<int>((ref) => 0);

class TeamProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBarTitlePreviousPage("Team Profile"),
                if (ref.read(userRoleProvider.notifier).state ==
                    UserRole.manager)
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
                    FutureBuilder<TeamData?>(
                        future: getTeamById(
                            ref.read(teamIdProvider.notifier).state),
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
                            String teamLocation = team.team_location;
                            int managerId = team.manager_id;
                            Uint8List? logo = team.team_logo;
                            Future.microtask(() {
                              ref.read(managerIdProvider.notifier).state =
                                  managerId;
                            });
                            return Column(children: [
                              Text(
                                teamName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.gabarito,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 50),
                              logo != null && logo.isNotEmpty
                                  ? Image.memory(
                                      logo,
                                      width: 150,
                                    )
                                  : Image.asset(
                                      "lib/assets/icons/logo_placeholder.png",
                                      width: 150,
                                    ),
                              // const SizedBox(height: 40),
                              // smallPill("Senior Football"),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.pin_drop,
                                      color: Colors.red, size: 28),
                                  const SizedBox(width: 10),
                                  Text(teamLocation,
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              FutureBuilder(
                                  future: getTeamLeagueName(
                                      ref.read(teamIdProvider.notifier).state),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Display a loading indicator while the data is being fetched
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // Display an error message if the data fetching fails
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      return Text(snapshot.data.toString(),
                                          style: const TextStyle(fontSize: 18));
                                    } else {
                                      return const Text('No data available');
                                    }
                                  }),
                              const SizedBox(height: 20),
                              divider(),
                              FutureBuilder(
                                  future: getManagerProfile(managerId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Display a loading indicator while the data is being fetched
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // Display an error message if the data fetching fails
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      Profile manager = snapshot.data!;
                                      return Column(children: [
                                        const Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "Manager",
                                                style: TextStyle(
                                                    color: AppColours.darkBlue,
                                                    fontFamily:
                                                        AppFonts.gabarito,
                                                    fontSize: 28,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        profilePill(
                                            "${manager.firstName} ${manager.surname}",
                                            manager.email,
                                            "lib/assets/icons/profile_placeholder.png",
                                            manager.imageBytes, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileViewScreen(
                                                      userId: manager.id,
                                                      userRole:
                                                          UserRole.manager,
                                                    )),
                                          );
                                        }),
                                        const SizedBox(height: 20),
                                      ]);
                                    } else {
                                      return Text('No data available');
                                    }
                                  })
                            ]);
                          } else {
                            return Text('No data available');
                          }
                        }),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
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
                          if (ref.read(userRoleProvider.notifier).state ==
                              UserRole.manager)
                            smallButton(Icons.person_add, "Add", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPhysioScreen()),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: getPhysiosForTeam(
                            ref.read(teamIdProvider.notifier).state),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            List<Profile> physios =
                                snapshot.data as List<Profile>;
                            return physios.isNotEmpty
                                ? Column(
                                    children: [
                                      for (Profile physio in physios)
                                        profilePill(
                                            "${physio.firstName} ${physio.surname}",
                                            physio.email,
                                            "lib/assets/icons/profile_placeholder.png",
                                            physio.imageBytes, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileViewScreen(
                                                      userId: physio.id,
                                                      userRole: UserRole.physio,
                                                    )),
                                          );
                                        }),
                                    ],
                                  )
                                : emptySection(
                                    Icons.person_off, "No physios added yet");
                          } else {
                            return const Text('No data available');
                          }
                        }),
                    const SizedBox(height: 20),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
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
                          if (ref.read(userRoleProvider.notifier).state ==
                              UserRole.manager)
                            smallButton(Icons.person_add, "Add", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCoachScreen()),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: getCoachesForTeam(
                            ref.read(teamIdProvider.notifier).state),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            List<Profile> coaches =
                                snapshot.data as List<Profile>;
                            return coaches.isNotEmpty
                                ? Column(
                                    children: [
                                      for (Profile coach in coaches)
                                        profilePill(
                                            "${coach.firstName} ${coach.surname}",
                                            coach.email,
                                            "lib/assets/icons/profile_placeholder.png",
                                            coach.imageBytes, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileViewScreen(
                                                      userId: coach.id,
                                                      userRole: UserRole.coach,
                                                    )),
                                          );
                                        }),
                                    ],
                                  )
                                : emptySection(
                                    Icons.person_off, "No coaches added yet");
                          } else {
                            return const Text('No data available');
                          }
                        }),
                    const SizedBox(height: 50),
                  ],
                ),
              ))),
      bottomNavigationBar: managerBottomNavBar(context, 0),
    );
  }
}
