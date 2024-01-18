import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// DIVISION AND CLUB NAME IS NOT IN BACKEND ENDPOINT, ALSO UNSURE OF HOW TO GET TEAM LOGO AND MANAGER ID, SPORT ID IS ALSO NOT IN BACKEND ENDPOINT, PHYSIO ID
Future<void> addTeam({
  required String teamName,
  required String teamLogo,
  required int managerId,
  required int leagueId,
  required int sportId,
  required String teamLocation,
}) async {
  final apiUrl =
      'http://127.0.0.1:8000/login/teams/'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'team_name': teamName,
        'team_logo': teamLogo,
        'manager_id': managerId,
        'league_id': leagueId,
        'sport_id': sportId,
        'team_location': teamLocation,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added team, handle the response accordingly
      print('Team added successfully!');
      print('Response: ${response.body}');
      // You can parse the response JSON here and perform actions based on it
    } else {
      // Failed to add team, handle the error accordingly
      print('Failed to add team. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

class TeamSetUpScreen extends StatefulWidget {
  const TeamSetUpScreen({Key? key}) : super(key: key);

  @override
  _TeamSetUpScreenState createState() => _TeamSetUpScreenState();
}

class _TeamSetUpScreenState extends State<TeamSetUpScreen> {
  String selectedDivisionValue = "Division 1";

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamLogoController = TextEditingController();
  final TextEditingController _managerIdController = TextEditingController();
  final TextEditingController _leagueIdController = TextEditingController();
  final TextEditingController _sportIdController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Form(
          child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Team Set Up',
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.gabarito,
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                )),
            const Divider(
              color: AppColours.darkBlue,
              thickness: 1.0, // Set the thickness of the line
              height: 40.0, // Set the height of the line
            ),
            const SizedBox(height: 20),
            Center(
                child: Column(children: [
              Image.asset(
                "lib/assets/icons/logo_placeholder.png",
                width: 100,
              ),
              const SizedBox(height: 10),
              underlineButtonTransparent("Upload logo", () {}),
            ])),
            formFieldBottomBorder("Club name", ""), // NOT IN BACKEND ENDPOINT
            const SizedBox(height: 10),
            formFieldBottomBorder("Team name", _teamNameController.text),
            const SizedBox(height: 10),
            formFieldBottomBorder("Location", _teamLocationController.text),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Division",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  // Wrap the DropdownButtonFormField with a Container
                  width: 220, // Provide a specific width
                  child: DropdownButtonFormField<String>(
                    focusColor: AppColours.darkBlue,
                    value: selectedDivisionValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDivisionValue = newValue!;
                      });
                    },
                    items: ['Division 1', 'Division 2', 'Division 3']
                        .map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            bigButton("Save Changes", () {
              //             addTeam(
              //               teamName: _teamNameController.text // get team name from your form,
              //               teamLogo: _teamLogoController.text // get team logo from your form,
              //               managerId: _managerIdController.text // get manager ID from your form,
              //               leagueId: _leagueIdController.text // get league ID from your form,
              //               sportId: _sportIdController.text // get sport ID from your form,
              //               teamLocation: _teamLocationController.text // get team location from your form,
              // );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeamProfileScreen()),
              );
            })
          ],
        ),
      )),
    );
  }
}
