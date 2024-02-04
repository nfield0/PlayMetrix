import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/player_profile_view_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updateInjury({
  required int injuryId,
  required String injuryType,
  required String injuryLocation,
  required String expectedRecoveryTime,
  required String recoveryMethod,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
  required int playerId,
}) async {
  final apiUrl = '$apiBaseUrl/injuries/$injuryId';
  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'injury_type': injuryType,
        'injury_location': injuryLocation,
        'expected_recovery_time': expectedRecoveryTime,
        'recovery_method': recoveryMethod,
      }),
    );

    final playerInjuryApiUrl = "$apiBaseUrl/player_injuries/$playerId";
    final playerInjuryResponse = await http.put(
      Uri.parse(playerInjuryApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "injury_id": injuryId,
        "date_of_injury": dateOfInjury.toIso8601String(),
        "date_of_recovery": dateOfRecovery.toIso8601String(),
        "player_id": playerId
      }),
    );

    if (response.statusCode == 200 && playerInjuryResponse.statusCode == 200) {
      // Successfully updated, handle the response accordingly
      print('Update successful!');
      print('Response: ${playerInjuryResponse.body}');
      // You can parse the response JSON here and perform actions based on it
    } else {
      // Failed to update, handle the error accordingly
      print(
          'Failed to update. Status code: ${playerInjuryResponse.statusCode}');
      print('Error message: ${playerInjuryResponse.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<AllPlayerInjuriesData> getPlayerInjuryById(
    int injuryId, int playerId) async {
  final apiUrl = "$apiBaseUrl/injuries/$injuryId";

  final response = await http.get(Uri.parse(apiUrl));

  final injuryData = jsonDecode(response.body);

  if (response.statusCode == 200) {
    final playerInjuryApiUrl = "$apiBaseUrl/player_injuries/$playerId";

    final playerInjuryResponse = await http.get(Uri.parse(playerInjuryApiUrl));

    if (playerInjuryResponse.statusCode == 200) {
      List<dynamic> playerInjuriesJson = jsonDecode(playerInjuryResponse.body);

      for (var injury in playerInjuriesJson) {
        if (injury['injury_id'] == injuryId) {
          return AllPlayerInjuriesData(
              injuryId,
              injuryData['injury_type'],
              injuryData['injury_location'],
              injuryData['expected_recovery_time'],
              injuryData['recovery_method'],
              injury['date_of_injury'],
              injury['date_of_recovery'],
              playerId);
        }
      }
    } else {
      throw Exception('Failed to load player injuries');
    }
  } else {
    throw Exception('Failed to load player injuries');
  }
  throw Exception('Failed to load player injuries');
}

class EditInjuryScreen extends StatefulWidget {
  final int playerId;
  final int injuryId;
  const EditInjuryScreen(
      {super.key, required this.playerId, required this.injuryId});

  @override
  EditInjuryScreenState createState() => EditInjuryScreenState();
}

class EditInjuryScreenState extends State<EditInjuryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController injuryTypeController = TextEditingController();
  final TextEditingController injuryLocationController =
      TextEditingController();
  final TextEditingController expectedRecoveryTimeController =
      TextEditingController();
  final TextEditingController recoveryMethodController =
      TextEditingController();

  String playerName = "";
  Uint8List playerImage = Uint8List(0);

  DateTime selectedDateOfInjury = DateTime.now();
  DateTime selectedDateOfRecovery = DateTime.now();

  @override
  void initState() {
    super.initState();

    getPlayerById(widget.playerId).then((player) {
      setState(() {
        playerName = "${player.player_firstname} ${player.player_surname}";
        playerImage = player.player_image;
      });
    });

    getPlayerInjuryById(widget.injuryId, widget.playerId).then((injury) {
      setState(() {
        injuryTypeController.text = injury.injury_type;
        injuryLocationController.text = injury.injury_location;
        expectedRecoveryTimeController.text = injury.expected_recovery_time;
        recoveryMethodController.text = injury.recovery_method;
        selectedDateOfInjury = DateTime.parse(injury.date_of_injury);
        selectedDateOfRecovery = DateTime.parse(injury.date_of_recovery);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Player Profile"),
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
                      const Text('Edit Injury',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 10),
                      divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Column(children: [
                                playerImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: Image.memory(
                                          playerImage,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        "lib/assets/icons/profile_placeholder.png",
                                        width: 120,
                                      ),
                                const SizedBox(height: 15),
                                Text(playerName,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gabarito,
                                        fontWeight: FontWeight.bold)),
                              ])),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Injury type", injuryTypeController, (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Injury location", injuryLocationController,
                                  (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Expected recovery time",
                                  expectedRecoveryTimeController, (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Recovery method", recoveryMethodController,
                                  (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 7),
                              datePickerNoDivider(context, "Date of injury",
                                  selectedDateOfInjury, (date) {
                                setState(() {
                                  selectedDateOfInjury = date;
                                });
                              }),
                              const SizedBox(height: 5),
                              datePickerNoDivider(context, "Date of recovery",
                                  selectedDateOfRecovery, (date) {
                                setState(() {
                                  selectedDateOfRecovery = date;
                                });
                              }),
                              const SizedBox(height: 25),
                              bigButton("Edit Injury", () {
                                if (_formKey.currentState!.validate()) {
                                  updateInjury(
                                      injuryId: widget.injuryId,
                                      injuryType: injuryTypeController.text,
                                      injuryLocation:
                                          injuryLocationController.text,
                                      expectedRecoveryTime:
                                          expectedRecoveryTimeController.text,
                                      recoveryMethod:
                                          recoveryMethodController.text,
                                      dateOfInjury: selectedDateOfInjury,
                                      dateOfRecovery: selectedDateOfRecovery,
                                      playerId: widget.playerId);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayerProfileViewScreen(
                                                  userId: widget.playerId)));
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
