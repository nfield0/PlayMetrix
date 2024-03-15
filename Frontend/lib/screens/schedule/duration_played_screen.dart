import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DurationPlayedScreen extends StatefulWidget {
  final Appointment schedule;
  final int teamId;
  final UserRole userRole;

  const DurationPlayedScreen(
      {super.key,
      required this.schedule,
      required this.teamId,
      required this.userRole});

  @override
  DurationPlayedScreenState createState() => DurationPlayedScreenState();
}

class DurationPlayedScreenState extends State<DurationPlayedScreen> {
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
        reserves = value[LineupStatus.reserve]!;
      });
    });
  }

  Duration duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitlePreviousPage("Match Line Up"),
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
                  "Duration Played",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.gabarito,
                  ),
                ),
                const SizedBox(height: 5),
                const Text("Matchday | Tuesday, 2 October 2023"),
                const SizedBox(height: 20),
                _playerSearchBar(),
                const SizedBox(height: 10),
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
                  emptySection(Icons.person_off, "No players starting"),
                if (staters.isNotEmpty)
                  for (PlayerProfile player in staters)
                    Column(children: [
                      _playerDurationPlayedBox(context, player, duration),
                      const SizedBox(height: 10),
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
                      fontSize: 26),
                ),
                const SizedBox(height: 20),
                if (substitutes.isEmpty)
                  emptySection(Icons.person_off, "No substitutes"),
                if (substitutes.isNotEmpty)
                  for (PlayerProfile player in substitutes)
                    Column(children: [
                      _playerDurationPlayedBox(context, player, duration),
                      const SizedBox(height: 10),
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
                      fontSize: 26),
                ),
                const SizedBox(height: 20),
                if (reserves.isEmpty)
                  emptySection(Icons.person_off, "No reserves"),
                if (reserves.isNotEmpty)
                  for (PlayerProfile player in reserves)
                    Column(children: [
                      _playerDurationPlayedBox(context, player, duration),
                      const SizedBox(height: 10),
                    ]),
              ],
            ),
          ),
        ),
      ))),
      bottomNavigationBar: managerBottomNavBar(context, 3),
    );
  }
}

Widget _playerSearchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search players...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}

Widget _playerDurationPlayedBox(
  BuildContext context,
  PlayerProfile player,
  Duration duration,
) {
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

  return Stack(clipBehavior: Clip.none, children: [
    InkWell(
        onTap: () {
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  );
                });
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    greyDivider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Duration played",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [],
                        )
                      ],
                    ),
                  ],
                ),
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
  ]);
}
