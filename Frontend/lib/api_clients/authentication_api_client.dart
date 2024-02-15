import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';

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
