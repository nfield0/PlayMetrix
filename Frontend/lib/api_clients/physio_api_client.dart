import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';

Future<Profile> getPhysioProfile(int id) async {
  final apiUrl = '$apiBaseUrl/physio/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);

      return Profile(
          id,
          parsed['physio_firstname'],
          parsed['physio_surname'],
          parsed['physio_contact_number'],
          parsed['physio_email'],
          base64Decode((parsed['physio_image'])),
          parsed['physio_2fa']);
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception("Profile not found");
}

Future<void> updatePhysioProfile(int id, ProfileName name, String contactNumber,
    Uint8List? imageBytes) async {
  final apiUrl = '$apiBaseUrl/physio/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'physio_id': id,
        'physio_firstname': name.firstName,
        'physio_surname': name.surname,
        'physio_contact_number': contactNumber,
        'physio_image': imageBytes != null ? base64Encode(imageBytes) : "",
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

Future<void> removePhysioFromTeam(int teamId, int physioId) {
  final String apiUrl = "$apiBaseUrl/team_physio/$teamId/physio/$physioId";

  return http.delete(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}
