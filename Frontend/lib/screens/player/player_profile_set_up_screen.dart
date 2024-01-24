import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final dobProvider = StateProvider<DateTime>((ref) => DateTime.now());
final genderProvider = StateProvider<String>((ref) => "Male");

class TeamPlayerData {
  final int team_id;
  final int player_id;
  final String? team_position;
  final int player_team_number;
  final String? playing_status;
  final String? lineup_status;

  TeamPlayerData({
    required this.team_id,
    required this.player_id,
    required this.team_position,
    required this.player_team_number,
    required this.playing_status,
    required this.lineup_status,
  });
}

Future<TeamPlayerData> getTeamPlayerData(int teamId, int playerId) async {
  final apiUrl = '$apiBaseUrl/team_player/$teamId';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final List<dynamic> playerList = jsonDecode(response.body);

      // Find the player with the specified playerId
      Map<String, dynamic>? playerData;
      for (var player in playerList) {
        if (player['player_id'] == playerId) {
          playerData = player;
          break;
        }
      }

      if (playerData != null) {
        print('Team ID: ${playerData['team_id']}');
        print('Player ID: ${playerData['player_id']}');
        print('Team Position: ${playerData['team_position']}');
        print('Player Team Number: ${playerData['player_team_number']}');
        print('Playing Status: ${playerData['playing_status']}');
        print('Lineup Status: ${playerData['lineup_status']}');

        return TeamPlayerData(
          team_id: playerData['team_id'],
          player_id: playerData['player_id'],
          team_position: playerData['team_position'],
          player_team_number: playerData['player_team_number'],
          playing_status: playerData['playing_status'],
          lineup_status: playerData['lineup_status'],
        );
      } else {
        throw Exception('Player not found');
      }
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception('Player not found');
}

Future<void> updateTeamPlayer(TeamPlayerData teamPlayer, int number) async {
  final apiUrl = '$apiBaseUrl/team_player';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'player_id': teamPlayer.player_id,
        'team_id': teamPlayer.team_id,
        'team_position': teamPlayer.team_position,
        'player_team_number': number,
        'playing_status': teamPlayer.playing_status,
        'lineup_status': teamPlayer.lineup_status,
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<PlayerData> getPlayerProfile(int id) async {
  final apiUrl = '$apiBaseUrl/players/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      print('Player ID: $id');
      print('Player First Name: ${parsed['player_firstname']}');
      print('Player Surname: ${parsed['player_surname']}');
      print('Player Contact Number: ${parsed['player_contact_number']}');
      print('Player Date of Birth: ${parsed['player_dob']}');
      print('Player Height: ${parsed['player_height']}');
      print('Player Gender: ${parsed['player_gender']}');
      print('Player Image: ${parsed['player_image']}');

      DateTime playerDob;
      if (parsed['player_dob'] != null && parsed['player_dob'] != "") {
        playerDob = DateTime.parse(parsed['player_dob']);
      } else {
        playerDob = DateTime.now();
      }

      Uint8List? playerImage;
      if (parsed['player_image'] != null && parsed['player_image'] != "") {
        playerImage = base64.decode(parsed['player_image']);
      } else {
        playerImage = null; // Or set it to an empty Uint8List
      }

      return PlayerData(
        player_id: id,
        player_firstname: parsed['player_firstname'],
        player_surname: parsed['player_surname'],
        player_contact_number: parsed['player_contact_number'],
        player_dob: playerDob,
        player_height: parsed['player_height'],
        player_gender: parsed['player_gender'],
        player_image: playerImage,
      );
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception('Player not found');
}

Future<void> updatePlayerProfile(
    int id,
    PlayerData player,
    String contactNumber,
    DateTime dob,
    String height,
    String gender,
    Uint8List? image) async {
  final apiUrl = '$apiBaseUrl/players/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'player_id': id,
        'player_firstname': player.player_firstname,
        'player_surname': player.player_surname,
        'player_contact_number': contactNumber,
        'player_dob': dob.toIso8601String(),
        'player_height': height,
        'player_gender': gender,
        'player_image': image != null ? base64Encode(image) : "",
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

class PlayerProfileSetUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int teamId = ref.watch(teamIdProvider);
    int playerId = ref.watch(userIdProvider);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();

        ref.read(profilePictureProvider.notifier).state =
            Uint8List.fromList(imageBytes);
      }
    }

    Uint8List? profilePicture = ref.watch(profilePictureProvider);
    DateTime selectedDob = ref.watch(dobProvider);
    String selectedGender = ref.watch(genderProvider);

    final phoneRegex = RegExp(r'^(?:\+\d{1,3}\s?)?\d{9,15}$');
    final heightRegex = RegExp(r'^[1-9]\d{0,2}(\.\d{1,2})?$');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          child: Container(
              padding: const EdgeInsets.all(35),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Profile Set Up',
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
                              profilePicture != null
                                  ? Image.memory(
                                      profilePicture,
                                      width: 100,
                                    )
                                  : Image.asset(
                                      "lib/assets/icons/profile_placeholder.png",
                                      width: 100,
                                    ),
                              const SizedBox(height: 10),
                              underlineButtonTransparent("Upload picture", () {
                                pickImage();
                              }),
                            ])),
                            datePickerNoDivider(
                                context, "Date of birth", selectedDob, (value) {
                              ref.read(dobProvider.notifier).state = value;
                            }),
                            formFieldBottomBorderController(
                                "Height (cm)", _heightController, (value) {
                              return (value != null &&
                                      !heightRegex.hasMatch(value))
                                  ? 'Invalid height.'
                                  : null;
                            }),
                            formFieldBottomBorderController(
                                "Phone", _phoneController, (value) {
                              return (value != null &&
                                      !phoneRegex.hasMatch(value))
                                  ? 'Invalid phone number.'
                                  : null;
                            }),
                            const SizedBox(height: 5),
                            dropdownWithDivider("Gender", selectedGender,
                                ["Male", "Female", "Others"], (value) {
                              ref.read(genderProvider.notifier).state = value!;
                            }),
                            const SizedBox(height: 50),
                            bigButton("Save Changes", () async {
                              if (_formKey.currentState!.validate()) {
                                PlayerData player =
                                    await getPlayerProfile(playerId);
                                await updatePlayerProfile(
                                    playerId,
                                    player,
                                    _phoneController.text,
                                    ref.read(dobProvider.notifier).state,
                                    _heightController.text,
                                    ref.read(genderProvider.notifier).state,
                                    ref
                                        .read(profilePictureProvider.notifier)
                                        .state);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
                            })
                          ]),
                    )
                  ]))),
    );
  }
}

Widget _availabilityDropdown() {
  List<AvailabilityData> availability = [
    AvailabilityData(AvailabilityStatus.Available, "Available",
        Icons.check_circle, AppColours.green),
    AvailabilityData(AvailabilityStatus.Limited, "Limited", Icons.warning,
        AppColours.yellow),
    AvailabilityData(AvailabilityStatus.Unavailable, "Unavailable",
        Icons.cancel, AppColours.red)
  ];

  return DropdownButton<AvailabilityData>(
    value: availability[0],
    items: availability.map((AvailabilityData item) {
      return DropdownMenuItem<AvailabilityData>(
        value: item,
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
    onChanged: (selectedItem) {
      // Handle the selected item here
    },
  );
}
