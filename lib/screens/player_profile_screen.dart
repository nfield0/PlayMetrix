import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

enum AvailabilityStatus { Available, Limited, Unavailable }

class AvailabilityData {
  final AvailabilityStatus status;
  final String message;
  final IconData icon;
  final Color color;

  AvailabilityData(this.status, this.message, this.icon, this.color);
}

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({Key? key}) : super(key: key);

  @override
  _PlayerProfileScreenState createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  AvailabilityData available = AvailabilityData(AvailabilityStatus.Available,
      "Available", Icons.check_circle, AppColours.green);
  AvailabilityData limited = AvailabilityData(
      AvailabilityStatus.Limited, "Limited", Icons.warning, AppColours.yellow);
  AvailabilityData unavailable = AvailabilityData(
      AvailabilityStatus.Unavailable,
      "Unavailable",
      Icons.cancel,
      AppColours.red);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  smallButton(
                      const Icon(
                        Icons.edit,
                        color: AppColours.darkBlue,
                        size: 16,
                      ),
                      "Edit")
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
                    _playerProfile("Luana", "Kimley", 7, "27/08/2002", 163,
                        "Female", limited),
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
                    profilePill("Louth GAA", "Senior Football",
                        "lib/assets/icons/logo_placeholder.png", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TeamProfileScreen()),
                      );
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
                    _injuriesSection(3),
                    divider(),
                    const SizedBox(height: 20),
                    const Text("Stats",
                        style: TextStyle(
                            fontFamily: AppFonts.gabarito,
                            fontWeight: FontWeight.bold,
                            color: AppColours.darkBlue,
                            fontSize: 30)),
                    const SizedBox(height: 20),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: statistics(Statistics(10, 4, 6, 230, 3))),
                    const SizedBox(height: 20),
                  ]),
                ))),
        bottomNavigationBar: bottomNavBar([
          bottomNavBarItem("Home", Icons.home),
          bottomNavBarItem("Teams", Icons.group),
          bottomNavBarItem("Schedule", Icons.calendar_month),
          bottomNavBarItem("My Profile", Icons.person_rounded)
        ]));
  }
}

Widget _playerProfile(String firstName, String surname, int playerNumber,
    String dob, int height, String gender, AvailabilityData availability) {
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
        child:
            Image.asset("lib/assets/icons/profile_placeholder.png", width: 150),
        decoration: BoxDecoration(
          border: Border.all(
            color: availability.color, // Set the border color
            width: 5, // Set the border width
          ),
          borderRadius: BorderRadius.circular(20), // Set the border radius
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
      _profileDetails("Date of Birth", dob),
      const SizedBox(height: 15),
      _profileDetails("Height", "${height}cm"),
      const SizedBox(height: 15),
      _profileDetails("Gender", gender),
      const SizedBox(height: 35),
      _availabilityTrafficLight(availability.status),
    ]),
  );
}

Widget _profileDetails(String title, String desc) {
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

Widget _availabilityTrafficLight(AvailabilityStatus playerStatus) {
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
      _availabilityTrafficLightItem(availability[0], playerStatus),
      _availabilityTrafficLightItem(availability[1], playerStatus),
      _availabilityTrafficLightItem(availability[2], playerStatus)
    ],
  );
}

Widget _availabilityTrafficLightItem(
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

Widget _injuriesSection(int numInjuries) {
  List<Injury> _data = [
    Injury("10/04/2022", "10/05/2022", "Hamstring", "4 weeks", "Physio"),
    Injury(
        "11/05/2023", "29/07/2023", "Hamstring", "4 weeks", "Light exercise"),
    Injury("31/10/2023", "-", "Hamstring", "6 weeks", "Physio")
  ];

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
        children: _data.map<ExpansionPanelRadio>((Injury injury) {
          return ExpansionPanelRadio(
            value: injury.dateOfInjury,
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(injury.dateOfInjury,
                    style: const TextStyle(
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold)),
              );
            },
            body: ListTile(
              title: _injuryDetails(injury),
            ),
          );
        }).toList(),
      ),
    ]),
  );
}

class Injury {
  var dateOfInjury;
  var dateOfRecovery;
  var injuryType;
  var expectedRecoveryTime;
  var recoveryMethod;

  Injury(
    this.dateOfInjury,
    this.dateOfRecovery,
    this.injuryType,
    this.expectedRecoveryTime,
    this.recoveryMethod,
  );
}

Widget _injuryDetails(Injury injury) {
  return Column(
    children: [
      greyDivider(),
      const SizedBox(height: 10),
      detailWithDivider("Date of Injury", injury.dateOfInjury),
      const SizedBox(height: 10),
      detailWithDivider("Date of Recovery", injury.dateOfRecovery),
      const SizedBox(height: 10),
      detailWithDivider("Injury Type", injury.injuryType),
      const SizedBox(height: 10),
      detailWithDivider("Expected Recovery Time", injury.expectedRecoveryTime),
      const SizedBox(height: 10),
      detailWithDivider("Recovery Method", injury.recoveryMethod),
      CupertinoButton(
        onPressed: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(10.0),
          child: const Text(
            'View player report',
            style: TextStyle(
              color: AppColours.darkBlue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontFamily: AppFonts.gabarito,
              fontSize: 20,
            ),
          ),
        ),
      )
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
