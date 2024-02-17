import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class EditTeamScreen extends StatefulWidget {
  final int teamId;
  final int managerId;
  const EditTeamScreen(
      {super.key, required this.teamId, required this.managerId});

  @override
  EditTeamScreenState createState() => EditTeamScreenState();
}

class EditTeamScreenState extends State<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();

  late TeamData team;
  late List<LeagueData> leagues = [LeagueData(league_id: 1, league_name: "")];

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();

  Uint8List _teamLogo = Uint8List(0);
  int _selectedLeagueId = 1;
  int _sportId = 1;

  @override
  void initState() {
    super.initState();
    getTeamById(widget.teamId).then((value) => setState(() {
          team = value!;
          _teamNameController.text = team.team_name;
          _teamLocationController.text = team.team_location;
          _teamLogo = team.team_logo;
          _selectedLeagueId = team.league_id;
        }));

    getLeagues().then((value) => setState(() {
          leagues = value;
        }));

    getFirstSportId().then((value) => setState(() {
          _sportId = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        setState(() {
          _teamLogo = Uint8List.fromList(imageBytes);
        });
      }
    }

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
                padding: const EdgeInsets.all(35),
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
                      _teamLogo.isNotEmpty
                          ? Image.memory(
                              _teamLogo,
                              width: 120,
                            )
                          : Image.asset(
                              "lib/assets/icons/logo_placeholder.png",
                              width: 120,
                            ),
                      const SizedBox(height: 10),
                      underlineButtonTransparent("Upload logo", () {
                        pickImage();
                      }),
                    ])),
                    const SizedBox(height: 10),
                    formFieldBottomBorderController(
                        "Team name", _teamNameController, (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'This field is required.'
                          : null;
                    }),
                    const SizedBox(height: 10),
                    formFieldBottomBorderController(
                        "Location", _teamLocationController, (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'This field is required.'
                          : null;
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
                          width: 220,
                          child: DropdownButtonFormField<int>(
                            focusColor: AppColours.darkBlue,
                            value: _selectedLeagueId,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLeagueId = newValue!;
                              });
                            },
                            items: leagues.map((LeagueData option) {
                              return DropdownMenuItem<int>(
                                value: option.league_id,
                                child: Text(option.league_name),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    bigButton("Save Changes", () async {
                      if (_formKey.currentState!.validate()) {
                        await editTeam(
                          widget.teamId,
                          _teamNameController.text,
                          _teamLogo,
                          widget.managerId,
                          _selectedLeagueId,
                          _sportId,
                          _teamLocationController.text,
                        );
                        navigator.push(
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()),
                        );
                      }
                    })
                  ],
                ),
              )),
        ));
  }
}
