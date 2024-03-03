import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/injury_api_client.dart';
import 'package:play_metrix/api_clients/notification_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/player/edit_player_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class AddInjuryScreen extends StatefulWidget {
  final int playerId;
  final int physioId;
  final UserRole userRole;
  final int teamId;
  const AddInjuryScreen(
      {super.key,
      required this.playerId,
      required this.physioId,
      required this.userRole,
      required this.teamId});

  @override
  AddInjuryScreenState createState() => AddInjuryScreenState();
}

class AddInjuryScreenState extends State<AddInjuryScreen> {
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

  String? selectedInjury;
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

  PlatformFile? injuryReportFile;

  @override
  Widget build(BuildContext context) {
    Future<void> pickInjuryReportPdf() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        if (result.files.isNotEmpty) {
          PlatformFile file = result.files.single;

          setState(() {
            injuryReportFile = file;
          });
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Injury",
            style: TextStyle(
              color: AppColours.darkBlue,
              fontFamily: AppFonts.gabarito,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
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
                              Center(
                                child: DropdownButton<String>(
                                    hint: const Row(
                                      children: [
                                        Icon(
                                          Icons.healing_outlined,
                                          color: Colors.black45,
                                        ),
                                        SizedBox(width: 10),
                                        Text("Choose an injury")
                                      ],
                                    ),
                                    value: selectedInjury,
                                    items: ["Injury 1", "Injury 2", "Injury 3"]
                                        .map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Row(
                                          children: [
                                            Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (p0) {}),
                              ),
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
                              const SizedBox(height: 15),
                              injuryReportFile != null
                                  ? Column(children: [
                                      filePill(
                                          injuryReportFile!.name,
                                          formatBytes(injuryReportFile!.size),
                                          Icons.file_open,
                                          () {}),
                                      const SizedBox(height: 15),
                                      underlineButtonTransparentRedGabarito(
                                          "Remove injury report", () {
                                        setState(() {
                                          injuryReportFile = null;
                                        });
                                      })
                                    ])
                                  : Center(
                                      child: underlineButtonTransparent(
                                          "Upload injury report", () {
                                        pickInjuryReportPdf();
                                      }),
                                    ),
                              const SizedBox(height: 25),
                              bigButton("Add Injury", () {
                                if (_formKey.currentState!.validate()) {
                                  bool isSameDay = selectedDateOfInjury.year ==
                                          selectedDateOfInjury.year &&
                                      selectedDateOfInjury.month ==
                                          selectedDateOfInjury.month &&
                                      selectedDateOfInjury.day ==
                                          selectedDateOfInjury.day;
                                  if (selectedDateOfInjury
                                          .isAfter(DateTime.now()) ||
                                      isSameDay) {
                                    addNotification(
                                        title:
                                            "$playerName has been injured: ${injuryTypeController.text}",
                                        desc:
                                            "Injury location: ${injuryLocationController.text}\n"
                                            "Expected recovery time: ${expectedRecoveryTimeController.text}\n",
                                        date: DateTime.now(),
                                        teamId: widget.teamId,
                                        recieverUserRole: UserRole.manager,
                                        type: NotificationType.injury);

                                    addNotification(
                                        title:
                                            "$playerName has been injured: ${injuryTypeController.text}",
                                        desc:
                                            "Injury location: ${injuryLocationController.text}\n"
                                            "Expected recovery time: ${expectedRecoveryTimeController.text}\n",
                                        date: DateTime.now(),
                                        teamId: widget.teamId,
                                        recieverUserRole: UserRole.coach,
                                        type: NotificationType.injury);

                                    addNotification(
                                        title:
                                            "$playerName has been injured: ${injuryTypeController.text}",
                                        desc:
                                            "Injury location: ${injuryLocationController.text}\n"
                                            "Expected recovery time: ${expectedRecoveryTimeController.text}\n",
                                        date: DateTime.now(),
                                        teamId: widget.teamId,
                                        recieverUserRole: UserRole.player,
                                        type: NotificationType.injury);
                                  }

                                  addInjury(
                                      playerId: widget.playerId,
                                      physioId: widget.physioId,
                                      injuryType: injuryTypeController.text,
                                      injuryLocation:
                                          injuryLocationController.text,
                                      expectedRecoveryTime:
                                          expectedRecoveryTimeController.text,
                                      recoveryMethod:
                                          recoveryMethodController.text,
                                      dateOfInjury: selectedDateOfInjury,
                                      dateOfRecovery: selectedDateOfRecovery,
                                      injuryReport: injuryReportFile!.bytes);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditPlayerProfileScreen(
                                                  physioId: widget.physioId,
                                                  playerId: widget.playerId,
                                                  userRole: widget.userRole,
                                                  teamId: widget.teamId)));
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: physioBottomNavBar(context, 0));
  }
}
