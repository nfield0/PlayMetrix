import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final positionProvider =
    StateProvider<String>((ref) => teamRoleToText(TeamRole.defense));
final availabilityProvider =
    StateProvider<AvailabilityData>((ref) => availabilityData[0]);

Future<void> addTeamPlayer(int teamId, int userId, String teamPosition,
    int number, AvailabilityData playingStatus) async {
  final apiUrl = '$apiBaseUrl/team_player';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "team_id": teamId,
        "player_id": userId,
        "team_position": teamPosition,
        "player_team_number": 0,
        "playing_status": playingStatus.message,
        "lineup_status": ""
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added data to the backend
      print("Successfully added player to team");
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

class AddPlayerScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedRole = ref.watch(positionProvider);
    AvailabilityData selectedStatus = ref.watch(availabilityProvider);

    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Players"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
            padding: const EdgeInsets.all(35),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Add Player to Team',
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  )),
              Divider(
                color: AppColours.darkBlue,
                thickness: 1.0,
                height: 40.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter registered player email:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        cursorColor: AppColours.darkBlue,
                        decoration: const InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColours.darkBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColours.darkBlue),
                          ),
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.openSans),
                        ),
                        validator: (String? value) {
                          return (value != null &&
                                  !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value))
                              ? 'Invalid email format.'
                              : null;
                        },
                      ),
                      const SizedBox(height: 10),
                      formFieldBottomBorderController(
                          "Number",
                          _numberController,
                          (value) => (value != null &&
                                  !RegExp(r'^[1-9]|[1-9]\d|99$')
                                      .hasMatch(value))
                              ? 'Number must be from 1-99.'
                              : null),
                      const SizedBox(height: 10),
                      dropdownWithDivider("Position", selectedRole, [
                        teamRoleToText(TeamRole.defense),
                        teamRoleToText(TeamRole.attack),
                        teamRoleToText(TeamRole.midfield),
                        teamRoleToText(TeamRole.goalkeeper),
                      ], (value) {
                        ref.read(positionProvider.notifier).state = value!;
                      }),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Playing Status",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            DropdownButton<AvailabilityData>(
                              value: selectedStatus,
                              items:
                                  availabilityData.map((AvailabilityData item) {
                                return DropdownMenuItem<AvailabilityData>(
                                  value: item,
                                  child: Row(
                                    children: [
                                      Icon(item.icon, color: item.color),
                                      const SizedBox(width: 8),
                                      Text(
                                        item.message,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                ref.read(availabilityProvider.notifier).state =
                                    value!;
                              },
                            ),
                          ]),
                      const SizedBox(height: 40),
                      bigButton("Add Player", () {
                        if (_formKey.currentState!.validate()) {}
                      })
                    ]),
              )
            ])),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
