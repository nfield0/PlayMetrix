import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/enums.dart';

Future<TeamPlayerData> getTeamPlayerData(int teamId, int playerId) async {
  final apiUrl = '$apiBaseUrl/team_player/$teamId';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final List<dynamic> playerList = jsonDecode(response.body);

      // Find the player with the specified playerId
      Map<String, dynamic>? playerData;
      for (var player in playerList) {
        if (player['player_id'] == playerId) {
          playerData = player;
          break;
        }
      }

      if (playerData != null) {
        return TeamPlayerData(
          team_id: playerData['team_id'],
          player_id: playerData['player_id'],
          team_position: playerData['team_position'],
          player_team_number: playerData['player_team_number'],
          playing_status: playerData['playing_status'],
          lineup_status: playerData['lineup_status'],
        );
      } else {
        throw Exception('Player not found');
      }
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception('Player not found');
}

Future<void> updateTeamPlayerNumber(
    TeamPlayerData teamPlayer, int number) async {
  const apiUrl = '$apiBaseUrl/team_player';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'player_id': teamPlayer.player_id,
        'team_id': teamPlayer.team_id,
        'team_position': teamPlayer.team_position,
        'player_team_number': number,
        'playing_status': teamPlayer.playing_status,
        'lineup_status': teamPlayer.lineup_status,
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<Profile> getPlayerProfile(int id) async {
  final apiUrl = '$apiBaseUrl/players/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);

      return Profile(
          id,
          parsed['player_firstname'],
          parsed['player_surname'],
          parsed['player_contact_number'],
          parsed['player_height'],
          base64Decode((parsed['player_image'])));
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception("Profile not found");
}

Future<PlayerData> getPlayerData(int id) async {
  final apiUrl = '$apiBaseUrl/players/info/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      DateTime playerDob;
      if (parsed['player_dob'] != null && parsed['player_dob'] != "") {
        playerDob = DateTime.parse(parsed['player_dob']);
      } else {
        playerDob = DateTime.now();
      }

      Uint8List? playerImage;
      if (parsed['player_image'] != null && parsed['player_image'] != "") {
        playerImage = base64.decode(parsed['player_image']);
      } else {
        playerImage = Uint8List(0); // Or set it to an empty Uint8List
      }

      return PlayerData(
        player_id: id,
        player_firstname: parsed['player_firstname'],
        player_surname: parsed['player_surname'],
        player_contact_number: parsed['player_contact_number'],
        player_dob: playerDob,
        player_height: parsed['player_height'],
        player_gender: parsed['player_gender'],
        player_image: playerImage,
      );
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception('Player not found');
}

Future<void> updatePlayerProfile(
    int id,
    PlayerData player,
    String contactNumber,
    DateTime dob,
    String height,
    String gender,
    Uint8List? image) async {
  final apiUrl = '$apiBaseUrl/players/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'player_id': id,
        'player_firstname': player.player_firstname,
        'player_surname': player.player_surname,
        'player_contact_number': contactNumber,
        'player_dob': dob.toIso8601String(),
        'player_height': height,
        'player_gender': gender,
        'player_image': image != null ? base64Encode(image) : "",
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<int> findPlayerIdByEmail(String email) async {
  const apiUrl = '$apiBaseUrl/users';

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"user_type": "player", "user_email": email}));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data != null) {
        return data['player_id'];
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

Future<void> editPlayerProfile(
    int id,
    String firstName,
    String surname,
    String contactNumber,
    DateTime dob,
    String height,
    String gender,
    Uint8List image) async {
  final apiUrl = '$apiBaseUrl/players/info/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'player_id': id,
        'player_firstname': firstName,
        'player_surname': surname,
        'player_contact_number': contactNumber,
        'player_dob': dob.toIso8601String(),
        'player_height': height,
        'player_gender': gender,
        'player_image': image.isNotEmpty ? base64Encode(image) : "",
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<void> updateTeamPlayer(int teamId, int playerId, int number,
    String status, String teamPosition, String lineupStatus) async {
  const apiUrl = '$apiBaseUrl/team_player';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'team_id': teamId,
        'player_id': playerId,
        'team_position': teamPosition,
        'player_team_number': number,
        'playing_status': status,
        'lineup_status': lineupStatus
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<void> updatePlayerStatistics(int playerId, int matchesPlayed,
    int matchesStarted, int matchesOffTheBench, int totalMinutesPlayed) async {
  final apiUrl = '$apiBaseUrl/players/stats/$playerId';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "player_id": playerId,
        "matches_played": matchesPlayed,
        "matches_started": matchesStarted,
        "matches_off_the_bench": matchesOffTheBench,
        "injury_prone": false,
        "minutes_played": totalMinutesPlayed
      }),
    );

    if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

Future<void> addTeamPlayer(int teamId, int userId, String teamPosition,
    int number, AvailabilityData playingStatus, String lineupStatus) async {
  const apiUrl = '$apiBaseUrl/team_player';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "team_id": teamId,
        "player_id": userId,
        "team_position": teamPosition,
        "player_team_number": number,
        "playing_status": playingStatus.message,
        "lineup_status": lineupStatus
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added data to the backend
      print("Successfully added player to team");
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

Future<void> addInjury({
  required int playerId,
  required String injuryType,
  required String injuryLocation,
  required String expectedRecoveryTime,
  required String recoveryMethod,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
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
          'date_of_injury': dateOfInjury.toIso8601String(),
          'date_of_recovery': dateOfRecovery.toIso8601String(),
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
  required String injuryType,
  required String injuryLocation,
  required String expectedRecoveryTime,
  required String recoveryMethod,
  required DateTime dateOfInjury,
  required DateTime dateOfRecovery,
  required int playerId,
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
        "player_id": playerId
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
              playerId);
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
                    playerInjury.player_id);
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

Future<List<PlayerProfile>> getAllPlayersForTeam(int teamId) async {
  final apiUrl = '$apiBaseUrl/team_player/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final List<Map<String, dynamic>> playersJsonList =
          List<Map<String, dynamic>>.from(responseData);

      List<PlayerProfile> players = [];

      for (Map<String, dynamic> playerJson in playersJsonList) {
        PlayerData player = await getPlayerById(playerJson['player_id']);

        players.add(PlayerProfile(
            player.player_id,
            player.player_firstname,
            player.player_surname,
            "${player.player_dob.toLocal()}".split(' ')[0],
            player.player_gender,
            player.player_height,
            playerJson['player_team_number'],
            stringToAvailabilityStatus(playerJson['playing_status']),
            textToLineupStatus(playerJson['lineup_status']),
            player.player_image));
      }

      return players;
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load players');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load players');
  }
}

Future<PlayerProfile> getPlayerTeamProfile(int teamId, int playerId) async {
  final apiUrl = '$apiBaseUrl/team_player/$teamId';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final List<Map<String, dynamic>> playersJsonList =
          List<Map<String, dynamic>>.from(responseData);

      for (Map<String, dynamic> playerJson in playersJsonList) {
        if (playerJson['player_id'] == playerId) {
          PlayerData player = await getPlayerById(playerJson['player_id']);
          PlayerProfile playerProfile = PlayerProfile(
              playerJson['player_id'],
              player.player_firstname,
              player.player_surname,
              "${player.player_dob.toLocal()}".split(' ')[0],
              player.player_gender,
              player.player_height,
              playerJson['player_team_number'],
              stringToAvailabilityStatus(playerJson['playing_status']),
              textToLineupStatus(playerJson['lineup_status']),
              player.player_image);
          return playerProfile;
        }
      }
      throw Exception('Player not found');
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load players');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
    throw Exception('Failed to load players');
  }
}

Future<PlayerData> getPlayerById(int id) async {
  final apiUrl =
      '$apiBaseUrl/players/info/$id'; // Replace with your actual backend URL and provide the user ID

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved data, parse and store it in individual variables
      PlayerData player = PlayerData.fromJson(jsonDecode(response.body));

      return player;
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
  throw Exception('Failed to retrieve player data');
}

Future<StatisticsData> getStatisticsData(int id) async {
  final apiUrl = '$apiBaseUrl/players/stats/$id';
  try {
    final response =
        await http.get(Uri.parse(apiUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      final parsed = jsonDecode(response.body);

      if (parsed != null) {
        return StatisticsData(
            parsed["matches_played"],
            parsed["matches_started"],
            parsed["matches_off_the_bench"],
            parsed["minutes_played"],
            parsed["injury_prone"]);
      } else {
        throw Exception('Failed to load player statistics');
      }
    } else {
      print('Error message: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }

  throw Exception('Failed to load player statistics');
}

Future<Map<LineupStatus, List<PlayerProfile>>> getPlayersLineupStatus(
    int teamId) async {
  try {
    // Create a map to store players based on their attending status
    Map<LineupStatus, List<PlayerProfile>> playersByStatus = {
      LineupStatus.starter: [],
      LineupStatus.substitute: [],
      LineupStatus.reserve: [],
    };

    List<PlayerProfile> players = await getAllPlayersForTeam(teamId);

    for (PlayerProfile player in players) {
      if (player.lineupStatus == LineupStatus.starter) {
        playersByStatus[LineupStatus.starter]!.add(player);
      } else if (player.lineupStatus == LineupStatus.substitute) {
        playersByStatus[LineupStatus.substitute]!.add(player);
      } else {
        playersByStatus[LineupStatus.reserve]!.add(player);
      }
    }

    return playersByStatus;
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw Exception('Failed to retrieve players attendance data');
}

Future<PlayerAttendingStatus> getPlayerAttendingStatus(
    int playerId, int scheduleId) async {
  final String apiUrl = "$apiBaseUrl/player_schedules/$scheduleId";

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      bool playerFound = false;
      PlayerAttendingStatus playerAttendingStatus =
          PlayerAttendingStatus.undecided;

      for (var playerSchedule in data) {
        if (playerSchedule["player_id"] == playerId) {
          playerFound = true;
          playerAttendingStatus = playerSchedule["player_attending"] == null
              ? PlayerAttendingStatus.undecided
              : playerSchedule["player_attending"]
                  ? PlayerAttendingStatus.present
                  : PlayerAttendingStatus.absent;
        }
      }

      if (!playerFound) {
        addPlayerSchedule(playerId, scheduleId);
      }
      return playerAttendingStatus;
    } else {
      throw Exception("Failed to get player attending status");
    }
  } catch (e) {
    throw Exception("Failed to get player attending status");
  }
}

Future<void> addPlayerSchedule(int playerId, int scheduleId) async {
  const String apiUrl = "$apiBaseUrl/player_schedules";
  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "player_id": playerId,
        "schedule_id": scheduleId,
        "player_attending": null,
      }),
    );
    print(response.body);
  } catch (e) {
    throw Exception("Failed to add player schedule");
  }
}

Future<void> updatePlayerAttendingStatus(
    int playerId, int scheduleId, PlayerAttendingStatus status) {
  final String apiUrl = "$apiBaseUrl/player_schedules/$playerId";

  return http.put(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "player_id": playerId,
      "schedule_id": scheduleId,
      "player_attending": status == PlayerAttendingStatus.present
          ? true
          : status == PlayerAttendingStatus.absent
              ? false
              : null,
    }),
  );
}
