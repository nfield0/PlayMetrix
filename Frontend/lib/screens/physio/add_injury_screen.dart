import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> AddInjury({
  required String injury_type,
  required String expected_recovery_time,
  required String recovery_method,
}) async {
  final apiUrl =
      '$apiBaseUrl/injuries/'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'injury_type': injury_type,
        'expected_recovery_time': expected_recovery_time,
        'recovery_method': recovery_method,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully registered, handle the response accordingly
      print('Registration successful!');
      print('Response: ${response.body}');
      // You can parse the response JSON here and perform actions based on it
    } else {
      // Failed to register, handle the error accordingly
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

class AddInjuryScreen extends StatefulWidget {
  const AddInjuryScreen({Key? key}) : super(key: key);

  @override
  _AddInjuryScreenState createState() => _AddInjuryScreenState();
}

class _AddInjuryScreenState extends State<AddInjuryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController injuryTypeController = TextEditingController();
  final TextEditingController expectedRecoveryTimeController =
      TextEditingController();
  final TextEditingController recoveryMethodController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Player Profile"),
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
                      const Text('Add Injury',
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
                                Image.asset(
                                  "lib/assets/icons/profile_placeholder.png",
                                  width: 120,
                                ),
                                const SizedBox(height: 15),
                                const Text("Player Name",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gabarito,
                                        fontWeight: FontWeight.bold)),
                              ])),
                              // const SizedBox(height: 15),
                              // formFieldBottomBorder("Date of injury", ""),
                              // const SizedBox(height: 5),
                              // formFieldBottomBorder("Date of recovery", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Injury type", injuryTypeController, (value) {
                                return (value != null)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Expected recovery time",
                                  expectedRecoveryTimeController, (value) {
                                return (value != null)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              // const SizedBox(height: 5),
                              // formFieldBottomBorder("Injury location", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorderController(
                                  "Recovery method", recoveryMethodController,
                                  (value) {
                                return (value != null)
                                    ? 'This field is required.'
                                    : null;
                              }),
                              const SizedBox(height: 35),
                              bigButton("Add Injury", () {
                                if (_formKey.currentState!.validate()) {
                                  AddInjury(
                                    injury_type: injuryTypeController.text,
                                    expected_recovery_time:
                                        expectedRecoveryTimeController.text,
                                    recovery_method:
                                        recoveryMethodController.text,
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
