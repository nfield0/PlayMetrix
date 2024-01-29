import 'dart:typed_data';
import 'package:play_metrix/screens/player/player_profile_set_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

Future<String?> getTeamLeagueName(int teamId) async {
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

class PlayerInjuries {
  final int injury_id;
  final String date_of_injury;
  final String date_of_recovery;
  final int player_id;

  PlayerInjuries({
    required this.injury_id,
    required this.date_of_injury,
    required this.date_of_recovery,
    required this.player_id,
  });

  factory PlayerInjuries.fromJson(Map<String, dynamic> json) {
    return PlayerInjuries(
      injury_id: json['injury_id'],
      date_of_injury: json['date_of_injury'],
      date_of_recovery: json['date_of_recovery'],
      player_id: json['player_id'],
    );
  }

  @override
  String toString() {
    return 'PlayerInjuries{injury_id: $injury_id, date_of_injury: $date_of_injury, date_of_recovery: $date_of_recovery, player_id: $player_id}';
  }
}

Future<List<AllPlayerInjuriesData>> getAllPlayerInjuriesByUserId(
    int userId) async {
  const apiUrl =
      '$apiBaseUrl/player_injuries'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<PlayerInjuries> allPlayerInjuries =
          jsonResponse.map((json) => PlayerInjuries.fromJson(json)).toList();
      List<PlayerInjuries> playerInjuries = [];
      // loop thourgh all the injuries and get the ones that match the user id passed in
      for (var injury in allPlayerInjuries) {
        if (injury.player_id == userId) {
          playerInjuries.add(injury);
        }
      }

      List<int> injuryIds = [];
      for (var injury in playerInjuries) {
        injuryIds.add(injury.injury_id); // Corrected property name
      }

      const apiUrlForInjuries =
          '$apiBaseUrl/injuries'; // Replace with your actual backend URL and provide the user ID

      try {
        final response = await http.get(
          Uri.parse(apiUrlForInjuries),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          // Successfully retrieved data, parse and store it in individual variables
          List<dynamic> jsonResponse = jsonDecode(response.body);
          List<Injury> allInjuries =
              jsonResponse.map((json) => Injury.fromJson(json)).toList();

          List<Injury> injuriesInIdsList = [];

          for (var injury in allInjuries) {
            if (injuryIds.contains(injury.injury_id)) {
              injuriesInIdsList.add(injury);
            }
          }

          List<AllPlayerInjuriesData> allPlayerInjuriesData = [];
          for (var injury in injuriesInIdsList) {
            for (var playerInjury in playerInjuries) {
              if (injury.injury_id == playerInjury.injury_id) {
                // create a AllPlayerInjuriesData object
                AllPlayerInjuriesData data = AllPlayerInjuriesData(
                    injury.injury_id,
                    injury.injury_type,
                    injury.expected_recovery_time,
                    injury.recovery_method,
                    playerInjury.date_of_injury,
                    playerInjury.date_of_recovery,
                    playerInjury.player_id);
                allPlayerInjuriesData.add(data);
              }
            }
          }
          return allPlayerInjuriesData;
        } else {
          // Failed to retrieve data, handle the error accordingly
          print(
              'Failed to retrieve data for injuries request. Status code: ${response.statusCode}');
          print('Error message for injuries request: ${response.body}');
        }
      } catch (error) {
        // Handle any network or other errors
        print("injuries");
        print('Error in injuries request: $error');
      }
      throw Exception('Failed to retrieve Injury Data');
    } else {
      // Failed to retrieve data, handle the error accordingly
      print(
          'Failed to retrieve data for player injuries request. Status code: ${response.statusCode}');
      print(
          'Error message for player injuries request. Status code: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print("Player Injuries by user id");
    print('Error: $error');
  }
  throw Exception('Failed to retrieve All Player Injuries By User Id data');
}

void printList(List<dynamic> list) {
  for (var item in list) {
    print(item);
  }
}

class Injury {
  var injury_id;
  var injury_type;
  var expected_recovery_time;
  var recovery_method;

  Injury(
    this.injury_id,
    this.injury_type,
    this.expected_recovery_time,
    this.recovery_method,
  );

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(json['injury_id'], json['injury_type'],
        json['expected_recovery_time'], json['recovery_method']);
  }

  @override
  String toString() {
    return 'Injury{injury_id: $injury_id, injury_type: $injury_type, expected_recovery_time: $expected_recovery_time, recovery_method: $recovery_method}';
  }
}

class AllPlayerInjuriesData {
  final int injury_id;
  final String injury_type;
  final String expected_recovery_time;
  final String recovery_method;
  final String date_of_injury;
  final String date_of_recovery;
  final int player_id;

  AllPlayerInjuriesData(
    this.injury_id,
    this.injury_type,
    this.expected_recovery_time,
    this.recovery_method,
    this.date_of_injury,
    this.date_of_recovery,
    this.player_id,
  );
}

enum AvailabilityStatus { Available, Limited, Unavailable }

class AvailabilityData {
  final AvailabilityStatus status;
  final String message;
  final IconData icon;
  final Color color;

  AvailabilityData(this.status, this.message, this.icon, this.color);
}

final List<AvailabilityData> availabilityData = [
  AvailabilityData(AvailabilityStatus.Available, "Available",
      Icons.check_circle, AppColours.green),
  AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow),
  AvailabilityData(AvailabilityStatus.Unavailable, "Unavailable", Icons.cancel,
      AppColours.red)
];

class PlayerProfileScreen extends ConsumerWidget {

  final AvailabilityData available = AvailabilityData(AvailabilityStatus.Available,
      "Available", Icons.check_circle, AppColours.green);
  final AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow);
  final AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.Unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

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
                          future: getPlayerTeamProfile(ref.read(teamIdProvider),
                              ref.read(userIdProvider)),
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
                                  availability == AvailabilityStatus.Available
                                      ? available
                                      : availability ==
                                              AvailabilityStatus.Limited
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
                    FutureBuilder<List<AllPlayerInjuriesData>>(
                        future: getAllPlayerInjuriesByUserId(userId),
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
                            List<AllPlayerInjuriesData> playerInjuriesData =
                                snapshot.data!;
                            int numPlayerIds = playerInjuriesData.length;

                            return injuriesSection(
                                numPlayerIds, playerInjuriesData);
                          } else {
                            return Text('No data available');
                          }
                        }),
                    //_injuriesSection(3),
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
                                return Column(
                                  children: [
                                    statisticsDetailWithDivider(
                                        "Matches played",
                                        statistics.matchesPlayed.toString(),
                                        available),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Matches started",
                                        statistics.matchesStarted.toString(),
                                        limited),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Matches off the bench",
                                        statistics.matchesOffTheBench
                                            .toString(),
                                        unavailable),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Total minutes played",
                                        statistics.totalMinutesPlayed
                                            .toString(),
                                        unavailable),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    statisticsDetailWithDivider(
                                        "Injury Prone",
                                        statistics.injuryProne ? "Yes" : "No",
                                        null)
                                  ],
                                );
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
                        ref.read(dobProvider.notifier).state = DateTime.now();
                        ref.read(genderProvider.notifier).state = "Male";
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

Widget playerProfile(
    String firstName,
    String surname,
    int playerNumber,
    String dob,
    String height,
    String gender,
    AvailabilityData availability,
    Uint8List? profilePicture) {
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
        decoration: BoxDecoration(
          border: Border.all(
            color: availability.color, // Set the border color
            width: 5, // Set the border width
          ),
          borderRadius: BorderRadius.circular(20), // Set the border radius
        ),
        child: profilePicture != null && profilePicture.isNotEmpty
            ? Image.memory(
                profilePicture,
                width: 150,
              )
            : Image.asset(
                "lib/assets/icons/profile_placeholder.png",
                width: 150,
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
      profileDetails("Date of Birth", dob),
      const SizedBox(height: 15),
      profileDetails("Height", "${height}cm"),
      const SizedBox(height: 15),
      profileDetails("Gender", gender),
      const SizedBox(height: 35),
      availabilityTrafficLight(availability.status),
    ]),
  );
}

Widget playerProfileNoTeam(String firstName, String surname, String dob,
    String height, String gender, Uint8List? profilePicture) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      Container(
        child: profilePicture != null && profilePicture.isNotEmpty
            ? Image.memory(
                profilePicture,
                width: 150,
              )
            : Image.asset(
                "lib/assets/icons/profile_placeholder.png",
                width: 150,
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
      profileDetails("Date of Birth", dob),
      const SizedBox(height: 15),
      profileDetails("Height", "${height}cm"),
      const SizedBox(height: 15),
      profileDetails("Gender", gender),
    ]),
  );
}

Widget profileDetails(String title, String desc) {
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

Widget availabilityTrafficLight(AvailabilityStatus playerStatus) {
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
      availabilityTrafficLightItem(availability[0], playerStatus),
      availabilityTrafficLightItem(availability[1], playerStatus),
      availabilityTrafficLightItem(availability[2], playerStatus)
    ],
  );
}

Widget availabilityTrafficLightItem(
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

Widget injuriesSection(
    int numInjuries, List<AllPlayerInjuriesData> playerInjuriesData) {
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
        children: playerInjuriesData
            .map<ExpansionPanelRadio>((AllPlayerInjuriesData injury) {
          return ExpansionPanelRadio(
            value: injury.date_of_injury,
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(injury.date_of_injury,
                    style: const TextStyle(
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold)),
              );
            },
            body: ListTile(
              title: injuryDetails(injury),
            ),
          );
        }).toList(),
      ),
    ]),
  );
}

Widget injuryDetails(AllPlayerInjuriesData injury) {
  return Column(
    children: [
      greyDivider(),
      const SizedBox(height: 10),
      detailWithDivider("Date of Injury", injury.date_of_injury.toString()),
      const SizedBox(height: 10),
      detailWithDivider("Date of Recovery", injury.date_of_recovery.toString()),
      const SizedBox(height: 10),
      detailWithDivider("Injury Type", injury.injury_type),
      const SizedBox(height: 10),
      detailWithDivider(
          "Expected Recovery Time", injury.expected_recovery_time),
      const SizedBox(height: 10),
      detailWithDivider("Recovery Method", injury.recovery_method),
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
