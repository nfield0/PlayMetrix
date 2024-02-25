import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/injury_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/player/player_profile_view_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

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
                              }, context),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Injury location", injuryLocationController,
                                  (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }, context),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Expected recovery time",
                                  expectedRecoveryTimeController, (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }, context),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Recovery method", recoveryMethodController,
                                  (value) {
                                return (value != null && value.isEmpty)
                                    ? 'This field is required.'
                                    : null;
                              }, context),
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
        bottomNavigationBar: physioBottomNavBar(context, 0));
  }
}
