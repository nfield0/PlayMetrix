import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> updateManagerProfile(String contactNumber, String image) async {
final apiUrl =
        'http://127.0.0.1:8000/register_manager'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          // 'manager_firstname': firstName,
          // 'manager_surname': surname,
          // 'manager_email': email,
          // 'manager_password': password,
          'manager_contact_number': "",
          'manager_image': "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        print('Response: ${response.body}');

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

Future<void> updatePhysioProfile() async {}

Future<void> updateCoachProfile() async {}


class ProfileSetUpScreen extends ConsumerWidget {
  String selectedDivisionValue = "Division 1";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;

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
            const Text('Profile Set Up',
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
                "lib/assets/icons/profile_placeholder.png",
                width: 100,
              ),
              const SizedBox(height: 10),
              underlineButtonTransparent("Upload picture", () {}),
            ])),
            const SizedBox(height: 20),
            formFieldBottomBorder("Phone", ""),
            const SizedBox(height: 50),
            bigButton("Save Changes", () {
              if (userRole == UserRole.manager) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeamSetUpScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            })
          ],
        ),
      )),
    );
  }
}
