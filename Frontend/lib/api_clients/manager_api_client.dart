import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';

Future<Profile> getManagerProfile(int id) async {
  final apiUrl = '$apiBaseUrl/managers/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);

      return Profile(
          id,
          parsed['manager_firstname'],
          parsed['manager_surname'],
          parsed['manager_contact_number'],
          parsed['manager_email'],
          base64Decode((parsed['manager_image'])),
          parsed['manager_2fa']);
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception("Profile not found");
}

Future<void> updateManagerProfile(int id, ProfileName name,
    String contactNumber, Uint8List? imageBytes) async {
  final apiUrl = '$apiBaseUrl/managers/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'manager_id': id,
        'manager_firstname': name.firstName,
        'manager_surname': name.surname,
        'manager_contact_number': contactNumber,
        'manager_image': imageBytes != null ? base64Encode(imageBytes) : "",
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
