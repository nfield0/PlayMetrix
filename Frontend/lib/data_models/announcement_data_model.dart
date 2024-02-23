import 'package:play_metrix/enums.dart';

class Announcement {
  final int id;
  final String title;
  final String description;
  final String date;
  final int scheduleId;
  final int posterId;
  final UserRole posterRole;

  Announcement(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.scheduleId,
      required this.posterId,
      required this.posterRole});
}
