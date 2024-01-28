import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

// create a edit function HTTP request to backend
Future<void> editSchedule (int schedule_id, String schedule_title, String schedule_location, String schedule_type, DateTime schedule_start_time, 
DateTime schedule_end_time, String schedule_alert_time) async {
  final apiUrl = '$apiBaseUrl/schedules/$schedule_id';
  try {
  final response = await http.put(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'schedule_id': schedule_id,
      'schedule_title': schedule_title,
      'schedule_location': schedule_location,
      'schedule_start': schedule_start_time.toIso8601String(),
      'schedule_end': schedule_end_time.toIso8601String(),
      'schedule_type': schedule_type,
      'schedule_alert': schedule_alert_time,
    }),
  );
  if (response.statusCode == 200) {
      print('Registration successful!');
      print('Response: ${response.body}');
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
}

final startDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final endDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final scheduleTypeProvider = StateProvider<String>((ref) => "Training");
final scheduleAlertProvider = StateProvider<String>((ref) => "1 day before");

// final genderProvider = StateProvider<String>((ref) => "Male");
// class EditScheduleScreen extends StatefulWidget {
//   const EditScheduleScreen({Key? key}) : super(key: key);

//   @override
//   _EditScheduleScreenState createState() => _EditScheduleScreenState();
// }

class EditScheduleScreen extends ConsumerWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedStartDate = ref.watch(startDateProvider);
    DateTime selectedEndDate = ref.watch(endDateProvider);
    String selectedScheduleType = ref.watch(scheduleTypeProvider);
    String selectedScheduleAlert = ref.watch(scheduleAlertProvider);
    int selectedScheduleId = ref.watch(scheduleIdProvider);

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
              const Text('Edit Schedule',
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
                      "Title", "", true, titleController, (value) {
                    return (value != null ? 'This field is required.' : null);
                  }),
                  formFieldBottomBorderNoTitle(
                      "Location", "", false, locationController, (value) {
                    return (value != null ? 'This field is required.' : null);
                  })
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
                      context, "Starts", selectedStartDate, (value) {
                                ref.read(startDateProvider.notifier).state = value;
                              }),
                  greyDivider(),
                  dateTimePickerWithDivider(
                      context, "Ends", selectedEndDate, (value) {
                                ref.read(endDateProvider.notifier).state = value;
                              }),
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
                  dropdownWithDivider("Type", selectedScheduleType,
                      ["Training", "Match", "Meeting", "Other"], (value) {
                                ref.read(scheduleTypeProvider.notifier).state =
                                    value!;
                              }),
                  greyDivider(),
                  dropdownWithDivider(
                      "Alert",
                      selectedScheduleAlert,
                      [
                        "15 minutes before",
                        "30 minutes before",
                        "1 hour before",
                        "1 day before",
                        "2 days before"
                      ],
                      (value) {
                                ref.read(scheduleAlertProvider.notifier).state =
                                    value!;
                              }),
                ]),
              ),
              const SizedBox(height: 30),
              bigButton("Save Changes", () {
                editSchedule(selectedScheduleId, titleController.text, locationController.text, selectedScheduleType, selectedStartDate, selectedEndDate, selectedScheduleAlert);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleDetailsScreen()),
                );
              }),
            ]),
          )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
