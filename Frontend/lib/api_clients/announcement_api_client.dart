import 'package:http/http.dart' as http;
import 'package:play_metrix/constants.dart';
import 'dart:convert';
import 'package:play_metrix/data_models/announcement_data_model.dart';
import 'package:play_metrix/enums.dart';

Future<List<Announcement>> getAnnouncementsByScheduleId(int scheduleId) {
  final String apiUrl = "$apiBaseUrl/announcements/schedule/$scheduleId";

  try {
    return http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Announcement> announcements = [];
        for (var announcement in data) {
          announcements.add(Announcement(
            id: announcement["announcements_id"],
            title: announcement["announcements_title"],
            description: announcement["announcements_desc"],
            date: announcement["announcements_date"],
            scheduleId: announcement["schedule_id"],
            posterId: announcement["poster_id"],
            posterRole: stringToUserRole(announcement["poster_type"]),
          ));
        }
        return announcements;
      } else {
        throw Exception("Failed to get announcements");
      }
    });
  } catch (e) {
    throw Exception("Failed to get announcements");
  }
}

Future<void> addAnnouncement({
  required String title,
  required String details,
  required int scheduleId,
  required int posterId,
  required UserRole posterType,
}) async {
  const apiUrl = "$apiBaseUrl/announcements";

  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "announcements_title": title,
          "announcements_desc": details,
          "announcements_date": DateTime.now().toIso8601String(),
          "schedule_id": scheduleId,
          "poster_id": posterId,
          "poster_type": userRoleText(posterType).toLowerCase()
        }));

    if (response.statusCode == 200) {
      print("Announcement added. Response: ${response.body}");
    } else {
      print("Announcement not added");
      throw Exception("Announcement not added");
    }
  } catch (e) {
    print(e);
    throw Exception("Announcement not added");
  }
}
