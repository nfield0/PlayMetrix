import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// DIVISION AND CLUB NAME IS NOT IN BACKEND ENDPOINT, ALSO UNSURE OF HOW TO GET TEAM LOGO AND MANAGER ID, SPORT ID IS ALSO NOT IN BACKEND ENDPOINT, PHYSIO ID
Future<void> editTeam({
  required String teamName,
  required String teamLogo,
  required int managerId,
  required int leagueId,
  required int sportId,
  required String teamLocation,
}) async {
  final apiUrl = '$apiBaseUrl/login/teams/'; // Replace with your actual API URL

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'team_name': teamName,
        'team_logo': teamLogo,
        'manager_id': managerId,
        'league_id': leagueId,
        'sport_id': sportId,
        'team_location': teamLocation,
      }),
    );

    if (response.statusCode == 200) {
      // Team updated successfully
      print('Team updated successfully');
    } else {
      // Handle errors
      print('Failed to update team. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating team: $e');
  }
}

class EditTeamScreen extends StatefulWidget {
  const EditTeamScreen({Key? key}) : super(key: key);

  @override
  _EditTeamScreenState createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  String selectedDivisionValue = "Division 1";
  final _formKey = GlobalKey<FormState>();

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
          title:
              const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              "Team Profile",
              style: TextStyle(
                color: AppColours.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ]),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                padding: EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Edit Team',
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
                    const SizedBox(height: 10),
                    formFieldBottomBorderController(
                        "Team name", _teamNameController, (String? value) {
                      return (value != null) ? 'This field is required.' : null;
                    }),
                    const SizedBox(height: 10),
                    formFieldBottomBorderController(
                        "Location", _teamLocationController, (String? value) {
                      return (value != null) ? 'This field is required.' : null;
                    }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "League",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                      if (_formKey.currentState!.validate()) {
                        // editTeam(
                        //   teamName: _teamNameController.text,
                        //   teamLogo: _teamLogoController.text,
                        //   managerId: _managerIdController, // replace with actual manager ID
                        //   leagueId: _leagueIdController, // replace with actual league ID
                        //   sportId: _sportIdController, // replace with actual sport ID
                        //   teamLocation: _teamLocationController.text,
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamProfileScreen()),
                        );
                      }
                    })
                  ],
                ),
              )),
        ));
  }
}
