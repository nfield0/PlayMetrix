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
