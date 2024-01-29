import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

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
      print('Get players attending successful!');

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
  throw Exception('Failed to players attending data');
}

class playerAttending {
  int schedule_id;
  int player_id;
  bool player_attending;

  playerAttending(
      {required this.schedule_id,
      required this.player_id,
      required this.player_attending});

  factory playerAttending.fromJson(Map<String, dynamic> json) {
    return playerAttending(
        schedule_id: json['schedule_id'],
        player_id: json['player_id'],
        player_attending: json['player_attending']);
  }
}

// class PlayersAttendingScreen extends StatefulWidget {
//   const PlayersAttendingScreen({Key? key}) : super(key: key);

//   @override
//   _PlayersAttendingScreenState createState() => _PlayersAttendingScreenState();
// }

class PlayersAttendingScreen extends ConsumerWidget {
  late Schedule schedule;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int scheduleId = ref.watch(scheduleIdProvider);
    return FutureBuilder<Schedule>(
        future: getScheduleById(scheduleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            schedule = snapshot.data!;
            String schedule_title = schedule.schedule_title;
            String schedule_type = schedule.schedule_type;
            String schedule_start_time = schedule.schedule_start_time;
            return Scaffold(
                appBar: AppBar(
                  title: appBarTitlePreviousPage("${schedule_title}"),
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
                    Text("${schedule_type} | ${schedule_start_time}"),

                    const SizedBox(height: 30),
                    // playerProfilePill(
                    //     context,
                    //     "lib/assets/icons/profile_placeholder.png",
                    //     "Luana",
                    //     "Kimley",
                    //     7,
                    //     AvailabilityStatus.Available),
                    // const SizedBox(height: 20),
                    // playerProfilePill(
                    //     context,
                    //     "lib/assets/icons/profile_placeholder.png",
                    //     "Luana",
                    //     "Kimley",
                    //     7,
                    //     AvailabilityStatus.Available),
                  ])),
                )),
                bottomNavigationBar: managerBottomNavBar(context, 2));
          } else {
            return Text('No data available');
          }
        });
  }
}
