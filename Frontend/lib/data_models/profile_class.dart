import 'dart:convert';
import 'dart:typed_data';

class ProfileName {
  final String firstName;
  final String surname;

  ProfileName(this.firstName, this.surname);
}

class Profile {
  final int id;
  final String firstName;
  final String surname;
  final String contactNumber;
  final String email;
  final Uint8List? imageBytes;

  Profile(this.id, this.firstName, this.surname, this.contactNumber, this.email,
      this.imageBytes);
}

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
