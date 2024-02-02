import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

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

class AddAnnouncementScreen extends StatefulWidget {
  final int scheduleId;
  final UserRole userRole;

  const AddAnnouncementScreen(
      {super.key, required this.scheduleId, required this.userRole});

  @override
  AddAnnouncementScreenState createState() => AddAnnouncementScreenState();
}

class AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Schedule"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Announcement',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      divider(),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          formFieldBottomBorderNoTitle(
                              "Title", "", true, titleController, (value) {
                            return (value != null && value.isEmpty
                                ? 'This field is required.'
                                : null);
                          }),
                          formFieldBottomBorderNoTitle(
                              "Details", "", false, detailsController, (value) {
                            return (value != null && value.isEmpty
                                ? 'This field is required.'
                                : null);
                          })
                        ]),
                      ),
                      const SizedBox(height: 30),
                      bigButton("Send Announcement", () {
                        if (formKey.currentState!.validate()) {
                          addAnnouncement(
                              title: titleController.text,
                              details: detailsController.text,
                              scheduleId: widget.scheduleId,
                              posterId: widget.scheduleId,
                              posterType: widget.userRole);
                          Navigator.pop(context);
                        }
                      }),
                    ]),
              )),
        ),
        bottomNavigationBar:
            roleBasedBottomNavBar(widget.userRole, context, 2));
  }
}
