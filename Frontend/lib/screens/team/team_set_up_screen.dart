import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class TeamSetUpScreen extends ConsumerWidget {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();

  TeamSetUpScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        ref.read(teamLogoProvider.notifier).state =
            Uint8List.fromList(imageBytes);
      }
    }

    int userId = ref.watch(userIdProvider.notifier).state;
    int leagueId = ref.watch(leagueProvider);
    Uint8List? logo = ref.watch(teamLogoProvider);

    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'lib/assets/logo.png',
            width: 150,
            fit: BoxFit.contain,
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Container(
            padding: EdgeInsets.all(35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Team Set Up',
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
                  logo != null
                      ? Image.memory(
                          logo,
                          width: 100,
                        )
                      : Image.asset(
                          "lib/assets/icons/logo_placeholder.png",
                          width: 100,
                        ),
                  const SizedBox(height: 10),
                  underlineButtonTransparent("Upload logo", () {
                    pickImage();
                  }),
                ])),
                // formFieldBottomBorder("Club name", ""), // NOT IN BACKEND ENDPOINT
                // const SizedBox(height: 10),
                formFieldBottomBorderController(
                    "Team name", _teamNameController, (value) {
                  return "";
                }),
                const SizedBox(height: 10),
                formFieldBottomBorderController(
                    "Location", _teamLocationController, (value) {
                  return "";
                }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "League",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      // Wrap the DropdownButtonFormField with a Container
                      width: 220, // Provide a specific width
                      child: FutureBuilder<List<LeagueData>>(
                        future: getAllLeagues(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<LeagueData> leagues = snapshot.data!;
                            // Initialize the selectedTeam with the first team name
                            if (leagueId == 0 && leagues.isNotEmpty) {
                              leagueId = leagues[0].league_id;
                              Future.delayed(Duration.zero, () {
                                ref.read(leagueProvider.notifier).state =
                                    leagueId;
                              });
                            }

                            return DropdownButton<int>(
                              value: leagueId,
                              items: leagues.map((LeagueData league) {
                                return DropdownMenuItem<int>(
                                  value: league.league_id,
                                  child: Text(
                                    league.league_name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // Update the selectedTeam when the user makes a selection
                                ref.read(leagueProvider.notifier).state =
                                    value!;
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error loading leagues");
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                bigButton("Save Changes", () async {
                  int teamId = await addTeam(
                      _teamNameController.text,
                      ref.read(teamLogoProvider.notifier).state,
                      userId,
                      await getFirstSportId(),
                      leagueId,
                      _teamLocationController.text);
                  if (teamId != -1) {
                    ref.read(teamIdProvider.notifier).state = teamId;
                    navigator.push(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    _teamNameController.clear();
                    _teamLocationController.clear();
                    ref.read(teamLogoProvider.notifier).state = null;
                  }
                })
              ],
            ),
          )),
        ));
  }
}
