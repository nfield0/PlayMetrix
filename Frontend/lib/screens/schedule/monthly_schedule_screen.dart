import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/schedule/add_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/daily_schedule_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

final selectedDateProvider = StateProvider<DateTime?>((ref) => DateTime.now());

class MonthlyScheduleScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            'lib/assets/logo.png',
            width: 150,
            fit: BoxFit.contain,
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 30, right: 35, left: 35),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Schedule",
                    style: TextStyle(
                      fontFamily: AppFonts.gabarito,
                      color: AppColours.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                  if (userRole == UserRole.manager)
                    smallButton(Icons.add_task, "Add", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddScheduleScreen()),
                      );
                    })
                ],
              ),
              const SizedBox(height: 30),
              FutureBuilder(
                  future: getCalendarDataSource(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final dataSource = snapshot.data;

                      return Expanded(
                        child: SfCalendar(
                          onTap: (CalendarTapDetails details) {
                            ref.watch(selectedDateProvider.notifier).state =
                                details.date;
                          },
                          dataSource: AppointmentDataSource(dataSource!),
                          view: CalendarView.month,
                          todayHighlightColor: AppColours.darkBlue,
                          selectionDecoration: BoxDecoration(
                            border: Border.all(
                                color: AppColours.darkBlue, width: 2.0),
                          ),
                          headerStyle: const CalendarHeaderStyle(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.gabarito,
                            ),
                          ),
                          monthViewSettings: const MonthViewSettings(
                            showAgenda: true,
                            agendaViewHeight: 150,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  }),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: underlineButtonTransparent("More details", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DailyScheduleScreen()),
                    );
                  })),
            ])),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 2));
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

// Future<List<Appointment>> getSchedulesForTeam(int teamId) async {
// }

Color getColourByScheduleType(ScheduleType scheduleType) {
  switch (scheduleType) {
    case "Training":
      return Colors.blue;
    case "Match":
      return Colors.green;
    case "Meeting":
      return Colors.red;
    case "Other":
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}

Future<Appointment> getScheduleById(int scheduleId) async {
  final apiUrl = "$apiBaseUrl/schedules/$scheduleId";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final schedule = jsonDecode(response.body);

      return Appointment(
        id: schedule["schedule_id"],
        startTime: DateTime.parse(schedule["schedule_start_time"]),
        endTime: DateTime.parse(schedule["schedule_end_time"]),
        subject: schedule["schedule_title"],
        location: schedule["schedule_location"],
        color: getColourByScheduleType(
            textToScheduleType(schedule["schedule_type"])),
        notes: schedule["schedule_alert_time"],
      );
    } else {
      print("Schedule not found");
    }
  } catch (e) {
    print(e);
  }
  throw Exception("Schedule not found");
}

Future<List<Appointment>> getCalendarDataSource() async {
  // List<Appointment> appointments = [
  //   Appointment(
  //     id: 1,
  //     startTime: DateTime(2023, 12, 5, 10, 0),
  //     endTime: DateTime(2023, 11, 5, 11, 0),
  //     subject: 'Meeting 1',
  //     location: 'Location 1',
  //     color: Colors.blue,
  //   ),
  //   Appointment(
  //     id: 2,
  //     startTime: DateTime(2023, 11, 12, 14, 0),
  //     endTime: DateTime(2023, 11, 12, 15, 0),
  //     subject: 'Meeting 2',
  //     location: 'Location 2',
  //     color: Colors.green,
  //   ),
  //   Appointment(
  //     id: 3,
  //     startTime: DateTime(2023, 12, 20, 16, 0),
  //     endTime: DateTime(2023, 11, 20, 17, 0),
  //     subject: 'Meeting 3',
  //     location: 'Location 3',
  //     color: Colors.red,
  //   ),
  //   Appointment(
  //     id: 4,
  //     startTime: DateTime(2023, 11, 20, 16, 0),
  //     endTime: DateTime(2023, 11, 20, 17, 0),
  //     subject: 'Meeting 3',
  //     location: 'Location 3',
  //     color: Colors.red,
  //   ),
  // ];

  // TODO: This is currently hardcoded to get the schedule with id 1, will be fixed once team_schedule table is implemented
  Appointment appointment = await getScheduleById(1);

  List<Appointment> appointments = [appointment];

  return appointments;
}
