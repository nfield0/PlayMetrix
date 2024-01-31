import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
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

Future<int> findPlayerIdByEmail(String email) async {
  const apiUrl = '$apiBaseUrl/users';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"user_type": "player", "user_email": email}));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data != null) {
        return data['player_id'];
      }
      return -1;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      return -1;
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    return -1;
  }
}

Future<void> addTeamPlayer(int teamId, int userId, String teamPosition,
    int number, AvailabilityData playingStatus) async {
  const apiUrl = '$apiBaseUrl/team_player';

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
        "player_team_number": number,
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
  final TextEditingController _emailController = TextEditingController();

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
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Player to Team',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const Divider(
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
                                controller: _emailController,
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
                                    borderSide:
                                        BorderSide(color: AppColours.darkBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColours.darkBlue),
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
                                (value) {
                                  if (value != null &&
                                      RegExp(r'^\d+$').hasMatch(value)) {
                                    int numericValue = int.tryParse(value) ?? 0;

                                    if (numericValue > 0 &&
                                        numericValue < 100) {
                                      return null;
                                    } else {
                                      return "Enter a valid number from 1-99.";
                                    }
                                  }

                                  return "Enter a valid digit.";
                                },
                              ),
                              const SizedBox(height: 10),
                              dropdownWithDivider("Position", selectedRole, [
                                teamRoleToText(TeamRole.defense),
                                teamRoleToText(TeamRole.attack),
                                teamRoleToText(TeamRole.midfield),
                                teamRoleToText(TeamRole.goalkeeper),
                              ], (value) {
                                ref.read(positionProvider.notifier).state =
                                    value!;
                              }),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Playing Status",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    DropdownButton<AvailabilityData>(
                                      value: selectedStatus,
                                      items: availabilityData
                                          .map((AvailabilityData item) {
                                        return DropdownMenuItem<
                                            AvailabilityData>(
                                          value: item,
                                          child: Row(
                                            children: [
                                              Icon(item.icon,
                                                  color: item.color),
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
                                        ref
                                            .read(availabilityProvider.notifier)
                                            .state = value!;
                                      },
                                    ),
                                  ]),
                              const SizedBox(height: 40),
                              bigButton("Add Player", () async {
                                if (_formKey.currentState!.validate()) {
                                  int playerId = await findPlayerIdByEmail(
                                      _emailController.text);

                                  if (playerId != -1) {
                                    await addTeamPlayer(
                                        ref.read(teamIdProvider.notifier).state,
                                        playerId,
                                        ref
                                            .read(positionProvider.notifier)
                                            .state,
                                        int.parse(_numberController.text),
                                        selectedStatus);
                                    ref.read(positionProvider.notifier).state =
                                        teamRoleToText(TeamRole.defense);
                                    ref
                                        .read(availabilityProvider.notifier)
                                        .state = availabilityData[0];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayersScreen()),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Player Not Found',
                                              style: TextStyle(
                                                  color: AppColours.darkBlue,
                                                  fontFamily: AppFonts.gabarito,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                          content: const Text(
                                              'Sorry, player with that email does not exist. Please enter a different email address and try again.',
                                              style: TextStyle(fontSize: 16)),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
