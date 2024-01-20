import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addTeamPlayer(int id) async {
  final apiUrl =
      'http://127.0.0.1:8000/team_player/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response =
        await http.post(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully added data to the backend
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

class TeamSelectionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    const Text('Select Your Team',
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
                            Column(children: [
                              const SizedBox(height: 50),
                              Center(
                                  child: Column(children: [
                                const Text(
                                  "What team are you on?",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 15),
                                DropdownButton<String>(
                                    value: "team1",
                                    items:
                                        ["team1", "team2"].map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      );
                                    }).toList(),
                                    onChanged: (p0) {}),
                              ]))
                            ]),
                            const SizedBox(height: 50),
                            bigButton("Save Changes", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            })
                          ]),
                    )
                  ]))),
    );
  }
}
