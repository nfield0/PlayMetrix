import 'package:play_metrix/enums.dart';

class NotificationData {
  final String title;
  final String desc;
  final DateTime date;
  final int teamId;
  final UserRole userRole;

  NotificationData(
      {required this.title,
      required this.desc,
      required this.date,
      required this.teamId,
      required this.userRole});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['notification_title'],
      desc: json['notification_desc'],
      date: DateTime.parse(json['notification_date']),
      teamId: json['team_id'],
      userRole: stringToUserRole(json['user_type']),
    );
  }
}
