import 'package:play_metrix/enums.dart';

class NotificationData {
  final String title;
  final String desc;
  final DateTime date;
  final int teamId;
  final UserRole userRole;
  final NotificationType type;

  NotificationData(
      {required this.title,
      required this.desc,
      required this.date,
      required this.teamId,
      required this.userRole,
      required this.type});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['notification_title'],
      desc: json['notification_desc'],
      date: DateTime.parse(json['notification_date']),
      type: stringToNotificationType(json['notification_type']),
      teamId: json['team_id'],
      userRole: stringToUserRole(json['user_type']),
    );
  }
}
