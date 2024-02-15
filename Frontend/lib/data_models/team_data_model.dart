import 'dart:convert';
import 'dart:typed_data';

class TeamData {
  final int team_id;
  final String team_name;
  final Uint8List team_logo;
  final int manager_id;
  final int league_id;
  final int sport_id;
  final String team_location;

  TeamData({
    required this.team_id,
    required this.team_name,
    required this.team_logo,
    required this.manager_id,
    required this.sport_id,
    required this.league_id,
    required this.team_location,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      team_id: json['team_id'],
      team_name: json['team_name'],
      team_logo: base64.decode(json['team_logo']),
      manager_id: json['manager_id'],
      sport_id: json['sport_id'],
      league_id: json['league_id'],
      team_location: json['team_location'],
    );
  }
}

class LeagueData {
  final int league_id;
  final String league_name;

  LeagueData({
    required this.league_id,
    required this.league_name,
  });

  factory LeagueData.fromJson(Map<String, dynamic> json) {
    return LeagueData(
      league_id: json['league_id'],
      league_name: json['league_name'],
    );
  }
}

class SportData {
  final int sport_id;
  final String sport_name;

  SportData({
    required this.sport_id,
    required this.sport_name,
  });

  factory SportData.fromJson(Map<String, dynamic> json) {
    return SportData(
      sport_id: json['sport_id'],
      sport_name: json['sport_name'],
    );
  }
}
