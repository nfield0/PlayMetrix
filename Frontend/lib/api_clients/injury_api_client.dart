import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:play_metrix/constants.dart';
import 'package:http/http.dart' as http;
import 'package:play_metrix/data_models/player_data_model.dart';

Future<void> addPlayerInjury({
  required int playerId,
  required int physioId,
  required int injuryId,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
  required Uint8List? injuryReport,
}) async {
  try {
    const playerInjuriesApiUrl = "$apiBaseUrl/player_injuries/";

    final playerInjuriesResponse = await http.post(
      Uri.parse(playerInjuriesApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'player_id': playerId,
        'injury_id': injuryId,
        'physio_id': physioId,
        'date_of_injury': dateOfInjury.toIso8601String(),
        'expected_date_of_recovery': dateOfRecovery.toIso8601String(),
        "player_injury_report":
            injuryReport != null ? base64Encode(injuryReport) : null,
      }),
    );

    print('Response: ${playerInjuriesResponse.body}');
  } catch (error) {
    print('Error: $error');
  }
}

Future<void> updatePlayerInjury({
  required int injuryId,
  required int physioId,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
  required int playerId,
  required Uint8List? injuryReport,
}) async {
  try {
    final playerInjuryApiUrl = "$apiBaseUrl/player_injuries/$injuryId";
    final playerInjuryResponse = await http.put(
      Uri.parse(playerInjuryApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "injury_id": injuryId,
        "date_of_injury": dateOfInjury.toIso8601String(),
        "expected_date_of_recovery": dateOfRecovery.toIso8601String(),
        "player_id": playerId,
        "physio_id": physioId,
        "player_injury_report": injuryReport != null && injuryReport.isNotEmpty
            ? base64Encode(injuryReport)
            : null,
      }),
    );

    if (playerInjuryResponse.statusCode == 200) {
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

Future<List<Injury>> getInjuries(String i) async {
  const apiUrl = '$apiBaseUrl/injuries';

  return http.get(Uri.parse(apiUrl)).then((response) {
    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> jsonResponse = jsonDecode(response.body);

      List<Injury> injuries =
          jsonResponse.map((json) => Injury.fromJson(json)).toList();

      return injuries;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve Injury Data');
    }
  }).catchError((error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve Injury Data');
  });
}

Future<Injury> getInjuryById(int injuryId) async {
  final apiUrl = '$apiBaseUrl/injuries/$injuryId';

  return http.get(Uri.parse(apiUrl)).then((response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      Injury injury = Injury.fromJson(jsonResponse);

      return injury;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve Injury Data');
    }
  }).catchError((error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve Injury Data');
  });
}

Future<AllPlayerInjuriesData> getPlayerInjuryById(
    int injuryId, int playerId, DateTime dateOfInjury) async {
  final apiUrl =
      '$apiBaseUrl/player_injuries/$playerId/date/${DateFormat("yyyy-MM-dd").format(dateOfInjury)}/injury/$injuryId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final injuryData = await getInjuryById(jsonResponse['injury_id']);

      AllPlayerInjuriesData playerInjuryData = AllPlayerInjuriesData(
        id: injuryData.id,
        type: injuryData.type,
        nameAndGrade: injuryData.nameAndGrade,
        location: injuryData.location,
        potentialRecoveryMethods: injuryData.potentialRecoveryMethods,
        expectedMinRecoveryTime: injuryData.expectedMinRecoveryTime,
        expectedMaxRecoveryTime: injuryData.expectedMaxRecoveryTime,
        dateOfInjury: DateTime.parse(jsonResponse['date_of_injury']),
        expectedDateOfRecovery:
            DateTime.parse(jsonResponse['expected_date_of_recovery']),
        playerId: jsonResponse['player_id'],
        physioId: jsonResponse['physio_id'],
        playerInjuryReport: jsonResponse['player_injury_report'],
      );

      return playerInjuryData;
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to retrieve All Player Injury Data');
  }
  throw Exception('Failed to retrieve All Player Injury Data');
}

Future<List<AllPlayerInjuriesData>> getAllPlayerInjuriesByUserId(
    int userId) async {
  String apiUrl = '$apiBaseUrl/player_injuries/$userId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<PlayerInjuries> allPlayerInjuries =
          jsonResponse.map((json) => PlayerInjuries.fromJson(json)).toList();

      List<AllPlayerInjuriesData> allPlayerInjuriesData = [];

      for (PlayerInjuries pi in allPlayerInjuries) {
        final injuryData = await getInjuryById(pi.injuryId);
        allPlayerInjuriesData.add(AllPlayerInjuriesData(
          id: injuryData.id,
          type: injuryData.type,
          nameAndGrade: injuryData.nameAndGrade,
          location: injuryData.location,
          potentialRecoveryMethods: injuryData.potentialRecoveryMethods,
          expectedMinRecoveryTime: injuryData.expectedMinRecoveryTime,
          expectedMaxRecoveryTime: injuryData.expectedMaxRecoveryTime,
          dateOfInjury: pi.dateOfInjury,
          expectedDateOfRecovery: pi.dateOfRecovery,
          playerId: pi.playerId,
          physioId: pi.physioId,
          playerInjuryReport: pi.playerInjuryReport,
        ));
      }

      return allPlayerInjuriesData;
    } else {
      print(
          'Failed to retrieve data for injuries request. Status code: ${response.statusCode}');
      print('Error message for injuries request: ${response.body}');
      throw Exception('Failed to retrieve Injury Data');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to retrieve Injury Data');
  }
}

void printList(List<dynamic> list) {
  for (var item in list) {
    print(item);
  }
}
