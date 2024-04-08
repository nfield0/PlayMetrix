import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_metrix/api_clients/match_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DurationPlayedScreen extends StatefulWidget {
  final Appointment schedule;
  final int scheduleId;
  final int teamId;
  final UserRole userRole;

  const DurationPlayedScreen(
      {super.key,
      required this.schedule,
      required this.scheduleId,
      required this.teamId,
      required this.userRole});

  @override
  DurationPlayedScreenState createState() => DurationPlayedScreenState();
}

class DurationPlayedScreenState extends State<DurationPlayedScreen> {
  Map<LineupStatus, List<PlayerProfile>> players = {
    LineupStatus.starter: [],
    LineupStatus.substitute: [],
    LineupStatus.reserve: [],
  };

  List<PlayerProfile> starters = [];
  List<PlayerProfile> substitutes = [];
  List<PlayerProfile> reserves = [];

  List<PlayerProfile> filteredPlayers = [];

  final controller = TextEditingController();
  String query = "";

  @override
  void initState() {
    super.initState();
    getPlayersLineupStatus(widget.teamId).then((playersRes) {
      setState(() {
        players = playersRes;
        starters = playersRes[LineupStatus.starter]!;
        substitutes = playersRes[LineupStatus.substitute]!;
        reserves = playersRes[LineupStatus.reserve]!;
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Match Line Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.gabarito,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                        "Matchday | ${DateFormat('EEEE, d MMMM y').format(widget.schedule.startTime)}"),
                    const SizedBox(height: 20),
                    SearchBar(
                      hintText: "Search players...",
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                      hintStyle: MaterialStateProperty.all(TextStyle(
                        color: Colors.grey[600],
                      )),
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onChanged: (_) {
                        setState(() {
                          query = _;
                          filteredPlayers = players.values
                              .expand((list) => list)
                              .where((player) =>
                                  player.surname
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  player.firstName
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  ("${player.firstName} ${player.surname}")
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  player.teamNumber.toString().contains(query))
                              .toList();
                        });
                      },
                      leading: const Icon(Icons.search),
                    ),
                    const SizedBox(height: 20),
                    Column(
                        children: query.isEmpty
                            ? [
                                const SizedBox(height: 10),
                                const Text(
                                  "Starting Players",
                                  style: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.gabarito,
                                    fontSize: 26,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (starters.isEmpty)
                                  emptySection(
                                      Icons.person_off, "No players starting"),
                                if (starters.isNotEmpty)
                                  for (PlayerProfile player in starters)
                                    Column(children: [
                                      FutureBuilder(
                                        future: getMatchDataForPlayerSchedule(
                                          scheduleId: widget.scheduleId,
                                          playerId: player.playerId,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            MatchData matchData =
                                                snapshot.data!;
                                            return _playerDurationPlayedBox(
                                              context,
                                              player,
                                              widget.schedule,
                                              matchData,
                                              () {
                                                setState(() {});
                                              },
                                            );
                                          } else {
                                            return _playerDurationPlayedBox(
                                              context,
                                              player,
                                              widget.schedule,
                                              null,
                                              () {
                                                setState(() {});
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ]),
                                const SizedBox(height: 20),
                                greyDivider(),
                                const SizedBox(height: 20),
                                const Text(
                                  "Substitutes",
                                  style: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.gabarito,
                                    fontSize: 26,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (substitutes.isEmpty)
                                  emptySection(
                                      Icons.person_off, "No substitutes"),
                                if (substitutes.isNotEmpty)
                                  for (PlayerProfile player in substitutes)
                                    Column(children: [
                                      FutureBuilder(
                                        future: getMatchDataForPlayerSchedule(
                                          scheduleId: widget.scheduleId,
                                          playerId: player.playerId,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            MatchData matchData =
                                                snapshot.data!;
                                            return _playerDurationPlayedBox(
                                              context,
                                              player,
                                              widget.schedule,
                                              matchData,
                                              () {
                                                setState(() {});
                                              },
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ]),
                                const SizedBox(height: 20),
                                greyDivider(),
                                const SizedBox(height: 20),
                                const Text(
                                  "Reserves",
                                  style: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.gabarito,
                                    fontSize: 26,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (reserves.isEmpty)
                                  emptySection(Icons.person_off, "No reserves"),
                                if (reserves.isNotEmpty)
                                  for (PlayerProfile player in reserves)
                                    Column(children: [
                                      FutureBuilder(
                                        future: getMatchDataForPlayerSchedule(
                                          scheduleId: widget.scheduleId,
                                          playerId: player.playerId,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            MatchData matchData =
                                                snapshot.data!;
                                            return _playerDurationPlayedBox(
                                              context,
                                              player,
                                              widget.schedule,
                                              matchData,
                                              () {
                                                setState(() {});
                                              },
                                            );
                                          } else {
                                            return _playerDurationPlayedBox(
                                              context,
                                              player,
                                              widget.schedule,
                                              null,
                                              () {
                                                setState(() {});
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ])
                              ]
                            : [
                                if (filteredPlayers.isEmpty)
                                  Column(children: [
                                    const SizedBox(height: 20),
                                    emptySection(
                                        Icons.person_off, "No players found"),
                                  ]),
                                for (PlayerProfile player in filteredPlayers)
                                  Column(children: [
                                    const SizedBox(height: 20),
                                    FutureBuilder(
                                      future: getMatchDataForPlayerSchedule(
                                        scheduleId: widget.scheduleId,
                                        playerId: player.playerId,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (snapshot.hasData) {
                                          MatchData matchData = snapshot.data!;
                                          return _playerDurationPlayedBox(
                                            context,
                                            player,
                                            widget.schedule,
                                            matchData,
                                            () {
                                              setState(() {});
                                            },
                                          );
                                        } else {
                                          return _playerDurationPlayedBox(
                                            context,
                                            player,
                                            widget.schedule,
                                            null,
                                            () {
                                              setState(() {});
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ]),
                              ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: managerBottomNavBar(context, 3),
    );
  }
}

Widget _playerDurationPlayedBox(BuildContext context, PlayerProfile player,
    Appointment schedule, MatchData? matchData, void Function() callback) {
  Color statusColour = AppColours.green;
  IconData statusIcon = Icons.check_circle;
  switch (player.status) {
    case AvailabilityStatus.available:
      statusColour = AppColours.green;
      statusIcon = Icons.check_circle;
      break;
    case AvailabilityStatus.unavailable:
      statusColour = AppColours.red;
      statusIcon = Icons.cancel;
      break;
    case AvailabilityStatus.limited:
      statusColour = AppColours.yellow;
      statusIcon = Icons.warning;
      break;
  }

  Duration duration = matchData?.minutesPlayed ?? const Duration();

  return Column(children: [
    Stack(clipBehavior: Clip.none, children: [
      InkWell(
          onTap: () async {
            if (matchData == null) {
              await addMatchData(
                  scheduleId: schedule.id, playerId: player.playerId);
              await calculateMatchesPlayedByPlayerId(player.playerId);
            }

            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Column(children: [
                        const Text("Record Duration Played",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(height: 10),
                        Text(
                          "#${player.teamNumber} ${player.firstName} ${player.surname}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.gabarito,
                            color: AppColours.darkBlue,
                          ),
                        ),
                      ]),
                      content: DurationPicker(
                        duration: duration,
                        onChange: (val) {
                          setState(() => duration = val);
                        },
                        snapToMins: 5.0,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await updateMatchData(
                                scheduleId: schedule.id,
                                playerId: player.playerId,
                                minutesPlayed: duration.inMinutes);
                            await calculateMatchesPlayedByPlayerId(
                                player.playerId);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    );
                  });
                }).then((_) {
              callback();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: statusColour, width: 4),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    player.imageBytes != null && player.imageBytes!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.memory(
                              player.imageBytes!,
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            "lib/assets/icons/profile_placeholder.png",
                            width: 65,
                          ),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      "#${player.teamNumber}",
                      style: TextStyle(
                        color: statusColour,
                        fontSize: 36,
                        fontFamily: AppFonts.gabarito,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.firstName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: AppFonts.gabarito,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            player.surname,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: AppFonts.gabarito,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    greyDivider(),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Duration played:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Text("${duration.inMinutes} minutes",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
      Positioned(
        top: -10,
        right: -10,
        child: Container(
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Color(0XFFfafafa),
            shape: BoxShape.circle,
          ),
          child: Icon(
            statusIcon,
            color: statusColour,
            size: 40,
          ),
        ),
      ),
    ]),
    const SizedBox(height: 10),
  ]);
}
