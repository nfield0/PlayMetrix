import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/schedule_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

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
                bottomNavigationBar: managerBottomNavBar(context, 3));
          } else {
            return Text('No data available');
          }
        });
  }
}
