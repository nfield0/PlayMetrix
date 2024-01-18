import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updateInjury({
  required int injuryId,
  required String injury_type,
  required String expected_recovery_time,
  required String recovery_method,
}) async {
  final apiUrl = 'http://127.0.0.1:8000/injuries/$injuryId/'; // Replace with your actual backend URL

  try {
    final response = await http.put(
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
      // Successfully updated, handle the response accordingly
      print('Update successful!');
      print('Response: ${response.body}');
      // You can parse the response JSON here and perform actions based on it
    } else {
      // Failed to update, handle the error accordingly
      print('Failed to update. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}


class EditInjuryScreen extends StatefulWidget {
  const EditInjuryScreen({Key? key}) : super(key: key);

  @override
  _EditInjuryScreenState createState() => _EditInjuryScreenState();
}

class _EditInjuryScreenState extends State<EditInjuryScreen> {
  final TextEditingController _injuryIdController = TextEditingController();
  final TextEditingController _injuryTypeController = TextEditingController();
  final TextEditingController _expectedRecoveryTimeController = TextEditingController();
  final TextEditingController _recoveryMethodController = TextEditingController();

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
                      const Text('Edit Injury',
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
                              formFieldBottomBorder("Injury type", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder(
                                  "Expected recovery time", ""),
                              // const SizedBox(height: 5),
                              // formFieldBottomBorder("Injury location", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder("Recovery method", ""),
                              const SizedBox(height: 35),
                              bigButton("Save Changes", () {
                                updateInjury(
                                  injuryId: int.parse(_injuryIdController.text),
                                  injury_type: _injuryTypeController.text,
                                  expected_recovery_time: _expectedRecoveryTimeController.text,
                                  recovery_method: _recoveryMethodController.text,
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
