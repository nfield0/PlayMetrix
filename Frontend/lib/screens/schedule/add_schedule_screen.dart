import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

enum AlertTime {
  none,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
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
    case AlertTime.twoHours:
      return "2 hours before";
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
    case "2 hours before":
      return AlertTime.twoHours;
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
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "schedule_title": title,
          "schedule_location": location,
          "schedule_start_time": startTime.toIso8601String(),
          "schedule_end_time": endTime.toIso8601String(),
          "schedule_type": scheduleTypeToText(scheduleType),
          "schedule_alert_time": alertTimeToText(alertTime),
        }));

    print(response.body);
    if (response.statusCode == 200) {
      int scheduleId = jsonDecode(response.body)["id"];

      const teamScheduleApiUrl = "$apiBaseUrl/team_schedules";

      await http.post(Uri.parse(teamScheduleApiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"schedule_id": scheduleId, "team_id": teamId}));

      print("Schedule added");
    } else {
      print("Schedule not added");
    }
  } catch (e) {
    print(e);
  }
}

final startTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final endTimeProvider = StateProvider<DateTime>((ref) => DateTime.now().add(
      const Duration(hours: 1),
    ));
final typeProvider =
    StateProvider<String>((ref) => scheduleTypeToText(ScheduleType.training));
final alertTimeProvider =
    StateProvider<String>((ref) => alertTimeToText(AlertTime.none));

class AddScheduleScreen extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AddScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedType = ref.watch(typeProvider);
    String selectedAlertTime = ref.watch(alertTimeProvider);
    DateTime selectedStartDate = ref.watch(startTimeProvider);
    DateTime selectedEndDate = ref.watch(endTimeProvider);

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
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          formFieldBottomBorderNoTitle(
                              "Title", "", true, titleController, (value) {
                            return (value != null && value == ""
                                ? 'This field is required.'
                                : null);
                          }),
                          formFieldBottomBorderNoTitle(
                              "Location", "", false, locationController,
                              (value) {
                            return (value != null && value == ""
                                ? 'This field is required.'
                                : null);
                          }),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          dateTimePickerWithDivider(
                              context, "Starts", selectedStartDate, (value) {
                            ref.read(startTimeProvider.notifier).state = value;
                          }),
                          greyDivider(),
                          dateTimePickerWithDivider(
                              context, "Ends", selectedEndDate, (value) {
                            ref.read(endTimeProvider.notifier).state = value;
                          }),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          dropdownWithDivider("Type", selectedType, [
                            scheduleTypeToText(ScheduleType.training),
                            scheduleTypeToText(ScheduleType.match),
                            scheduleTypeToText(ScheduleType.meeting),
                            scheduleTypeToText(ScheduleType.other)
                          ], (value) {
                            ref.read(typeProvider.notifier).state = value!;
                          }),
                          greyDivider(),
                          dropdownWithDivider("Alert", selectedAlertTime, [
                            alertTimeToText(AlertTime.none),
                            alertTimeToText(AlertTime.fifteenMinutes),
                            alertTimeToText(AlertTime.thirtyMinutes),
                            alertTimeToText(AlertTime.oneHour),
                            alertTimeToText(AlertTime.twoHours),
                            alertTimeToText(AlertTime.oneDay),
                            alertTimeToText(AlertTime.twoDays),
                          ], (value) {
                            ref.read(alertTimeProvider.notifier).state = value!;
                          }),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      bigButton("Add Schedule", () {
                        if (formKey.currentState!.validate()) {
                          if (selectedEndDate.isBefore(selectedStartDate)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: AppColours.red,
                                    padding: EdgeInsets.all(20.0),
                                    content: Text(
                                        "End time cannot be before start time",
                                        style: TextStyle(fontSize: 16.0))));
                          } else {
                            addSchedule(
                                titleController.text,
                                locationController.text,
                                selectedStartDate,
                                selectedEndDate,
                                textToScheduleType(selectedType),
                                textToAlertTime(selectedAlertTime),
                                1);

                            titleController.clear();
                            locationController.clear();
                            ref.read(startTimeProvider.notifier).state =
                                DateTime.now();
                            ref.read(endTimeProvider.notifier).state =
                                DateTime.now().add(const Duration(hours: 1));
                            ref.read(typeProvider.notifier).state =
                                scheduleTypeToText(ScheduleType.training);
                            ref.read(alertTimeProvider.notifier).state =
                                alertTimeToText(AlertTime.none);
                          }
                        }
                      }),
                    ]),
              )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
