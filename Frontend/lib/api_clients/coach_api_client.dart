import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';

Future<Profile> getCoachProfile(int id) async {
  final apiUrl = '$apiBaseUrl/coaches/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);

      return Profile(
          id,
          parsed['coach_firstname'],
          parsed['coach_surname'],
          parsed['coach_contact'],
          parsed['coach_email'],
          base64Decode((parsed['coach_image'])),
          parsed['coach_2fa']);
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception("Profile not found");
}

Future<void> updateCoachProfile(int id, ProfileName name, String contactNumber,
    Uint8List? imageBytes) async {
  final apiUrl = '$apiBaseUrl/coaches/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'coach_id': id,
        'coach_firstname': name.firstName,
        'coach_surname': name.surname,
        'coach_contact': contactNumber,
        'coach_image': imageBytes != null ? base64Encode(imageBytes) : "",
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<int> findCoachIdByEmail(String email) async {
  const apiUrl = '$apiBaseUrl/users';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"user_type": "coach", "user_email": email}));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data != null) {
        return data['coach_id'];
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

Future<void> addTeamCoach(int teamId, int userId, String role) async {
  final apiUrl = '$apiBaseUrl/team_coach';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "team_id": teamId,
        "coach_id": userId,
        "team_role": role
      }),
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
