import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';

class PlayerLogin {
  final int id;
  final String email;
  final String password;
  final bool twoFactorAuthEnabled;

  PlayerLogin(
      {required this.id,
      required this.email,
      required this.password,
      required this.twoFactorAuthEnabled});

  factory PlayerLogin.fromJson(Map<String, dynamic> json) {
    return PlayerLogin(
      id: json['player_id'],
      email: json['player_email'],
      password: json['player_password'],
      twoFactorAuthEnabled: json['player_2fa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': id,
      'player_email': email,
      'player_password': password,
      'player_2fa': twoFactorAuthEnabled,
    };
  }
}

class PlayerData {
  final int id;
  final String firstName;
  final String surname;
  final DateTime dob;
  final String contactNumber;
  final Uint8List image;
  final String height;
  final String gender;

  PlayerData({
    required this.id,
    required this.firstName,
    required this.surname,
    required this.dob,
    required this.contactNumber,
    required this.image,
    required this.height,
    required this.gender,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      id: json['player_id'],
      firstName: json['player_firstname'],
      surname: json['player_surname'],
      dob: DateTime.parse(json['player_dob']),
      contactNumber: json['player_contact_number'],
      image: base64.decode(json['player_image']),
      height: json['player_height'],
      gender: json['player_gender'],
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
  final String reasonForStatus;
  final LineupStatus lineupStatus;
  final Uint8List? imageBytes;

  PlayerProfile(
      {required this.playerId,
      required this.firstName,
      required this.surname,
      required this.dob,
      required this.gender,
      required this.height,
      required this.teamNumber,
      required this.status,
      required this.lineupStatus,
      required this.reasonForStatus,
      required this.imageBytes});
}

class TeamPlayerData {
  final int teamId;
  final int playerId;
  final String teamPosition;
  final int playerTeamNumber;
  final String playingStatus;
  final String reasonForStatus;
  final String lineupStatus;

  TeamPlayerData({
    required this.teamId,
    required this.playerId,
    required this.teamPosition,
    required this.playerTeamNumber,
    required this.playingStatus,
    required this.reasonForStatus,
    required this.lineupStatus,
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
  final int totalMinutesPlayed;
  final int matchesOffTheBench;
  final bool injuryProne;

  StatisticsData(this.matchesPlayed, this.matchesStarted,
      this.totalMinutesPlayed, this.matchesOffTheBench, this.injuryProne);
}

class Injury {
  final int id;
  final String type;
  final String nameAndGrade;
  final String location;
  final List<String> potentialRecoveryMethods;
  final int expectedMinRecoveryTime;
  final int expectedMaxRecoveryTime;

  Injury({
    required this.id,
    required this.type,
    required this.nameAndGrade,
    required this.location,
    required this.potentialRecoveryMethods,
    required this.expectedMinRecoveryTime,
    required this.expectedMaxRecoveryTime,
  });

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
        id: json['injury_id'] ?? 0,
        type: json['injury_type'] ?? "",
        nameAndGrade: json['injury_name_and_grade'] ?? "",
        location: json['injury_location'] ?? "",
        potentialRecoveryMethods: [
          json['potential_recovery_method_1'] ?? "",
          json['potential_recovery_method_2'] ?? "",
          json['potential_recovery_method_3'] ?? ""
        ],
        expectedMinRecoveryTime: json['expected_minimum_recovery_time'],
        expectedMaxRecoveryTime: json['expected_maximum_recovery_time']);
  }
}

class AllPlayerInjuriesData {
  final int injuryId;
  final String type;
  final String nameAndGrade;
  final String location;
  final List<String> potentialRecoveryMethods;
  final int expectedMinRecoveryTime;
  final int expectedMaxRecoveryTime;
  final DateTime dateOfInjury;
  final DateTime expectedDateOfRecovery;
  final int playerInjuryId;
  final int playerId;
  final int physioId;
  final Uint8List? playerInjuryReport;

  AllPlayerInjuriesData({
    required this.injuryId,
    required this.type,
    required this.nameAndGrade,
    required this.location,
    required this.potentialRecoveryMethods,
    required this.expectedMinRecoveryTime,
    required this.expectedMaxRecoveryTime,
    required this.dateOfInjury,
    required this.expectedDateOfRecovery,
    required this.playerInjuryId,
    required this.playerId,
    required this.physioId,
    this.playerInjuryReport,
  });
}

class PlayerInjuries {
  final int injuryId;
  final int playerId;
  final int physioId;
  final int playerInjuryId;
  final DateTime dateOfInjury;
  final DateTime dateOfRecovery;
  final Uint8List? playerInjuryReport;

  PlayerInjuries({
    required this.injuryId,
    required this.playerId,
    required this.physioId,
    required this.playerInjuryId,
    required this.dateOfInjury,
    required this.dateOfRecovery,
    this.playerInjuryReport,
  });

  factory PlayerInjuries.fromJson(Map<String, dynamic> json) {
    return PlayerInjuries(
      injuryId: json['injury_id'],
      playerId: json['player_id'],
      physioId: json['physio_id'],
      playerInjuryId: json['player_injury_id'],
      dateOfInjury: DateTime.parse(json['date_of_injury']),
      dateOfRecovery: DateTime.parse(json['expected_date_of_recovery']),
      playerInjuryReport: json['player_injury_report'] != null
          ? base64.decode(json['player_injury_report'])
          : null,
    );
  }
}

String formatBytes(int bytes) {
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = 0;
  double size = bytes.toDouble();
  while (size > 1024) {
    size /= 1024;
    i++;
  }
  return '${size.toStringAsFixed(2)} ${suffixes[i]}';
}

class MatchData {
  final int playerId;
  final int scheduleId;
  Duration minutesPlayed;

  MatchData({
    required this.playerId,
    required this.scheduleId,
    required this.minutesPlayed,
  });

  Map<String, dynamic> toJson() {
    return {
      'player_id': playerId,
      'schedule_id': scheduleId,
      'minutes_played': minutesPlayed.inMinutes,
    };
  }

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      playerId: json['player_id'],
      scheduleId: json['schedule_id'],
      minutesPlayed: Duration(minutes: json['minutes_played']),
    );
  }
}
