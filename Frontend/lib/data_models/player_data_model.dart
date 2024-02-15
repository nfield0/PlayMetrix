import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';

class PlayerData {
  final int player_id;
  final String player_firstname;
  final String player_surname;
  final DateTime player_dob;
  final String player_contact_number;
  final Uint8List player_image;
  final String player_height;
  final String player_gender;

  PlayerData({
    required this.player_id,
    required this.player_firstname,
    required this.player_surname,
    required this.player_dob,
    required this.player_contact_number,
    required this.player_image,
    required this.player_height,
    required this.player_gender,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      player_id: json['player_id'],
      player_firstname: json['player_firstname'],
      player_surname: json['player_surname'],
      player_dob: DateTime.parse(json['player_dob']),
      player_contact_number: json['player_contact_number'],
      player_image: base64.decode(json['player_image']),
      player_height: json['player_height'],
      player_gender: json['player_gender'],
    );
  }
}

class PlayerProfile {
  final int playerId;
  final String firstName;
  final String surname;
  final String dob;
  final String gender;
  final String height;
  final int teamNumber;
  final AvailabilityStatus status;
  final LineupStatus lineupStatus;
  final Uint8List? imageBytes;

  PlayerProfile(
      this.playerId,
      this.firstName,
      this.surname,
      this.dob,
      this.gender,
      this.height,
      this.teamNumber,
      this.status,
      this.lineupStatus,
      this.imageBytes);
}

class TeamPlayerData {
  final int team_id;
  final int player_id;
  final String team_position;
  final int player_team_number;
  final String playing_status;
  final String lineup_status;

  TeamPlayerData({
    required this.team_id,
    required this.player_id,
    required this.team_position,
    required this.player_team_number,
    required this.playing_status,
    required this.lineup_status,
  });
}

class AvailabilityData {
  final AvailabilityStatus status;
  final String message;
  final IconData icon;
  final Color color;

  AvailabilityData(this.status, this.message, this.icon, this.color);
}

final List<AvailabilityData> availabilityData = [
  AvailabilityData(AvailabilityStatus.available, "Available",
      Icons.check_circle, AppColours.green),
  AvailabilityData(
      AvailabilityStatus.limited, "Limited", Icons.warning, AppColours.yellow),
  AvailabilityData(AvailabilityStatus.unavailable, "Unavailable", Icons.cancel,
      AppColours.red)
];

class StatisticsData {
  final int matchesPlayed;
  final int matchesStarted;
  final int matchesOffTheBench;
  final int totalMinutesPlayed;
  final bool injuryProne;

  StatisticsData(this.matchesPlayed, this.matchesStarted,
      this.matchesOffTheBench, this.totalMinutesPlayed, this.injuryProne);
}

class Injury {
  var injury_id;
  var injury_type;
  String injury_location;
  var expected_recovery_time;
  var recovery_method;

  Injury(
    this.injury_id,
    this.injury_type,
    this.injury_location,
    this.expected_recovery_time,
    this.recovery_method,
  );

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
        json['injury_id'],
        json['injury_type'],
        json['injury_location'],
        json['expected_recovery_time'],
        json['recovery_method']);
  }

  @override
  String toString() {
    return 'Injury{injury_id: $injury_id, injury_type: $injury_type, expected_recovery_time: $expected_recovery_time, recovery_method: $recovery_method}';
  }
}

class AllPlayerInjuriesData {
  final int injury_id;
  final String injury_type;
  final String injury_location;
  final String expected_recovery_time;
  final String recovery_method;
  final String date_of_injury;
  final String date_of_recovery;
  final int player_id;

  AllPlayerInjuriesData(
    this.injury_id,
    this.injury_type,
    this.injury_location,
    this.expected_recovery_time,
    this.recovery_method,
    this.date_of_injury,
    this.date_of_recovery,
    this.player_id,
  );
}

class PlayerInjuries {
  final int injury_id;
  final String date_of_injury;
  final String date_of_recovery;
  final int player_id;

  PlayerInjuries({
    required this.injury_id,
    required this.date_of_injury,
    required this.date_of_recovery,
    required this.player_id,
  });

  factory PlayerInjuries.fromJson(Map<String, dynamic> json) {
    return PlayerInjuries(
      injury_id: json['injury_id'],
      date_of_injury: json['date_of_injury'],
      date_of_recovery: json['date_of_recovery'],
      player_id: json['player_id'],
    );
  }

  @override
  String toString() {
    return 'PlayerInjuries{injury_id: $injury_id, date_of_injury: $date_of_injury, date_of_recovery: $date_of_recovery, player_id: $player_id}';
  }
}
