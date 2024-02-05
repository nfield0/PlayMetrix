import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Schedule {
  int schedule_id;
  String schedule_title;
  String schedule_location;
  String schedule_type;
  String schedule_start_time;
  String schedule_end_time;
  String schedule_alert_time;

  Schedule(
      {required this.schedule_id,
      required this.schedule_title,
      required this.schedule_location,
      required this.schedule_type,
      required this.schedule_start_time,
      required this.schedule_end_time,
      required this.schedule_alert_time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        schedule_id: json['schedule_id'],
        schedule_title: json['schedule_title'],
        schedule_location: json['schedule_location'],
        schedule_type: json['schedule_type'],
        schedule_start_time: json['schedule_start_time'],
        schedule_end_time: json['schedule_end_time'],
        schedule_alert_time: json['schedule_alert_time']);
  }
}

Future<Schedule> getScheduleById(int scheduleId) async {
  final apiUrl = '$apiBaseUrl/schedules/$scheduleId';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print('Get schedule successful!');

      Schedule schedule = Schedule.fromJson(jsonDecode(response.body));
      return schedule;
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
  throw Exception('Failed to load schedule data');
}

Future<Map<PlayerAttendingStatus, List<PlayerProfile>>>
    getPlayersAttendanceForSchedule(int scheduleId, int teamId) async {
  final String apiUrl = '$apiBaseUrl/player_schedules/$scheduleId';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print('Get players attending successful!');

      final List<dynamic> responseData = jsonDecode(response.body);

      // Create a map to store players based on their attending status
      Map<PlayerAttendingStatus, List<PlayerProfile>> playersByStatus = {
        PlayerAttendingStatus.present: [],
        PlayerAttendingStatus.absent: [],
        PlayerAttendingStatus.undecided: [],
      };

      for (Map<String, dynamic> playerJson in responseData) {
        PlayerProfile player =
            await getPlayerTeamProfile(teamId, playerJson['player_id']);
        if (playerJson['player_attending'] == true) {
          playersByStatus[PlayerAttendingStatus.present]!.add(player);
        } else if (playerJson['player_attending'] == false) {
          playersByStatus[PlayerAttendingStatus.absent]!.add(player);
        } else {
          playersByStatus[PlayerAttendingStatus.undecided]!.add(player);
        }
      }

      return playersByStatus;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw Exception('Failed to retrieve players attendance data');
}

class PlayersAttendingScreen extends StatefulWidget {
  final int scheduleId;
  final int teamId;

  const PlayersAttendingScreen(
      {super.key, required this.scheduleId, required this.teamId});

  @override
  PlayersAttendingScreenState createState() => PlayersAttendingScreenState();
}

class PlayersAttendingScreenState extends State<PlayersAttendingScreen> {
  late Schedule schedule;
  late List<PlayerProfile> playersAttending = [];
  late List<PlayerProfile> playersNotAttending = [];
  late List<PlayerProfile> playersUndecided = [];

  @override
  void initState() {
    super.initState();
    getPlayersAttendanceForSchedule(widget.scheduleId, widget.teamId)
        .then((value) {
      setState(() {
        playersAttending = value[PlayerAttendingStatus.present]!;
        playersNotAttending = value[PlayerAttendingStatus.absent]!;
        playersUndecided = value[PlayerAttendingStatus.undecided]!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
        future: getScheduleById(widget.scheduleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            schedule = snapshot.data!;
            String scheduleTitle = schedule.schedule_title;
            String scheduleType = schedule.schedule_type;
            DateTime scheduleStartTime =
                DateTime.parse(schedule.schedule_start_time);
            return Scaffold(
                appBar: AppBar(
                  title: appBarTitlePreviousPage(scheduleTitle),
                  iconTheme: const IconThemeData(
                    color: AppColours.darkBlue, //change your color here
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.all(35),
                  child: Center(
                      child: Column(children: [
                    const Text("Players Attending",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.gabarito)),
                    const SizedBox(height: 5),
                    Text("$scheduleType | ${DateFormat('EEEE, d MMMM y').format(
                      scheduleStartTime,
                    )}"),
                    const SizedBox(height: 20),
                    greyDivider(),
                    const SizedBox(height: 20),
                    const Text(
                      "Attending",
                      style: TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.gabarito,
                          fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    if (playersAttending.isEmpty)
                      emptySection(Icons.person_off, "No players attending"),
                    if (playersAttending.isNotEmpty)
                      for (PlayerProfile player in playersAttending)
                        Column(children: [
                          playerProfilePill(
                              context,
                              player.imageBytes,
                              player.playerId,
                              player.firstName,
                              player.surname,
                              player.teamNumber,
                              player.status),
                          const SizedBox(height: 10),
                        ]),
                    greyDivider(),
                    const SizedBox(height: 20),
                    const Text(
                      "Not Attending",
                      style: TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.gabarito,
                          fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    if (playersNotAttending.isEmpty)
                      emptySection(Icons.person_off, "No players absent"),
                    if (playersNotAttending.isNotEmpty)
                      for (PlayerProfile player in playersNotAttending)
                        Column(children: [
                          playerProfilePill(
                              context,
                              player.imageBytes,
                              player.playerId,
                              player.firstName,
                              player.surname,
                              player.teamNumber,
                              player.status),
                          const SizedBox(height: 10),
                        ]),
                    greyDivider(),
                    const SizedBox(height: 20),
                    const Text(
                      "Undecided",
                      style: TextStyle(
                          color: AppColours.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.gabarito,
                          fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    if (playersUndecided.isEmpty)
                      emptySection(Icons.person_off, "No players undecided"),
                    if (playersUndecided.isNotEmpty)
                      for (PlayerProfile player in playersUndecided)
                        Column(children: [
                          playerProfilePill(
                              context,
                              player.imageBytes,
                              player.playerId,
                              player.firstName,
                              player.surname,
                              player.teamNumber,
                              player.status),
                          const SizedBox(height: 10),
                        ]),
                  ])),
                )),
                bottomNavigationBar: managerBottomNavBar(context, 2));
          } else {
            return Text('No data available');
          }
        });
  }
}
