import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

Future<PlayerData> getPlayerById(int id) async {
  print('Player ID in home page: $id');
  final apiUrl =
      'http://127.0.0.1:8000/players/info/$id'; // Replace with your actual backend URL and provide the user ID

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
    

      // Access individual variables
      print('${player.player_id}');
      print('${player.player_firstname}');
      print('${player.player_surname}');
      print('${player.player_dob}');
      print('${player.player_contact_number}');
      print('${player.player_image}');
      print('${player.player_height}');
      print('${player.player_gender}');
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

class TeamData {
  final int team_id;
  final String team_name;
  final Image team_logo;
  final String manager_id;
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

Future<TeamData> getTeamById(String id) async {
  final apiUrl =
      'http:/127.0.0.1:8000/teams/info/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final teamData = TeamData.fromJson(responseData);

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

class LeagueData {
  final int league_id;
  final String league_name;

  LeagueData({
    required this.league_id,
    required this.league_name,
  });

  factory LeagueData.fromJson(Map<String, dynamic> json) {
    return LeagueData(
      league_id: json['league_id'],
      league_name: json['league_name'],
    );
  }
}

Future<List<LeagueData>> getLeagues() async {
  final apiUrl = 'http://127.0.0.1:8000/leagues/';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<LeagueData> leagues =
          responseData.map((json) => LeagueData.fromJson(json)).toList();

      // Access individual variables
      for (var league in leagues) {
        print('League ID: ${league.league_id}');
        print('League Name: ${league.league_name}');
      }

      return leagues;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load leagues');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load leagues');
  }
}

Future<String?> getTeamLeagueName(String teamId) async {
  try {
    final TeamData? teamData = await getTeamById(teamId);
    final List<LeagueData> leagues = await getLeagues();

    for (var league in leagues) {
      if (teamData?.league_id == league.league_id) {
        return league.league_name;
      }
    }

    return null; // If league not found
  } catch (error) {
    print('Error: $error');
    return null;
  }
}

enum AvailabilityStatus { Available, Limited, Unavailable }

class AvailabilityData {
  final AvailabilityStatus status;
  final String message;
  final IconData icon;
  final Color color;

  AvailabilityData(this.status, this.message, this.icon, this.color);
}



class PlayerProfileScreen extends ConsumerWidget {
  late PlayerData player;
  late Future<String?> leagueName;

  AvailabilityData available = AvailabilityData(AvailabilityStatus.Available,
      "Available", Icons.check_circle, AppColours.green);
  AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow);
  AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.Unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    //leagueName = getTeamLeagueName(teamData.league_id.toString());
    
      

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: userRole == UserRole.player ? false : true,
          title: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Player Profile",
                      style: TextStyle(
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  smallButton(Icons.edit, "Edit", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPlayerProfileScreen()),
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
                     FutureBuilder<PlayerData>(
                      future: getPlayerById(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Display a loading indicator while the data is being fetched
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Display an error message if the data fetching fails
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Data has been successfully fetched, use it here
                        PlayerData player = snapshot.data!;
                        String first_name = player.player_firstname;
                        String second_name = player.player_surname;
                        String dob = player.player_dob;
                        String height = player.player_height;
                        String gender = player.player_height;
                        return _playerProfile(
                        first_name,
                        second_name,
                        7,
                        dob,
                        height,
                        gender,
                        limited);
                        }
                        else{ return Text('No data available'); }}),
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
                    profilePill("teamData.team_name", "leagueName.toString()",
                        "lib/assets/icons/logo_placeholder.png", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeamProfileScreen()),
                      );
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
                    _injuriesSection(3),
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
                        child: statistics(Statistics(10, 4, 6, 230, 3))),
                    const SizedBox(height: 20),
                    if (userRole == UserRole.player)
                      bigButton("Log Out", () {
                        ref.read(userRoleProvider.notifier).state =
                            UserRole.manager;
                        ref.read(userIdProvider.notifier).state = 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingScreen()),
                        );
                      }),
                    const SizedBox(height: 25),
                  ]),
                ))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 3));
        
  }
  
}

Widget _playerProfile(String firstName, String surname, int playerNumber,
    String dob, String height, String gender, AvailabilityData availability) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
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
        child:
            Image.asset("lib/assets/icons/profile_placeholder.png", width: 150),
        decoration: BoxDecoration(
          border: Border.all(
            color: availability.color, // Set the border color
            width: 5, // Set the border width
          ),
          borderRadius: BorderRadius.circular(20), // Set the border radius
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
      _profileDetails("Date of Birth", dob),
      const SizedBox(height: 15),
      _profileDetails("Height", "${height}cm"),
      const SizedBox(height: 15),
      _profileDetails("Gender", gender),
      const SizedBox(height: 35),
      _availabilityTrafficLight(availability.status),
    ]),
  );
}

Widget _profileDetails(String title, String desc) {
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

Widget _availabilityTrafficLight(AvailabilityStatus playerStatus) {
  List<AvailabilityData> availability = [
    AvailabilityData(AvailabilityStatus.Available, "Available",
        Icons.check_circle, AppColours.green),
    AvailabilityData(AvailabilityStatus.Limited, "Limited", Icons.warning,
        AppColours.yellow),
    AvailabilityData(AvailabilityStatus.Unavailable, "Unavailable",
        Icons.cancel, AppColours.red)
  ];
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _availabilityTrafficLightItem(availability[0], playerStatus),
      _availabilityTrafficLightItem(availability[1], playerStatus),
      _availabilityTrafficLightItem(availability[2], playerStatus)
    ],
  );
}

Widget _availabilityTrafficLightItem(
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

Widget _injuriesSection(int numInjuries) {
  List<Injury> _data = [
    Injury("10/04/2022", "10/05/2022", "Hamstring", "4 weeks", "Physio"),
    Injury(
        "11/05/2023", "29/07/2023", "Hamstring", "4 weeks", "Light exercise"),
    Injury("31/10/2023", "-", "Hamstring", "6 weeks", "Physio")
  ];

  return Container(
    child: Column(children: [
      Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Number of Injuries",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                numInjuries.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      ExpansionPanelList.radio(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.all(0),
        children: _data.map<ExpansionPanelRadio>((Injury injury) {
          return ExpansionPanelRadio(
            value: injury.dateOfInjury,
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(injury.dateOfInjury,
                    style: const TextStyle(
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold)),
              );
            },
            body: ListTile(
              title: _injuryDetails(injury),
            ),
          );
        }).toList(),
      ),
    ]),
  );
}

class Injury {
  var dateOfInjury;
  var dateOfRecovery;
  var injuryType;
  var expectedRecoveryTime;
  var recoveryMethod;

  Injury(
    this.dateOfInjury,
    this.dateOfRecovery,
    this.injuryType,
    this.expectedRecoveryTime,
    this.recoveryMethod,
  );
}

Widget _injuryDetails(Injury injury) {
  return Column(
    children: [
      greyDivider(),
      const SizedBox(height: 10),
      detailWithDivider("Date of Injury", injury.dateOfInjury),
      const SizedBox(height: 10),
      detailWithDivider("Date of Recovery", injury.dateOfRecovery),
      const SizedBox(height: 10),
      detailWithDivider("Injury Type", injury.injuryType),
      const SizedBox(height: 10),
      detailWithDivider("Expected Recovery Time", injury.expectedRecoveryTime),
      const SizedBox(height: 10),
      detailWithDivider("Recovery Method", injury.recoveryMethod),
      underlineButtonTransparent("View player report", () {})
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

Widget statistics(Statistics statistics) {
  return Column(
    children: [
      detailWithDivider("Matches played", statistics.matchesPlayed.toString()),
      const SizedBox(height: 10),
      detailWithDivider(
          "Matches started", statistics.matchesStarted.toString()),
      const SizedBox(height: 10),
      detailWithDivider(
          "Matches off bench", statistics.matchesOffBench.toString()),
      const SizedBox(height: 10),
      detailWithDivider(
          "Total minutes played", statistics.totalMinutesPlayed.toString()),
      const SizedBox(height: 10),
      detailWithDivider(
          "Number of injuries", statistics.numInjuries.toString()),
    ],
  );
}
