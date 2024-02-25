import 'dart:convert';
import 'dart:typed_data';
import 'package:play_metrix/constants.dart';
import 'package:http/http.dart' as http;
import 'package:play_metrix/data_models/player_data_model.dart';

Future<void> addInjury({
  required int playerId,
  required int physioId,
  required String injuryType,
  required String injuryLocation,
  required String expectedRecoveryTime,
  required String recoveryMethod,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
  required Uint8List? injuryReport,
}) async {
  const apiUrl =
      '$apiBaseUrl/injuries/'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'injury_type': injuryType,
        'injury_location': injuryLocation,
        'expected_recovery_time': expectedRecoveryTime,
        'recovery_method': recoveryMethod,
      }),
    );

    print('Response: ${response.body}');
    if (response.statusCode == 200) {
      const playerInjuriesApiUrl = "$apiBaseUrl/player_injuries/";

      final playerInjuriesResponse = await http.post(
        Uri.parse(playerInjuriesApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'player_id': playerId,
          'injury_id': jsonDecode(response.body)['id'],
          'physio_id': physioId,
          'date_of_injury': dateOfInjury.toIso8601String(),
          'date_of_recovery': dateOfRecovery.toIso8601String(),
          "player_injury_report":
              injuryReport != null ? base64Encode(injuryReport) : null,
        }),
      );

      print('Response: ${playerInjuriesResponse.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<void> updateInjury({
  required int injuryId,
  required int physioId,
  required String injuryType,
  required String injuryLocation,
  required String expectedRecoveryTime,
  required String recoveryMethod,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
  required int playerId,
  required Uint8List? injuryReport,
}) async {
  final apiUrl = '$apiBaseUrl/injuries/$injuryId';
  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'injury_type': injuryType,
        'injury_location': injuryLocation,
        'expected_recovery_time': expectedRecoveryTime,
        'recovery_method': recoveryMethod,
      }),
    );

    final playerInjuryApiUrl = "$apiBaseUrl/player_injuries/$playerId";
    final playerInjuryResponse = await http.put(
      Uri.parse(playerInjuryApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "injury_id": injuryId,
        "date_of_injury": dateOfInjury.toIso8601String(),
        "date_of_recovery": dateOfRecovery.toIso8601String(),
        "player_id": playerId,
        "physio_id": physioId,
        "player_injury_report": injuryReport != null || injuryReport!.isEmpty
            ? base64Encode(injuryReport)
            : null,
      }),
    );

    if (response.statusCode == 200 && playerInjuryResponse.statusCode == 200) {
      // Successfully updated, handle the response accordingly
      print('Update successful!');
      print('Response: ${playerInjuryResponse.body}');
      // You can parse the response JSON here and perform actions based on it
    } else {
      // Failed to update, handle the error accordingly
      print(
          'Failed to update. Status code: ${playerInjuryResponse.statusCode}');
      print('Error message: ${playerInjuryResponse.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<AllPlayerInjuriesData> getPlayerInjuryById(
    int injuryId, int playerId) async {
  final apiUrl = "$apiBaseUrl/injuries/$injuryId";

  final response = await http.get(Uri.parse(apiUrl));

  final injuryData = jsonDecode(response.body);

  if (response.statusCode == 200) {
    final playerInjuryApiUrl = "$apiBaseUrl/player_injuries/$playerId";

    final playerInjuryResponse = await http.get(Uri.parse(playerInjuryApiUrl));

    if (playerInjuryResponse.statusCode == 200) {
      List<dynamic> playerInjuriesJson = jsonDecode(playerInjuryResponse.body);

      for (var injury in playerInjuriesJson) {
        if (injury['injury_id'] == injuryId) {
          return AllPlayerInjuriesData(
              injuryId,
              injuryData['injury_type'],
              injuryData['injury_location'],
              injuryData['expected_recovery_time'],
              injuryData['recovery_method'],
              injury['date_of_injury'],
              injury['date_of_recovery'],
              playerId,
              injury['player_injury_report'] != null
                  ? base64Decode(injury['player_injury_report'])
                  : null);
        }
      }
    } else {
      throw Exception('Failed to load player injuries');
    }
  } else {
    throw Exception('Failed to load player injuries');
  }
  throw Exception('Failed to load player injuries');
}

Future<List<AllPlayerInjuriesData>> getAllPlayerInjuriesByUserId(
    int userId) async {
  const apiUrl =
      '$apiBaseUrl/player_injuries'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<PlayerInjuries> allPlayerInjuries =
          jsonResponse.map((json) => PlayerInjuries.fromJson(json)).toList();
      List<PlayerInjuries> playerInjuries = [];
      // loop thourgh all the injuries and get the ones that match the user id passed in
      for (var injury in allPlayerInjuries) {
        if (injury.player_id == userId) {
          playerInjuries.add(injury);
        }
      }

      List<int> injuryIds = [];
      for (var injury in playerInjuries) {
        injuryIds.add(injury.injury_id); // Corrected property name
      }

      const apiUrlForInjuries =
          '$apiBaseUrl/injuries'; // Replace with your actual backend URL and provide the user ID

      try {
        final response = await http.get(
          Uri.parse(apiUrlForInjuries),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          // Successfully retrieved data, parse and store it in individual variables
          List<dynamic> jsonResponse = jsonDecode(response.body);
          List<Injury> allInjuries =
              jsonResponse.map((json) => Injury.fromJson(json)).toList();

          List<Injury> injuriesInIdsList = [];

          for (var injury in allInjuries) {
            if (injuryIds.contains(injury.injury_id)) {
              injuriesInIdsList.add(injury);
            }
          }

          List<AllPlayerInjuriesData> allPlayerInjuriesData = [];
          for (var injury in injuriesInIdsList) {
            for (var playerInjury in playerInjuries) {
              if (injury.injury_id == playerInjury.injury_id) {
                // create a AllPlayerInjuriesData object
                AllPlayerInjuriesData data = AllPlayerInjuriesData(
                    injury.injury_id,
                    injury.injury_type,
                    injury.injury_location,
                    injury.expected_recovery_time,
                    injury.recovery_method,
                    playerInjury.date_of_injury,
                    playerInjury.date_of_recovery,
                    playerInjury.player_id,
                    playerInjury.player_injury_report);
                allPlayerInjuriesData.add(data);
              }
            }
          }
          return allPlayerInjuriesData;
        } else {
          // Failed to retrieve data, handle the error accordingly
          print(
              'Failed to retrieve data for injuries request. Status code: ${response.statusCode}');
          print('Error message for injuries request: ${response.body}');
        }
      } catch (error) {
        // Handle any network or other errors
        print("injuries");
        print('Error in injuries request: $error');
      }
      throw Exception('Failed to retrieve Injury Data');
    } else {
      // Failed to retrieve data, handle the error accordingly
      print(
          'Failed to retrieve data for player injuries request. Status code: ${response.statusCode}');
      print(
          'Error message for player injuries request. Status code: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print("Player Injuries by user id");
    print('Error: $error');
  }
  throw Exception('Failed to retrieve All Player Injuries By User Id data');
}

void printList(List<dynamic> list) {
  for (var item in list) {
    print(item);
  }
}
