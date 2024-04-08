import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/coach/coaches_screen.dart';
import 'package:play_metrix/screens/player/add_player_screen.dart';
import 'package:play_metrix/screens/player/player_profile_view_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

final playerIdProvider = StateProvider<int>((ref) => -1);

class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole userRole = ref.watch(userRoleProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Team",
              style: TextStyle(
                color: AppColours.darkBlue,
                fontFamily: AppFonts.gabarito,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              )),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 35, left: 35),
                        child: Column(children: [
                          if (userRole == UserRole.manager)
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.sync_alt,
                                      color: AppColours.darkBlue, size: 24),
                                  underlineButtonTransparent(
                                      "Switch to Coaches", () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                CoachesScreen(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  }),
                                ]),
                          const SizedBox(height: 25),
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
                                          builder: (context) =>
                                              TeamProfileScreen()),
                                    );
                                  });
                                } else {
                                  return emptySection(
                                      Icons.group_off, "No team yet");
                                }
                              }),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Players",
                                style: TextStyle(
                                  fontFamily: AppFonts.gabarito,
                                  color: AppColours.darkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                              if (userRole == UserRole.manager)
                                smallButton(Icons.person_add, "Add", () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddPlayerScreen()),
                                  );
                                })
                            ],
                          ),
                          const SizedBox(height: 35),
                          FutureBuilder(
                              future: getAllPlayersForTeam(
                                  ref.read(teamIdProvider.notifier).state),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<PlayerProfile> players = snapshot.data!;

                                  return players.isNotEmpty
                                      ? MediaQuery.of(context)
                                                  .size
                                                  .longestSide >=
                                              1000
                                          ? Wrap(
                                              direction: Axis.horizontal,
                                              spacing: 20.0,
                                              runSpacing: 20.0,
                                              children: players
                                                  .map((PlayerProfile player) {
                                                return userRole ==
                                                        UserRole.manager
                                                    ? dismissablePlayerProfilePill(
                                                        context,
                                                        ref,
                                                        player.imageBytes,
                                                        player.playerId,
                                                        player.firstName,
                                                        player.surname,
                                                        player.teamNumber,
                                                        player.status,
                                                      )
                                                    : playerProfilePill(
                                                        context,
                                                        ref,
                                                        player.imageBytes,
                                                        player.playerId,
                                                        player.firstName,
                                                        player.surname,
                                                        player.teamNumber,
                                                        player.status,
                                                      );
                                              }).toList(),
                                            )
                                          : Column(
                                              children: players
                                                  .map((PlayerProfile player) {
                                                return userRole ==
                                                        UserRole.manager
                                                    ? dismissablePlayerProfilePill(
                                                        context,
                                                        ref,
                                                        player.imageBytes,
                                                        player.playerId,
                                                        player.firstName,
                                                        player.surname,
                                                        player.teamNumber,
                                                        player.status,
                                                      )
                                                    : playerProfilePill(
                                                        context,
                                                        ref,
                                                        player.imageBytes,
                                                        player.playerId,
                                                        player.firstName,
                                                        player.surname,
                                                        player.teamNumber,
                                                        player.status,
                                                      );
                                              }).toList(),
                                            )
                                      : emptySection(Icons.person_off,
                                          "No players added yet");
                                } else {
                                  return emptySection(
                                      Icons.group_off, "No team yet");
                                }
                              }),
                        ]))))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 0));
  }
}

Widget playerProfilePill(
  BuildContext context,
  WidgetRef ref,
  Uint8List? imageBytes,
  int playerId,
  String firstName,
  String surname,
  int playerNum,
  AvailabilityStatus status,
) {
  Color statusColour = AppColours.green;
  IconData statusIcon = Icons.check_circle;
  switch (status) {
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

  return Column(children: [
    Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
            onTap: () {
              ref.read(playerIdProvider.notifier).state = playerId;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlayerProfileViewScreen(playerId: playerId)),
              );
            },
            child: Container(
              // width: MediaQuery.of(context).size.longestSide >= 900 ? 500 : null,
              decoration: BoxDecoration(
                border: Border.all(color: statusColour, width: 4),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  imageBytes != null && imageBytes.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.memory(
                            imageBytes,
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
                    "#$playerNum",
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
                          firstName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: AppFonts.gabarito,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          surname,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: AppFonts.gabarito,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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
      ],
    ),
    const SizedBox(height: 20),
  ]);
}

Widget dismissablePlayerProfilePill(
    BuildContext context,
    WidgetRef ref,
    Uint8List? imageBytes,
    int playerId,
    String firstName,
    String surname,
    int playerNum,
    AvailabilityStatus status) {
  Color statusColour = AppColours.green;
  IconData statusIcon = Icons.check_circle;
  switch (status) {
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

  return Column(children: [
    Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: AppColours.red),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Remove player from team",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.gabarito)),
              SizedBox(width: 20),
              Icon(Icons.delete, color: Colors.white, size: 30),
              SizedBox(width: 30),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Remove Player",
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  "Are you sure you want to remove #$playerNum $firstName $surname from your team?",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      removePlayerFromTeam(
                          ref.read(teamIdProvider.notifier).state, playerId);
                    },
                    child: const Text("Remove"),
                  ),
                ],
              );
            },
          );
        },
        key: Key(playerId.toString()),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
                onTap: () {
                  ref.read(playerIdProvider.notifier).state = playerId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PlayerProfileViewScreen(playerId: playerId)),
                  );
                },
                child: Container(
                  // width: MediaQuery.of(context).size.longestSide >= 900 ? 500 : null,
                  decoration: BoxDecoration(
                    border: Border.all(color: statusColour, width: 4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      imageBytes != null && imageBytes.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.memory(
                                imageBytes,
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
                        "#$playerNum",
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
                              firstName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: AppFonts.gabarito,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              surname,
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: AppFonts.gabarito,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
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
          ],
        )),
    const SizedBox(height: 20),
  ]);
}
