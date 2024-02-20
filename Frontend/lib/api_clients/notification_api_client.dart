import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';

Future<void> addNotification({
  required String title,
  required String desc,
  required int teamId,
  required UserRole recieverUserRole
}) async {
  const apiUrl = "$apiBaseUrl/notification";

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "notification_title": title,
          "notification_desc": desc,
          "notification_date": DateTime.now().toIso8601String(),
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
