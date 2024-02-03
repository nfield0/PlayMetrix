import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updateInjury({
  required int injuryId,
  required String injuryType,
  required String expectedRecoveryTime,
  required String recoveryMethod,
}) async {
  final apiUrl =
      '$apiBaseUrl/injuries/$injuryId/'; // Replace with your actual backend URL

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'injury_type': injuryType,
        'expected_recovery_time': expectedRecoveryTime,
        'recovery_method': recoveryMethod,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated, handle the response accordingly
      print('Update successful!');
      print('Response: ${response.body}');
      // You can parse the response JSON here and perform actions based on it
    } else {
      // Failed to update, handle the error accordingly
      print('Failed to update. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

// Future<AllPlayerInjuriesData> getPlayerInjuryById(int injuryId, int playerId) async {

// }

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
                              bigButton("Add Injury", () {
                                if (_formKey.currentState!.validate()) {}
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
