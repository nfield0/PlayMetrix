import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/player/add_player_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/schedule/duration_played_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<Map<LineupStatus, List<PlayerProfile>>> getPlayersLineupStatus(
    int teamId) async {
  try {
    // Create a map to store players based on their attending status
    Map<LineupStatus, List<PlayerProfile>> playersByStatus = {
      LineupStatus.starter: [],
      LineupStatus.substitute: [],
      LineupStatus.reserve: [],
    };

    List<PlayerProfile> players = await getAllPlayersForTeam(teamId);

    for (PlayerProfile player in players) {
      if (player.lineupStatus == LineupStatus.starter) {
        playersByStatus[LineupStatus.starter]!.add(player);
      } else if (player.lineupStatus == LineupStatus.substitute) {
        playersByStatus[LineupStatus.substitute]!.add(player);
      } else {
        playersByStatus[LineupStatus.reserve]!.add(player);
      }
    }

    return playersByStatus;
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw Exception('Failed to retrieve players attendance data');
}

class MatchLineUpScreen extends StatefulWidget {
  final Appointment schedule;
  final int teamId;
  final UserRole userRole;

  const MatchLineUpScreen(
      {super.key,
      required this.schedule,
      required this.teamId,
      required this.userRole});

  @override
  MatchLineUpScreenState createState() => MatchLineUpScreenState();
}

class MatchLineUpScreenState extends State<MatchLineUpScreen> {
  late List<PlayerProfile> staters = [];
  late List<PlayerProfile> substitutes = [];
  late List<PlayerProfile> reserves = [];

  @override
  void initState() {
    super.initState();
    getPlayersLineupStatus(widget.teamId).then((value) {
      setState(() {
        staters = value[LineupStatus.starter]!;
        substitutes = value[LineupStatus.substitute]!;
        substitutes = value[LineupStatus.reserve]!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage(widget.schedule.subject),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: SingleChildScrollView(
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
                const Text("Training | Tuesday, 2 October 2023"),
                const SizedBox(height: 20),
                underlineButtonTransparent("Record duration played", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DurationPlayedScreen(),
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
                  emptySection(Icons.person_off, "No players attending"),
                if (staters.isNotEmpty)
                  for (PlayerProfile player in staters)
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
                  "Substitutes",
                  style: TextStyle(
                      color: AppColours.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.gabarito,
                      fontSize: 26),
                ),
                const SizedBox(height: 20),
                if (substitutes.isEmpty)
                  emptySection(Icons.person_off, "No substitutes"),
                if (substitutes.isNotEmpty)
                  for (PlayerProfile player in staters)
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
                  for (PlayerProfile player in staters)
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
                const SizedBox(height: 20),
              ]))),
        )),
        bottomNavigationBar:
            roleBasedBottomNavBar(widget.userRole, context, 2));
  }
}
