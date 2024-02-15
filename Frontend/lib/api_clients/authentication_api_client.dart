import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

Future<String> registerUser({
  required String userType,
  required String firstName,
  required String surname,
  required String email,
  required String password,
  required String contactNumber,
  Uint8List? image,
}) async {
  if (userType == "manager") {
    const apiUrl =
        '$apiBaseUrl/register_manager'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'manager_firstname': firstName,
          'manager_surname': surname,
          'manager_email': email,
          'manager_password': password,
          'manager_contact_number': contactNumber,
          'manager_image': image != null ? base64.encode(image) : "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');

        return response.body;
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
  if (userType == "player") {
    const apiUrl =
        '$apiBaseUrl/register_player'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'player_email': email,
          'player_password': password,
          'player_firstname': firstName,
          'player_surname': surname,
          'player_dob': DateTime.now().toString(),
          'player_height': "",
          'player_gender': "",
          'player_contact_number': contactNumber,
          'player_image': image != null ? base64.encode(image) : "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        return response.body;
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

  if (userType == "coach") {
    const apiUrl =
        '$apiBaseUrl/register_coach'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'coach_email': email,
          'coach_password': password,
          'coach_firstname': firstName,
          'coach_surname': surname,
          'coach_contact': contactNumber,
          'coach_image': image != null ? base64.encode(image) : "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        return response.body;
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

  if (userType == "physio") {
    const apiUrl =
        '$apiBaseUrl/register_physio'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'physio_email': email,
          'physio_password': password,
          'physio_firstname': firstName,
          'physio_surname': surname,
          'physio_contact_number': contactNumber,
          'physio_image': image != null ? base64.encode(image) : "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        return response.body;
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
  } else {
    print("error: user type not found");
  }

  return "";
}

Future<bool> checkEmailExists(String email) async {
  final apiUrl =
      '$apiBaseUrl/check_email_exists?email=${Uri.encodeComponent(email)}';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      if (response.body == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw Exception('Failed to check email');
}

Future<String> loginUser(BuildContext context, String email, String password,
    String userType) async {
  const apiUrl = '$apiBaseUrl/login';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_email': email,
        'user_password': password,
        'user_type': userType,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      // Successfully logged in, handle the response accordingly
      if (response.body.toLowerCase().contains("error")) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Error',
                  style: TextStyle(
                      color: AppColours.darkBlue,
                      fontFamily: AppFonts.gabarito,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              content: const Text(
                "User with that email doesn't exist.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        if (!jsonDecode(response.body)['user_password']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Error',
                    style: TextStyle(
                        color: AppColours.darkBlue,
                        fontFamily: AppFonts.gabarito,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                content: const Text(
                  'Wrong password. Please try again.',
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return "";
        }

        return response.body;
      }
    } else {
      // Failed to log in, handle the error accordingly
      print('Failed to log in. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  return "";
}

class TwilioService {
  final TwilioFlutter twilioFlutter;

  TwilioService({required this.twilioFlutter});

  Future<bool> sendVerificationCode(String to, String code) async {
    try {
      await twilioFlutter.sendSMS(
        toNumber: to,
        messageBody: 'Hey there! Your PlayMetrix verification code is: $code',
      );

      return true;
    } catch (e) {
      print('Error sending verification code: $e');
      return false;
    }
  }
}

String generateRandomCode() {
  final random = Random();
  // Generate a random 6-digit code
  return (100000 + random.nextInt(900000)).toString();
}

String getPhoneNumberPrefix(String phoneNumber) {
  List<String> irishMobilePrefixes = ['083', '085', '086', '087', '089'];

  List<String> ukMobilePrefixes = [
    '07402',
    '07403',
    '07404',
    '07405',
    '07406',
    '07407',
    '07408',
    '07409',
    '07520',
    '07521',
    '07522',
    '07523',
    '07524',
    '07525',
    '07526',
    '07527',
    '07528',
    '07529',
    '07770',
    '07771',
    '07772',
    '07773',
    '07774',
    '07775',
    '07776',
    '07777',
    '07778',
    '07779',
    '07850',
    '07851',
    '07852',
    '07853',
    '07854',
    '07855',
    '07856',
    '07857',
    '07858',
    '07859',
    '07724',
    '07781',
    '07782',
    '07783',
    '07784',
    '07785',
    '07786',
    '07787',
    '07788',
    '07789',
    '07824',
    '07825',
    '07826',
    '07827',
    '07828',
    '07829',
    '07730',
    '07731',
    '07732',
    '07733',
    '07734',
    '07735',
    '07736',
    '07737',
    '07738',
    '07739',
    '07911',
    '07912',
    '07913',
    '07914',
    '07915',
    '07916',
    '07917',
    '07918',
    '07919',
    '07400',
    '07401',
    '07402',
    '07403',
    '07404',
    '07405',
    '07406',
    '07407',
    '07408',
    '07409',
  ];
  //phoneNumber = phoneNumber.replaceAll(RegExp('^0+'), '');
  String prefix = phoneNumber.substring(0, 3);
  String prefixUk = phoneNumber.substring(0, 5);
  if (!phoneNumber.startsWith('+353') && !phoneNumber.startsWith('+44')) {
    if (irishMobilePrefixes.contains(prefix)) {
      String formattedPhoneNumberForIreland = '+353' + phoneNumber.substring(1);
      return formattedPhoneNumberForIreland;
    } else if (ukMobilePrefixes.contains(prefixUk)) {
      String formattedPhoneNumberForEngland = '+44' + phoneNumber.substring(1);
      print(formattedPhoneNumberForEngland);
      return formattedPhoneNumberForEngland;
    } else {
      return '';
    }
  }
  return phoneNumber;
}