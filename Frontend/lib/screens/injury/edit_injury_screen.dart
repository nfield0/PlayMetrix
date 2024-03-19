import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/injury_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/screens/injury/add_injury_screen.dart';
import 'package:play_metrix/screens/player/player_profile_view_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class EditInjuryScreen extends StatefulWidget {
  final int playerId;
  final int physioId;
  final int playerInjuryId;

  const EditInjuryScreen({
    super.key,
    required this.playerId,
    required this.physioId,
    required this.playerInjuryId,
  });

  @override
  EditInjuryScreenState createState() => EditInjuryScreenState();
}

class EditInjuryScreenState extends State<EditInjuryScreen> {
  final _formKey = GlobalKey<FormState>();

  String playerName = "";
  Uint8List playerImage = Uint8List(0);

  DateTime selectedDateOfInjury = DateTime.now();
  DateTime selectedDateOfRecovery = DateTime.now();

  Injury? selectedInjury;
  int selectedInjuryId = 0;

  PlatformFile? injuryReportFile;

  @override
  void initState() {
    super.initState();

    getPlayerById(widget.playerId).then((player) {
      setState(() {
        playerName = "${player.firstName} ${player.surname}";
        playerImage = player.image;
      });
    });

    getPlayerInjuryById(widget.playerInjuryId).then((injury) {
      setState(() {
        selectedInjuryId = injury.injuryId;
        selectedInjury = Injury(
            id: injury.injuryId,
            type: injury.type,
            nameAndGrade: injury.nameAndGrade,
            location: injury.location,
            potentialRecoveryMethods: injury.potentialRecoveryMethods,
            expectedMinRecoveryTime: injury.expectedMinRecoveryTime,
            expectedMaxRecoveryTime: injury.expectedMaxRecoveryTime);
        selectedDateOfInjury = injury.dateOfInjury;
        selectedDateOfRecovery = injury.expectedDateOfRecovery;
        injuryReportFile = injury.playerInjuryReport != null
            ? PlatformFile(
                name: "Injury Report",
                size: injury.playerInjuryReport!.length,
                bytes: injury.playerInjuryReport)
            : null;
      });
    });
  }

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
            'Edit Injury',
            style: TextStyle(
                color: AppColours.darkBlue,
                fontSize: 24,
                fontFamily: AppFonts.gabarito,
                fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                        padding: const EdgeInsets.all(35),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.always,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: Column(children: [
                                        playerImage.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(75),
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
                                      const SizedBox(height: 10),
                                      Center(
                                        child: DropdownSearch<Injury>(
                                          popupProps: const PopupProps.menu(
                                              searchDelay:
                                                  Duration(milliseconds: 0),
                                              searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Search for injury",
                                                      labelStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              AppFonts.gabarito,
                                                          color:
                                                              Colors.black45),
                                                      icon: Icon(Icons.search)),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          AppFonts.gabarito)),
                                              showSearchBox: true),
                                          asyncItems: (String query) =>
                                              getInjuries(query),
                                          itemAsString: (Injury i) =>
                                              i.nameAndGrade,
                                          dropdownDecoratorProps:
                                              const DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                    icon: Icon(
                                                      Icons.healing,
                                                    ),
                                                    labelText: "Choose Injury"),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedInjury = value;
                                              selectedInjuryId = value!.id;
                                            });
                                          },
                                          selectedItem: selectedInjury,
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      if (selectedInjury != null)
                                        injuryDetails(selectedInjury!, context),
                                      greyDivider(),
                                      const SizedBox(height: 7),
                                      datePickerNoDivider(
                                          context,
                                          "Date of injury",
                                          selectedDateOfInjury, (date) {
                                        setState(() {
                                          selectedDateOfInjury = date;
                                        });
                                      }),
                                      const SizedBox(height: 5),
                                      datePickerNoDividerTooltip(
                                          context,
                                          "Date of recovery",
                                          selectedDateOfRecovery, (date) {
                                        setState(() {
                                          selectedDateOfRecovery = date;
                                        });
                                      }, "Enter expected date of recovery if player is not recovered, or actual date of recovery if player is recovered"),
                                      const SizedBox(height: 15),
                                      injuryReportFile != null
                                          ? Column(children: [
                                              filePill(
                                                  injuryReportFile!.name,
                                                  formatBytes(
                                                      injuryReportFile!.size),
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
                                      bigButton("Edit Injury", () async {
                                        if (_formKey.currentState!.validate()) {
                                          await updatePlayerInjury(
                                              injuryId: selectedInjuryId,
                                              physioId: widget.physioId,
                                              dateOfInjury:
                                                  selectedDateOfInjury,
                                              dateOfRecovery:
                                                  selectedDateOfRecovery,
                                              playerId: widget.playerId,
                                              injuryReport:
                                                  injuryReportFile?.bytes);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayerProfileViewScreen(
                                                          playerId: widget
                                                              .playerId))).then(
                                            (value) {
                                              setState(() {});
                                            },
                                          );
                                        }
                                      })
                                    ]),
                              )
                            ]))))),
        bottomNavigationBar: physioBottomNavBar(context, 0));
  }
}
