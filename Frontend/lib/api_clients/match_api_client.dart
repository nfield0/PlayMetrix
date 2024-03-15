import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';

Future<MatchData?> getMatchDataForPlayerSchedule({scheduleId, playerId}) async {
  final apiUrl = "$apiBaseUrl/match/schedule/$scheduleId/player/$playerId";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final matchData = jsonDecode(response.body);

      return MatchData.fromJson(matchData);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<void> addMatchData({scheduleId, playerId}) async {
  const apiUrl = "$apiBaseUrl/match";

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "player_id": playerId,
          "schedule_id": scheduleId,
          "minutes_played": 0,
        }));

    print(response.body);
  } catch (e) {
    return;
  }
}

Future<void> updateMatchData({scheduleId, playerId, minutesPlayed}) async {
  final apiUrl =
      "$apiBaseUrl/match/schedule/$scheduleId/player/$playerId/minutes/$minutesPlayed";

  try {
    final response = await http.put(Uri.parse(apiUrl));

    print(response.body);
  } catch (e) {
    return;
  }
}
