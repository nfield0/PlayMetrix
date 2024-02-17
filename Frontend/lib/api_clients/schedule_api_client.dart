import 'dart:convert';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/schedule_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:http/http.dart' as http;

Future<int> addSchedule(
    String title,
    String location,
    DateTime startTime,
    DateTime endTime,
    ScheduleType scheduleType,
    AlertTime alertTime,
    int teamId) async {
  const apiUrl = "$apiBaseUrl/schedules";

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "schedule_title": title,
          "schedule_location": location,
          "schedule_start_time": startTime.toIso8601String(),
          "schedule_end_time": endTime.toIso8601String(),
          "schedule_type": scheduleTypeToText(scheduleType),
          "schedule_alert_time": alertTimeToText(alertTime),
          "team_id": teamId,
        }));

    print(response.body);
    if (response.statusCode == 200) {
      int scheduleId = jsonDecode(response.body)["id"];

      const teamScheduleApiUrl = "$apiBaseUrl/team_schedules";

      await http.post(Uri.parse(teamScheduleApiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, int>{"schedule_id": scheduleId, "team_id": teamId}));

      print("Schedule added");
      return scheduleId;
    } else {
      print("Schedule not added");
    }
  } catch (e) {
    print(e);
  }
  throw Exception("Schedule not added");
}

Future<bool> editSchedule(
    int schedule_id,
    String schedule_title,
    String schedule_location,
    String schedule_type,
    DateTime schedule_start_time,
    DateTime schedule_end_time,
    String schedule_alert_time) async {
  final apiUrl = '$apiBaseUrl/schedules/$schedule_id';
  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'schedule_id': schedule_id,
        'schedule_title': schedule_title,
        'schedule_location': schedule_location,
        'schedule_start_time': schedule_start_time.toIso8601String(),
        'schedule_end_time': schedule_end_time.toIso8601String(),
        'schedule_type': schedule_type,
        'schedule_alert_time': schedule_alert_time,
      }),
    );
    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
      return true;
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      return false;
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    return false;
  }
}

Future<Schedule> getScheduleById(int scheduleId) async {
  final apiUrl = '$apiBaseUrl/schedules/$scheduleId';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print('Get players attending successful!');

      Schedule schedule = Schedule.fromJson(jsonDecode(response.body));
      return schedule;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print("user");
    print('Error: $error');
  }
  throw Exception('Failed to players attending data');
}

Future<Map<PlayerAttendingStatus, List<PlayerProfile>>>
    getPlayersAttendanceForSchedule(int scheduleId, int teamId) async {
  final String apiUrl = '$apiBaseUrl/player_schedules/$scheduleId';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print('Get players attending successful!');

      final List<dynamic> responseData = jsonDecode(response.body);

      // Create a map to store players based on their attending status
      Map<PlayerAttendingStatus, List<PlayerProfile>> playersByStatus = {
        PlayerAttendingStatus.present: [],
        PlayerAttendingStatus.absent: [],
        PlayerAttendingStatus.undecided: [],
      };

      for (Map<String, dynamic> playerJson in responseData) {
        PlayerProfile player =
            await getPlayerTeamProfile(teamId, playerJson['player_id']);
        if (playerJson['player_attending'] == true) {
          playersByStatus[PlayerAttendingStatus.present]!.add(player);
        } else if (playerJson['player_attending'] == false) {
          playersByStatus[PlayerAttendingStatus.absent]!.add(player);
        } else {
          playersByStatus[PlayerAttendingStatus.undecided]!.add(player);
        }
      }

      return playersByStatus;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve players attendance data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw Exception('Failed to retrieve players attendance data');
}
