import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/notification_data_model.dart';
import 'package:play_metrix/enums.dart';

Future<void> addNotification(
    {required String title,
    required String desc,
    required DateTime date,
    required int teamId,
    required NotificationType type,
    required UserRole recieverUserRole}) async {
  const apiUrl = "$apiBaseUrl/notification";

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "notification_title": title,
          "notification_desc": desc,
          "notification_date": date.toIso8601String(),
          "notification_type": notificationTypeToText(type),
          "team_id": teamId,
          "user_type": userRoleText(recieverUserRole).toLowerCase()
        }));

    if (response.statusCode == 200) {
      print("Notification added. Response: ${response.body}");
    } else {
      print("Notification not added");
      throw Exception("Notification not added");
    }
  } catch (e) {
    print(e);
    throw Exception("Notification not added");
  }
}

Future<List<NotificationData>> getNotifications(
    {required int teamId, required String userType}) async {
  final apiUrl = "$apiBaseUrl/notification/$teamId/$userType";

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> notificationsJsonList =
          List<Map<String, dynamic>>.from(data);

      List<NotificationData> notifications = [];

      for (Map<String, dynamic> notificationJson in notificationsJsonList) {
        NotificationData notification =
            NotificationData.fromJson(notificationJson);
        notifications.add(notification);
      }

      return notifications;
    } else {
      print("Notification not found");
      throw Exception("Notification not found");
    }
  } catch (e) {
    print(e);
    throw Exception("Notification not found");
  }
}
