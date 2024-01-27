import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

enum AlertTime {
  none,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  oneDay,
  twoDays,
}

enum ScheduleType {
  training,
  match,
  meeting,
  other,
}

String alertTimeToText(AlertTime alertTime) {
  switch (alertTime) {
    case AlertTime.none:
      return "None";
    case AlertTime.fifteenMinutes:
      return "15 minutes before";
    case AlertTime.thirtyMinutes:
      return "30 minutes before";
    case AlertTime.oneHour:
      return "1 hour before";
    case AlertTime.oneDay:
      return "1 day before";
    case AlertTime.twoDays:
      return "2 days before";
  }
}

ScheduleType textToScheduleType(String text) {
  switch (text) {
    case "Training":
      return ScheduleType.training;
    case "Match":
      return ScheduleType.match;
    case "Meeting":
      return ScheduleType.meeting;
    case "Other":
      return ScheduleType.other;
  }
  return ScheduleType.other;
}

AlertTime textToAlertTime(String text) {
  switch (text) {
    case "None":
      return AlertTime.none;
    case "15 minutes before":
      return AlertTime.fifteenMinutes;
    case "30 minutes before":
      return AlertTime.thirtyMinutes;
    case "1 hour before":
      return AlertTime.oneHour;
    case "1 day before":
      return AlertTime.oneDay;
    case "2 days before":
      return AlertTime.twoDays;
  }
  return AlertTime.none;
}

String scheduleTypeToText(ScheduleType scheduleType) {
  switch (scheduleType) {
    case ScheduleType.training:
      return "Training";
    case ScheduleType.match:
      return "Match";
    case ScheduleType.meeting:
      return "Meeting";
    case ScheduleType.other:
      return "Other";
  }
}

Future<void> addSchedule(
    String title,
    String location,
    DateTime startTime,
    DateTime endTime,
    ScheduleType scheduleType,
    AlertTime alertTime,
    int teamId) async {
  const apiUrl = "$apiBaseUrl/schedules";

  try {
    final response = await http.post(Uri.parse(apiUrl), body: {
      "schedule_title": title,
      "schedule_location": location,
      "schedule_start_time": startTime,
      "schedule_end_time": endTime,
      "schedule_type": scheduleTypeToText(scheduleType),
      "schedule_alert_time": alertTimeToText(alertTime),
    });

    if (response.statusCode == 200) {
      int scheduleId = jsonDecode(response.body)["id"];

      final teamScheduleApiUrl = "$apiBaseUrl/team_schedules/$teamId";

      await http.post(Uri.parse(teamScheduleApiUrl),
          body: {"schedule_id": scheduleId, "team_id": teamId});

      print("Schedule added");
    } else {
      print("Schedule not added");
    }
  } catch (e) {
    print(e);
  }
}

class AddScheduleScreen extends ConsumerWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Schedule"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Container(
            padding: const EdgeInsets.all(40.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add Schedule',
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
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  formFieldBottomBorderNoTitle(
                      "Title", "", true, titleController),
                  formFieldBottomBorderNoTitle(
                      "Location", "", false, locationController),
                ]),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  dateTimePickerWithDivider(
                      context, "Starts", DateTime.now(), (p0) {}),
                  greyDivider(),
                  dateTimePickerWithDivider(
                      context, "Ends", DateTime.now(), (p0) {}),
                ]),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  dropdownWithDivider("Type", "Training",
                      ["Training", "Match", "Meeting", "Other"], (p0) {}),
                  greyDivider(),
                  dropdownWithDivider(
                      "Alert",
                      "1 day before",
                      [
                        "15 minutes before",
                        "30 minutes before",
                        "1 hour before",
                        "1 day before",
                        "2 days before"
                      ],
                      (p0) {}),
                ]),
              ),
              const SizedBox(height: 30),
              bigButton("Add Schedule", () {}),
            ]),
          )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
