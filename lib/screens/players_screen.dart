import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/add_player_screen.dart';
import 'package:play_metrix/screens/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            'lib/assets/logo.png',
            width: 150,
            fit: BoxFit.contain,
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, right: 35, left: 35),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.sync_alt, color: AppColours.darkBlue, size: 24),
                underlineButtonTransparent("Switch to Coaches", () {}),
              ]),
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
                  smallButton(Icons.person_add, "Add", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPlayerScreen()),
                    );
                  })
                ],
              ),
              const SizedBox(height: 35),
              _playerProfilePill(
                  context,
                  "lib/assets/icons/profile_placeholder.png",
                  "Luana",
                  "Kimley",
                  7,
                  AvailabilityStatus.Available),
              const SizedBox(height: 20),
              _playerProfilePill(
                  context,
                  "lib/assets/icons/profile_placeholder.png",
                  "Luana",
                  "Kimley",
                  7,
                  AvailabilityStatus.Limited),
              const SizedBox(height: 20),
              _playerProfilePill(
                  context,
                  "lib/assets/icons/profile_placeholder.png",
                  "Luana",
                  "Kimley",
                  7,
                  AvailabilityStatus.Unavailable),
            ])),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}

Widget _playerProfilePill(
    BuildContext context,
    String imagePath,
    String firstName,
    String surname,
    int playerNum,
    AvailabilityStatus status) {
  Color statusColour = AppColours.green;
  IconData statusIcon = Icons.check_circle;
  switch (status) {
    case AvailabilityStatus.Available:
      statusColour = AppColours.green;
      statusIcon = Icons.check_circle;
      break;
    case AvailabilityStatus.Unavailable:
      statusColour = AppColours.red;
      statusIcon = Icons.cancel;
      break;
    case AvailabilityStatus.Limited:
      statusColour = AppColours.yellow;
      statusIcon = Icons.warning;
      break;
  }

  return Stack(
    clipBehavior: Clip.none,
    children: [
      InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PlayerProfileScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: statusColour, width: 4),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: AppFonts.gabarito,
                      ),
                    ),
                    Text(
                      surname,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: AppFonts.gabarito,
                        fontWeight: FontWeight.bold,
                      ),
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
    ],
  );
}
