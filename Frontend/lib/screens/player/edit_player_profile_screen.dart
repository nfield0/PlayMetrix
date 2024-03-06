import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/injury/add_injury_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/settings/settings_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:input_quantity/input_quantity.dart';

class EditPlayerProfileScreen extends StatefulWidget {
  final int playerId;
  final UserRole userRole;
  final int teamId;
  final int physioId;

  const EditPlayerProfileScreen(
      {super.key,
      required this.physioId,
      required this.playerId,
      required this.userRole,
      required this.teamId});

  @override
  EditPlayerProfileScreenState createState() => EditPlayerProfileScreenState();
}

class EditPlayerProfileScreenState extends State<EditPlayerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late PlayerData playerData;
  late TeamPlayerData teamPlayerData;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  final List<AvailabilityData> availability = [
    AvailabilityData(AvailabilityStatus.available, "Available",
        Icons.check_circle, AppColours.green),
    AvailabilityData(AvailabilityStatus.limited, "Limited", Icons.warning,
        AppColours.yellow),
    AvailabilityData(AvailabilityStatus.unavailable, "Unavailable",
        Icons.cancel, AppColours.red)
  ];

  DateTime _selectedDob = DateTime.now();
  Uint8List _profilePicture = Uint8List(0);
  String _selectedGender = 'Male';
  AvailabilityStatus _selectedAvailability = AvailabilityStatus.available;
  String _selectedPosition = teamRoleToText(TeamRole.defense);
  String _selectedLineupStatus = lineupStatusToText(LineupStatus.starter);
  String playerName = "";

  int? _matchesPlayed;
  int? _matchesStarted;
  int? _matchesOffTheBench;

  @override
  void initState() {
    super.initState();
    getPlayerData(widget.playerId).then((value) {
      setState(() {
        playerData = value;
        _firstNameController.text = playerData.player_firstname;
        _surnameController.text = playerData.player_surname;
        _contactNumberController.text = playerData.player_contact_number;
        _heightController.text = playerData.player_height;
        _selectedDob = playerData.player_dob;
        _profilePicture = playerData.player_image;
        _selectedGender = playerData.player_gender;
        playerName =
            "${playerData.player_firstname} ${playerData.player_surname}";
      });
    });

    getTeamPlayerData(widget.teamId, widget.playerId).then((value) {
      setState(() {
        teamPlayerData = value;
        _numberController.text = teamPlayerData.playerTeamNumber.toString();
        _selectedAvailability =
            stringToAvailabilityStatus(teamPlayerData.playingStatus);
        _selectedPosition = teamPlayerData.teamPosition;
        _selectedLineupStatus = teamPlayerData.lineupStatus;
        _reasonController.text = teamPlayerData.reasonForStatus;
      });
    });

    getStatisticsData(widget.playerId).then((value) {
      setState(() {
        _matchesPlayed = value.matchesPlayed;
        _matchesStarted = value.matchesStarted;
        _matchesOffTheBench = value.matchesOffTheBench;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    final nameRegex = RegExp(r'^[A-Za-z]+$');
    final phoneRegex = RegExp(r'^(?:\+\d{1,3}\s?)?\d{9,15}$');
    final heightRegex = RegExp(r'^[1-9]\d{0,2}(\.\d{1,2})?$');

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        setState(() {
          _profilePicture = Uint8List.fromList(imageBytes);
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: widget.userRole == UserRole.physio
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      const Text('Edit Player',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          )),
                      smallButton(Icons.add_circle_outline, "Add Injury", () {
                        navigator.push(
                          MaterialPageRoute(
                              builder: (context) => AddInjuryScreen(
                                    physioId: widget.physioId,
                                    userRole: widget.userRole,
                                    teamId: widget.teamId,
                                    playerId: widget.playerId,
                                  )),
                        );
                      })
                    ])
              : const Text('Edit Player',
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  )),
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
                        padding: const EdgeInsets.only(
                            bottom: 35, left: 35, right: 35),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.always,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: Column(children: [
                                        _profilePicture.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(75),
                                                child: Image.memory(
                                                  _profilePicture,
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Image.asset(
                                                "lib/assets/icons/profile_placeholder.png",
                                                width: 120,
                                              ),
                                        const SizedBox(height: 10),
                                        if (widget.userRole == UserRole.player)
                                          underlineButtonTransparent(
                                              "Upload picture", () {
                                            pickImage();
                                          }),
                                        if (widget.userRole != UserRole.player)
                                          const SizedBox(height: 15),
                                        if (widget.userRole != UserRole.player)
                                          Text(playerName,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: AppFonts.gabarito,
                                                  fontWeight: FontWeight.bold)),
                                        if (widget.userRole != UserRole.player)
                                          const SizedBox(height: 15),
                                      ])),
                                      if (widget.userRole == UserRole.manager ||
                                          widget.userRole == UserRole.physio)
                                        Column(children: [
                                          Center(
                                            child: availabilityDropdown(
                                                _selectedAvailability,
                                                availability, (value) {
                                              setState(() {
                                                _selectedAvailability = value!;
                                              });
                                            }),
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color: AppColours.darkBlue,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: formFieldBottomBorderNoTitle(
                                                "Reason for status change",
                                                "",
                                                false,
                                                _reasonController, (value) {
                                              return null;
                                            }),
                                          ),
                                          const SizedBox(height: 15),
                                        ]),
                                      if (widget.userRole == UserRole.player)
                                        Column(children: [
                                          const SizedBox(height: 15),
                                          formFieldBottomBorderController(
                                              "First Name",
                                              _firstNameController, (value) {
                                            return (value != null &&
                                                    !nameRegex.hasMatch(value))
                                                ? 'Invalid first name.'
                                                : null;
                                          }, context),
                                          formFieldBottomBorderController(
                                              "Surname", _surnameController,
                                              (value) {
                                            return (value != null &&
                                                    !nameRegex.hasMatch(value))
                                                ? 'Invalid surname.'
                                                : null;
                                          }, context),
                                          formFieldBottomBorderController(
                                              "Phone", _contactNumberController,
                                              (value) {
                                            return (value != null &&
                                                    !phoneRegex.hasMatch(value))
                                                ? 'Invalid phone number.'
                                                : null;
                                          }, context),
                                          formFieldBottomBorderController(
                                              "Height", _heightController,
                                              (value) {
                                            return (value != null &&
                                                    !heightRegex
                                                        .hasMatch(value))
                                                ? 'Invalid height.'
                                                : null;
                                          }, context),
                                          datePickerNoDivider(
                                              context,
                                              "Date of birth",
                                              _selectedDob, (value) {
                                            setState(() {
                                              _selectedDob = value;
                                            });
                                          }),
                                          dropdownWithDivider(
                                              "Gender",
                                              _selectedGender,
                                              ["Male", "Female", "Others"],
                                              (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                            });
                                          }),
                                        ]),
                                      const SizedBox(height: 10),
                                      if (widget.userRole == UserRole.manager)
                                        Column(children: [
                                          greyDivider(),
                                          const SizedBox(height: 15),
                                          sectionHeader("Team Details"),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    "Number",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              const SizedBox(width: 30),
                                              Container(
                                                width: 115,
                                                child: TextFormField(
                                                  controller: _numberController,
                                                  decoration:
                                                      const InputDecoration(
                                                    // labelText: 'Your Label',
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value != null &&
                                                        RegExp(r'^\d+$')
                                                            .hasMatch(value)) {
                                                      int numericValue =
                                                          int.tryParse(value) ??
                                                              0;

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
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          dropdownWithDivider(
                                              "Position", _selectedPosition, [
                                            teamRoleToText(TeamRole.defense),
                                            teamRoleToText(TeamRole.attack),
                                            teamRoleToText(TeamRole.midfield),
                                            teamRoleToText(TeamRole.goalkeeper),
                                          ], (value) {
                                            setState(() {
                                              _selectedPosition = value!;
                                            });
                                          }),
                                          const SizedBox(height: 10),
                                          dropdownWithDivider("Lineup Status",
                                              _selectedLineupStatus, [
                                            lineupStatusToText(
                                                LineupStatus.starter),
                                            lineupStatusToText(
                                                LineupStatus.substitute),
                                            lineupStatusToText(
                                                LineupStatus.reserve)
                                          ], (value) {
                                            setState(() {
                                              _selectedLineupStatus = value!;
                                            });
                                          }),
                                        ]),
                                      const SizedBox(height: 10),
                                      if (widget.userRole == UserRole.manager &&
                                          _matchesPlayed != null &&
                                          _matchesStarted != null &&
                                          _matchesOffTheBench != null)
                                        Column(
                                          children: [
                                            greyDivider(),
                                            const SizedBox(height: 15),
                                            sectionHeader("Statistics"),
                                            const SizedBox(height: 35),
                                            inputQuantity("Matches played",
                                                _matchesPlayed!, (value) {
                                              _matchesPlayed = value;
                                            }),
                                            const SizedBox(height: 35),
                                            inputQuantity("Matches started",
                                                _matchesStarted!, (value) {
                                              _matchesStarted = value;
                                            }),
                                            const SizedBox(height: 35),
                                            inputQuantity(
                                                "Matches off the bench",
                                                _matchesOffTheBench!, (value) {
                                              _matchesOffTheBench = value;
                                            }),
                                            // const SizedBox(height: 35),
                                            // inputQuantity(
                                            //     "Total minutes played",
                                            //     _totalMinutesPlayed!, (value) {
                                            //   _totalMinutesPlayed = value;
                                            // }),
                                            const SizedBox(height: 30),
                                          ],
                                        ),
                                      const SizedBox(height: 15),
                                      bigButton("Save Changes", () async {
                                        if (_formKey.currentState!.validate()) {
                                          await editPlayerProfile(
                                              widget.playerId,
                                              _firstNameController.text,
                                              _surnameController.text,
                                              _contactNumberController.text,
                                              _selectedDob,
                                              _heightController.text,
                                              _selectedGender,
                                              _profilePicture);

                                          if (widget.teamId != -1) {
                                            await updateTeamPlayer(
                                                widget.teamId,
                                                widget.playerId,
                                                int.parse(
                                                    _numberController.text),
                                                availabilityStatusText(
                                                    _selectedAvailability),
                                                _selectedPosition,
                                                _selectedLineupStatus,
                                                _reasonController.text);
                                          }

                                          await updatePlayerStatistics(
                                              widget.playerId,
                                              _matchesPlayed!,
                                              _matchesStarted!,
                                              _matchesOffTheBench!);

                                          navigator.push(
                                            MaterialPageRoute(
                                                builder: (context) => widget
                                                            .userRole ==
                                                        UserRole.manager
                                                    ? PlayersScreen()
                                                    : PlayerProfileScreen()),
                                          );
                                        }
                                      })
                                    ]),
                              )
                            ]))))),
        bottomNavigationBar:
            roleBasedBottomNavBar(widget.userRole, context, 2));
  }
}

Widget availabilityDropdown(
    AvailabilityStatus selectedAvailability,
    List<AvailabilityData> availability,
    void Function(AvailabilityStatus?)? onChanged) {
  return DropdownButton<AvailabilityStatus>(
    value: selectedAvailability,
    items: availability.map((AvailabilityData item) {
      return DropdownMenuItem<AvailabilityStatus>(
        value: item.status,
        child: Row(
          children: [
            Icon(item.icon, color: item.color),
            const SizedBox(width: 8),
            Text(
              item.message,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

Widget inputQuantity(
    String title, int initVal, void Function(dynamic)? onChanged) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          InputQty.int(
            maxVal: 2000,
            initVal: initVal,
            minVal: 0,
            steps: 1,
            decoration: const QtyDecorationProps(
                isBordered: false,
                borderShape: BorderShapeBtn.circle,
                width: 12,
                btnColor: AppColours.darkBlue),
            onQtyChanged: onChanged,
          )
        ],
      )
    ],
  );
}
