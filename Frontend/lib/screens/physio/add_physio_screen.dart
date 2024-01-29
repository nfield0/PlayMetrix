import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addTeamPhysio(int teamId, int userId) async {
  const apiUrl = '$apiBaseUrl/team_physio';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, dynamic>{"team_id": teamId, "physio_id": userId}),
    );

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

Future<int> findPhysioIdByEmail(String email) async {
  const apiUrl = '$apiBaseUrl/users';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"user_type": "physio", "user_email": email}));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data != null) {
        return data['physio_id'];
      }
      return -1;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      return -1;
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    return -1;
  }
}

class AddPhysioScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  AddPhysioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Team Profile"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Physio to Team',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      Divider(
                        color: AppColours.darkBlue,
                        thickness: 1.0,
                        height: 40.0,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Enter registered physio email:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: _emailController,
                                cursorColor: AppColours.darkBlue,
                                decoration: const InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColours.darkBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColours.darkBlue),
                                  ),
                                  labelText: 'Email address',
                                  labelStyle: TextStyle(
                                      color: AppColours.darkBlue,
                                      fontFamily: AppFonts.openSans),
                                ),
                                validator: (String? value) {
                                  return (value != null &&
                                          !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                              .hasMatch(value))
                                      ? 'Invalid email format.'
                                      : null;
                                },
                              ),
                              const SizedBox(height: 40),
                              bigButton("Add Physio", () async {
                                if (_formKey.currentState!.validate()) {
                                  int physioId = await findPhysioIdByEmail(
                                      _emailController.text);

                                  if (physioId != -1) {
                                    await addTeamPhysio(
                                        ref.read(teamIdProvider), physioId);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Physio Not Found',
                                              style: TextStyle(
                                                  color: AppColours.darkBlue,
                                                  fontFamily: AppFonts.gabarito,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                          content: Text(
                                              'Sorry, physio with that email does not exist. Please enter a different email address and try again.',
                                              style: TextStyle(fontSize: 16)),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
