import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:play_metrix/api_clients/coach_api_client.dart';
import 'package:play_metrix/api_clients/physio_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';

Future<List<TeamData>> getAllTeams() async {
  const apiUrl = '$apiBaseUrl/teams';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully retrieved data from the backend
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> teamJsonList =
          List<Map<String, dynamic>>.from(data);

      final List<TeamData> teams =
          teamJsonList.map((json) => TeamData.fromJson(json)).toList();

      return teams;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to get data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load teams');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load teams');
  }
}

Future<int> getTeamByManagerId(int managerId) async {
  final teams = await getAllTeams();

  try {
    for (TeamData team in teams) {
      if (team.manager_id == managerId) {
        return team.team_id;
      }
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<int> getTeamByCoachId(int coachId) async {
  final apiUrl = '$apiBaseUrl/coaches_team/$coachId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return data[0]['team_id'];
      } else {
        return -1;
      }
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<int> getTeamByPhysioId(int physioId) async {
  final apiUrl = '$apiBaseUrl/physios_team/$physioId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return data[0]['team_id'];
      } else {
        return -1;
      }
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<int> getTeamByPlayerId(int playerId) async {
  final apiUrl = '$apiBaseUrl/players_team/$playerId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return data[0]['team_id'];
      } else {
        return -1;
      }
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<TeamData?> getTeamById(int id) async {
  if (id != -1) {
    final apiUrl =
        '$apiBaseUrl/teams/$id'; // Replace with your actual backend URL and provide the user ID

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Successfully retrieved data, parse and store it in individual variables
        TeamData teamData = TeamData.fromJson(jsonDecode(response.body));

        // Access individual variables
        return teamData;
      } else {
        // Failed to retrieve data, handle the error accordingly
        print('Failed to retrieve data. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
        throw Exception('Failed to retrieve team data');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error: $error');
      throw Exception('Failed to retrieve team data');
    }
  }
  return null;
}

Future<List<Profile>> getPhysiosForTeam(int teamId) async {
  final apiUrl = '$apiBaseUrl/team_physio/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> physiosJsonList =
          List<Map<String, dynamic>>.from(data);

      List<Profile> physios = [];

      for (Map<String, dynamic> physioJson in physiosJsonList) {
        Profile physio = await getPhysioProfile(physioJson['physio_id']);
        physios.add(physio);
      }

      return physios;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve physio data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve physio data');
  }
}

Future<List<Profile>> getCoachesForTeam(int teamId) async {
  final apiUrl = '$apiBaseUrl/team_coach/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> coachesJsonList =
          List<Map<String, dynamic>>.from(data);

      List<Profile> coaches = [];

      for (Map<String, dynamic> coachJson in coachesJsonList) {
        Profile coach = await getCoachProfile(coachJson['coach_id']);
        coaches.add(coach);
      }

      return coaches;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve physio data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve physio data');
  }
}

Future<int> getFirstSportId() async {
  const apiUrl = '$apiBaseUrl/sports';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully retrieved data from the backend
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> sportJsonList =
          List<Map<String, dynamic>>.from(data);

      final List<SportData> sports =
          sportJsonList.map((json) => SportData.fromJson(json)).toList();

      return sports[0].sport_id;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to get data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load sports');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load sports');
  }
}

Future<List<LeagueData>> getAllLeagues() async {
  const apiUrl = '$apiBaseUrl/leagues/';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      // Successfully retrieved data from the backend
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> teamJsonList =
          List<Map<String, dynamic>>.from(data);

      final List<LeagueData> leagues =
          teamJsonList.map((json) => LeagueData.fromJson(json)).toList();

      return leagues;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to get data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load leagues.');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load leagues');
  }
}

Future<int> addTeam(String teamName, Uint8List? imageBytes, int managerId,
    int sportId, int leagueId, String teamLocation) async {
  const apiUrl = '$apiBaseUrl/teams';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'team_name': teamName,
        'team_logo': imageBytes != null ? base64Encode(imageBytes) : "",
        'manager_id': managerId,
        'sport_id': sportId,
        'league_id': leagueId,
        'team_location': teamLocation,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      print("Team added successfully");
      print(response.body);
      return jsonDecode(response.body)["id"];
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to retrieve team data');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to retrieve team data');
  }
}

Future<TeamData> editTeam(
  int teamId,
  String teamName,
  Uint8List? teamLogo,
  int managerId,
  int leagueId,
  int sportId,
  String teamLocation,
) async {
  final apiUrl = '$apiBaseUrl/teams/$teamId';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "team_name": teamName,
        "team_logo": teamLogo != null ? base64Encode(teamLogo) : "",
        "manager_id": managerId,
        "league_id": leagueId,
        "sport_id": sportId,
        "team_location": teamLocation
      }),
    );

    if (response.statusCode == 200) {
      // Team updated successfully
      print('Team updated successfully');
      return TeamData(
          team_id: teamId,
          team_name: teamLocation,
          team_logo: teamLogo!,
          manager_id: managerId,
          sport_id: sportId,
          league_id: leagueId,
          team_location: teamLocation);
    } else {
      // Handle errors
      print('Failed to update team. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating team: $e');
  }
  throw Exception('Error updating team');
}

Future<List<LeagueData>> getLeagues() async {
  const apiUrl = '$apiBaseUrl/leagues';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<LeagueData> leagues =
          responseData.map((json) => LeagueData.fromJson(json)).toList();

      return leagues;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load leagues');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load leagues');
  }
}

Future<String?> getTeamLeagueName(int teamId) async {
  try {
    final TeamData? teamData = await getTeamById(teamId);
    final List<LeagueData> leagues = await getLeagues();

    for (var league in leagues) {
      if (teamData?.league_id == league.league_id) {
        return league.league_name;
      }
    }

    return null; // If league not found
  } catch (error) {
    print('Error: $error');
    return null;
  }
}
