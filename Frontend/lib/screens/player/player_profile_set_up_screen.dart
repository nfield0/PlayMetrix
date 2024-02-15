import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_class.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

class TeamPlayerData {
  final int team_id;
  final int player_id;
  final String team_position;
  final int player_team_number;
  final String playing_status;
  final String lineup_status;

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

Future<void> updateTeamPlayerNumber(
    TeamPlayerData teamPlayer, int number) async {
  const apiUrl = '$apiBaseUrl/team_player';

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
        playerImage = Uint8List(0); // Or set it to an empty Uint8List
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

class PlayerProfileSetUpScreen extends StatefulWidget {
  final int playerId;

  const PlayerProfileSetUpScreen({super.key, required this.playerId});

  @override
  PlayerProfileSetUpScreenState createState() =>
      PlayerProfileSetUpScreenState();
}

class PlayerProfileSetUpScreenState extends State<PlayerProfileSetUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Uint8List? _profilePicture;
  DateTime _selectedDob = DateTime.now();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

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
              const Text(
                'Profile Set Up',
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.gabarito,
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                      child: Column(
                        children: [
                          _profilePicture != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: Image.memory(
                                    _profilePicture!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  "lib/assets/icons/profile_placeholder.png",
                                  width: 100,
                                ),
                          const SizedBox(height: 10),
                          underlineButtonTransparent("Upload picture", () {
                            pickImage();
                          }),
                        ],
                      ),
                    ),
                    datePickerNoDivider(context, "Date of birth", _selectedDob,
                        (value) {
                      setState(() {
                        _selectedDob = value;
                      });
                    }),
                    formFieldBottomBorderController(
                        "Height (cm)", _heightController, (value) {
                      return (value != null && !heightRegex.hasMatch(value))
                          ? 'Invalid height.'
                          : null;
                    }),
                    formFieldBottomBorderController("Phone", _phoneController,
                        (value) {
                      return (value != null && !phoneRegex.hasMatch(value))
                          ? 'Invalid phone number.'
                          : null;
                    }),
                    const SizedBox(height: 5),
                    dropdownWithDivider(
                        "Gender", _selectedGender, ["Male", "Female", "Others"],
                        (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    }),
                    const SizedBox(height: 50),
                    bigButton("Save Changes", () async {
                      if (_formKey.currentState!.validate()) {
                        PlayerData player =
                            await getPlayerProfile(widget.playerId);
                        await updatePlayerProfile(
                          widget.playerId,
                          player,
                          _phoneController.text,
                          _selectedDob,
                          _heightController.text,
                          _selectedGender,
                          _profilePicture,
                        );

                        navigator.push(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
