import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerData {
  final int player_id;
  final String player_firstname;
  final String player_surname;
  final String player_dob;
  final String player_contact_number;
  final Image player_image;
  final String player_height;
  final String player_gender;

  PlayerData({
    required this.player_id,
    required this.player_firstname,
    required this.player_surname,
    required this.player_dob,
    required this.player_contact_number,
    required this.player_image,
    required this.player_height,
    required this.player_gender,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      player_id: json['player_id'],
      player_firstname: json['player_firstname'],
      player_surname: json['player_surname'],
      player_dob: json['player_dob'],
      player_contact_number: json['player_contact_number'],
      player_image: json['player_image'],
      player_height: json['player_height'],
      player_gender: json['player_gender'],
    );
  }
}

Future<void> getPlapyerById(String id) async {
  final apiUrl = 'http://127.0.0.1:8000/players/info/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final playerData = PlayerData.fromJson(responseData);

      // Access individual variables
      print('${playerData.player_id}');
      print('${playerData.player_firstname}');
      print('${playerData.player_surname}');
      print('${playerData.player_dob}');
      print('${playerData.player_contact_number}');
      print('${playerData.player_image}');
      print('${playerData.player_height}');
      print('${playerData.player_gender}');
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<void> editPlayer({
  required int player_id,
  required String player_firstname,
  required String player_surname,
  required String player_dob,
  required String player_contact_number,
  required String player_image,
  required String player_height,
  required String player_gender,
}) async {
  final apiUrl = 'http://127.0.0.1:8000/players/info/$getPlapyerById'; // Replace with your actual API URL

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'player_id': player_id,
        'player_firstname': player_firstname,
        'player_surname': player_surname,
        'player_dob': player_dob,
        'player_contact_number': player_contact_number,
        'player_image': player_image,
        'player_height': player_height,
        'player_gender': player_gender,
      }),
    );

    if (response.statusCode == 200) {
      // Team updated successfully
      print('Team updated successfully');
    } else {
      // Handle errors
      print('Failed to update team. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating team: $e');
  }
}

class EditPlayerProfileScreen extends StatefulWidget {
  const EditPlayerProfileScreen({Key? key}) : super(key: key);

  @override
  _EditPlayerProfileScreenState createState() =>
      _EditPlayerProfileScreenState();
}

class _EditPlayerProfileScreenState extends State<EditPlayerProfileScreen> {
  late PlayerData playerData;
   // Form controllers for text fields
   final TextEditingController _playerIdController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _playerImageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Players"),
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
                      const Text('Edit Player',
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: _availabilityDropdown(),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                  child: Column(children: [
                                Image.asset(
                                  "lib/assets/icons/profile_placeholder.png",
                                  width: 120,
                                ),
                                const SizedBox(height: 10),
                                underlineButtonTransparent(
                                    "Edit picture", () {}),
                              ])),
                              TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                    ),
                    TextFormField(
                      controller: _surnameController,
                      decoration: const InputDecoration(labelText: 'Surname'),
                    ),
                    TextFormField(
                      controller: _dobController,
                      decoration: const InputDecoration(labelText: 'Date of Birth'),
                    ),
                    TextFormField(
                      controller: _contactNumberController,
                      decoration: const InputDecoration(labelText: 'Contact Number'),
                    ),
                    TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(labelText: 'Height'),
                    ),
                    TextFormField(
                      controller: _genderController,
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                              dropdownWithDivider(
                                  "Position",
                                  "Defender",
                                  [
                                    "Forward",
                                    "Midfielder",
                                    "Defender",
                                    "Goalkeeper"
                                  ],
                                  (p0) {}),
                              const SizedBox(height: 30),
                              bigButton("Save Changes", () {
                                editPlayer(
                                  player_id: int.parse(_playerIdController.text),
                                  player_firstname: _firstNameController.text,
                                  player_surname: _surnameController.text,
                                  player_dob: _dobController.text, 
                                  player_contact_number: _contactNumberController.text,
                                  player_image: _playerImageController.text,
                                  player_height: _heightController.text,
                                  player_gender: _genderController.text,                
                                );
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
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
