import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'dart:convert';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

final teamIdProvider = StateProvider<int>((ref) => -1);

class SportData {
  final int sport_id;
  final String sport_name;

  SportData({
    required this.sport_id,
    required this.sport_name,
  });

  factory SportData.fromJson(Map<String, dynamic> json) {
    return SportData(
      sport_id: json['sport_id'],
      sport_name: json['sport_name'],
    );
  }
}

Future<int> getFirstSportId() async {
  const apiUrl = '$apiBaseUrl/sports';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully retrieved data from the backend
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> sportJsonList =
          List<Map<String, dynamic>>.from(data);

      final List<SportData> sports =
          sportJsonList.map((json) => SportData.fromJson(json)).toList();

      return sports[0].sport_id;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to get data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load sports');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load sports');
  }
}

Future<List<TeamData>> getAllTeams() async {
  const apiUrl = '$apiBaseUrl/teams';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully retrieved data from the backend
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> teamJsonList =
          List<Map<String, dynamic>>.from(data);

      final List<TeamData> teams =
          teamJsonList.map((json) => TeamData.fromJson(json)).toList();

      for (var team in teams) {
        print('Team Name: ${team.team_name}');
      }

      return teams;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to get data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load teams');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load teams');
  }
}

enum TeamRole { defense, attack, midfield, goalkeeper, headCoach }

String teamRoleToText(TeamRole role) {
  switch (role) {
    case TeamRole.defense:
      return 'Defense';
    case TeamRole.attack:
      return 'Attack';
    case TeamRole.midfield:
      return 'Midfield';
    case TeamRole.goalkeeper:
      return 'Goalkeeper';
    case TeamRole.headCoach:
      return 'Head Coach';
  }
}

Future<List<LeagueData>> getAllLeagues() async {
  final apiUrl = '$apiBaseUrl/leagues/';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully retrieved data from the backend
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> teamJsonList =
          List<Map<String, dynamic>>.from(data);

      final List<LeagueData> leagues =
          teamJsonList.map((json) => LeagueData.fromJson(json)).toList();

      return leagues;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to get data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load leagues.');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load leagues');
  }
}

class AddTeamData {
  final String team_name;
  final Uint8List? team_logo;
  final int manager_id;
  final int league_id;
  final int sport_id;
  final String team_location;

  AddTeamData({
    required this.team_name,
    required this.team_logo,
    required this.manager_id,
    required this.sport_id,
    required this.league_id,
    required this.team_location,
  });
}

Future<int> addTeam(String teamName, Uint8List? imageBytes, int managerId,
    int sportId, int leagueId, String teamLocation) async {
  final apiUrl = '$apiBaseUrl/teams/';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'team_name': teamName,
        'team_logo': imageBytes != null ? base64Encode(imageBytes) : "",
        'manager_id': managerId,
        'sport_id': sportId,
        'league_id': leagueId,
        'team_location': teamLocation,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      print("Team added successfully");
      return jsonDecode(response.body)["id"];
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

final leagueProvider = StateProvider<int>((ref) => 0);
final teamLogoProvider = StateProvider<Uint8List?>((ref) => null);

class TeamSetUpScreen extends ConsumerWidget {
  String selectedDivisionValue = "Division 1";

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        ref.read(teamLogoProvider.notifier).state =
            Uint8List.fromList(imageBytes);
      }
    }

    int userId = ref.watch(userIdProvider.notifier).state;
    int leagueId = ref.watch(leagueProvider);
    Uint8List? logo = ref.watch(teamLogoProvider);

    return Scaffold(
        appBar: AppBar(
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
          child: Form(
              child: Container(
            padding: EdgeInsets.all(35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Team Set Up',
                    style: TextStyle(
                      color: AppColours.darkBlue,
                      fontFamily: AppFonts.gabarito,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w700,
                    )),
                const Divider(
                  color: AppColours.darkBlue,
                  thickness: 1.0, // Set the thickness of the line
                  height: 40.0, // Set the height of the line
                ),
                const SizedBox(height: 20),
                Center(
                    child: Column(children: [
                  logo != null
                      ? Image.memory(
                          logo,
                          width: 100,
                        )
                      : Image.asset(
                          "lib/assets/icons/logo_placeholder.png",
                          width: 100,
                        ),
                  const SizedBox(height: 10),
                  underlineButtonTransparent("Upload logo", () {
                    pickImage();
                  }),
                ])),
                // formFieldBottomBorder("Club name", ""), // NOT IN BACKEND ENDPOINT
                // const SizedBox(height: 10),
                formFieldBottomBorderController(
                    "Team name", _teamNameController, (value) {
                  return "";
                }),
                const SizedBox(height: 10),
                formFieldBottomBorderController(
                    "Location", _teamLocationController, (value) {
                  return "";
                }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "League",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      // Wrap the DropdownButtonFormField with a Container
                      width: 220, // Provide a specific width
                      child: FutureBuilder<List<LeagueData>>(
                        future: getAllLeagues(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<LeagueData> leagues = snapshot.data!;
                            // Initialize the selectedTeam with the first team name
                            if (leagueId == 0 && leagues.isNotEmpty) {
                              leagueId = leagues[0].league_id;
                              Future.delayed(Duration.zero, () {
                                ref.read(leagueProvider.notifier).state =
                                    leagueId;
                              });
                            }

                            return DropdownButton<int>(
                              value: leagueId,
                              items: leagues.map((LeagueData league) {
                                return DropdownMenuItem<int>(
                                  value: league.league_id,
                                  child: Text(
                                    league.league_name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // Update the selectedTeam when the user makes a selection
                                ref.read(leagueProvider.notifier).state =
                                    value!;
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error loading leagues");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                bigButton("Save Changes", () async {
                  int teamId = await addTeam(
                      _teamNameController.text,
                      ref.read(teamLogoProvider.notifier).state,
                      userId,
                      await getFirstSportId(),
                      leagueId,
                      _teamLocationController.text);
                  ref.read(teamIdProvider.notifier).state = teamId;
                  if (teamId != -1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    _teamNameController.clear();
                    _teamLocationController.clear();
                    ref.read(teamLogoProvider.notifier).state = null;
                  }
                })
              ],
            ),
          )),
        ));
  }
}
