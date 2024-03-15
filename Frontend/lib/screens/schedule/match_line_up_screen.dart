import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/schedule/duration_played_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MatchLineUpScreen extends ConsumerWidget {
  final Appointment schedule;
  final int scheduleId;
  final int teamId;
  final UserRole userRole;

  const MatchLineUpScreen(
      {super.key,
      required this.schedule,
      required this.scheduleId,
      required this.teamId,
      required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage(schedule.subject),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder<Map<LineupStatus, List<PlayerProfile>>>(
            future: getPlayersLineupStatus(teamId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<PlayerProfile> staters =
                    snapshot.data![LineupStatus.starter]!;
                List<PlayerProfile> substitutes =
                    snapshot.data![LineupStatus.substitute]!;
                List<PlayerProfile> reserves =
                    snapshot.data![LineupStatus.reserve]!;

                return SingleChildScrollView(
                  child: Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Container(
                              padding: const EdgeInsets.all(35),
                              child: Center(
                                  child: Column(children: [
                                const Text("Match Line Up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFonts.gabarito)),
                                const SizedBox(height: 5),
                                const Text(
                                    "Training | Tuesday, 2 October 2023"),
                                const SizedBox(height: 20),
                                underlineButtonTransparent(
                                    "Record duration played", () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DurationPlayedScreen(
                                        schedule: schedule,
                                        scheduleId: scheduleId,
                                        teamId: teamId,
                                        userRole: userRole,
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 20),
                                greyDivider(),
                                const SizedBox(height: 20),
                                const Text(
                                  "Starting Players",
                                  style: TextStyle(
                                      color: AppColours.darkBlue,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.gabarito,
                                      fontSize: 26),
                                ),
                                const SizedBox(height: 20),
                                if (staters.isEmpty)
                                  emptySection(
                                      Icons.person_off, "No players attending"),
                                if (staters.isNotEmpty)
                                  for (PlayerProfile player in staters)
                                    Column(children: [
                                      playerProfilePill(
                                          context,
                                          ref,
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
                                  "Substitutes",
                                  style: TextStyle(
                                      color: AppColours.darkBlue,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.gabarito,
                                      fontSize: 26),
                                ),
                                const SizedBox(height: 20),
                                if (substitutes.isEmpty)
                                  emptySection(
                                      Icons.person_off, "No substitutes"),
                                if (substitutes.isNotEmpty)
                                  for (PlayerProfile player in substitutes)
                                    Column(children: [
                                      playerProfilePill(
                                          context,
                                          ref,
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
                                  "Reserves",
                                  style: TextStyle(
                                      color: AppColours.darkBlue,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.gabarito,
                                      fontSize: 26),
                                ),
                                const SizedBox(height: 20),
                                if (reserves.isEmpty)
                                  emptySection(Icons.person_off, "No reserves"),
                                if (reserves.isNotEmpty)
                                  for (PlayerProfile player in reserves)
                                    Column(children: [
                                      playerProfilePill(
                                          context,
                                          ref,
                                          player.imageBytes,
                                          player.playerId,
                                          player.firstName,
                                          player.surname,
                                          player.teamNumber,
                                          player.status),
                                      const SizedBox(height: 10),
                                    ]),
                                const SizedBox(height: 20),
                              ]))))),
                );
              } else {
                return const Text('No data available');
              }
            }),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 3));
  }
}
