import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'dart:convert';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class AddTeamData {
  final String team_name;
  final Uint8List? team_logo;
  final int manager_id;
  final int league_id;
  final int sport_id;
  final String team_location;

  AddTeamData({
    required this.team_name,
    required this.team_logo,
    required this.manager_id,
    required this.sport_id,
    required this.league_id,
    required this.team_location,
  });
}
Future<String> addTeam(String teamName, Uint8List? imageBytes, int managerId, int sportId, int leagueId, String teamLocation) async {
  final apiUrl = 'http://127.0.0.1:8000/teams/'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'team_name': teamName,
        'team_logo': imageBytes != null ? base64Encode(imageBytes) : "",
        'manager_id': managerId,
        'sport_id': sportId,
        'league_id': leagueId,
        'team_location': teamLocation,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      print("Team added successfully");
      print("Response: ${response.body}");
      return response.body;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve team data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve team data');
  }
}


final divisionProvider = StateProvider<int>((ref) => 0);
final teamIdProvider = StateProvider<int>((ref) => 0);
// class TeamSetUpScreen extends StatefulWidget {
//   const TeamSetUpScreen({Key? key}) : super(key: key);

//   @override
//   _TeamSetUpScreenState createState() => _TeamSetUpScreenState();
  
// }

class TeamSetUpScreen extends ConsumerWidget {
  String selectedDivisionValue = "Division 1";

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamLogoController = TextEditingController();
  final TextEditingController _managerIdController = TextEditingController();
  final TextEditingController _leagueIdController = TextEditingController();
  final TextEditingController _sportIdController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        ref.read(profilePictureProvider.notifier).state =
            Uint8List.fromList(imageBytes);
      }
    }

    final userRole = ref.watch(userRoleProvider.notifier).state;
    Uint8List? profilePicture = ref.watch(profilePictureProvider);
    int userId = ref.watch(userIdProvider.notifier).state;
    int divisionId = ref.watch(divisionProvider.notifier).state;
    int teamId = ref.watch(teamIdProvider.notifier).state;

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
      body: Form(
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
              Image.asset(
                "lib/assets/icons/logo_placeholder.png",
                width: 100,
              ),
              const SizedBox(height: 10),
              underlineButtonTransparent("Upload logo", () { pickImage(); }),
            ])),
            // formFieldBottomBorder("Club name", ""), // NOT IN BACKEND ENDPOINT
            // const SizedBox(height: 10),
            formFieldBottomBorder("Team name", _teamNameController.text),
            const SizedBox(height: 10),
            formFieldBottomBorder("Location", _teamLocationController.text),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Division",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  // Wrap the DropdownButtonFormField with a Container
                  width: 220, // Provide a specific width
                  child: DropdownButtonFormField<String>(
                    focusColor: AppColours.darkBlue,
                    value: selectedDivisionValue,
                    onChanged: (newValue) {
                      // setState(() {
                        selectedDivisionValue = newValue!;
                      // });
                    },
                    items: ['Division 1', 'Division 2', 'Division 3']
                        .map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            bigButton("Save Changes", () async {
                    if (selectedDivisionValue == "Division 1") {
                      divisionId = 1;
                    } else if (selectedDivisionValue == "Division 2") {
                      divisionId = 2;
                    } else if (selectedDivisionValue == "Division 3") {
                      divisionId = 3;
                    }
                    String teamId = await addTeam(_teamNameController.text, ref.read(profilePictureProvider.notifier).state, userId, 1, divisionId, _teamLocationController.text);  
                    ref.read(teamIdProvider.notifier).state = int.parse(teamId);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeamProfileScreen()),
              );
            })
          ],
        ),
      )),
    );
  }
}
