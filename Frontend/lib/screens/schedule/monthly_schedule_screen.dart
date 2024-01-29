import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/schedule/add_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/daily_schedule_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
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
                  future:
                      getTeamSchedules(ref.read(teamIdProvider.notifier).state),
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

Future<List<Appointment>> getTeamSchedules(int teamId) async {
  final apiUrl = "$apiBaseUrl/team_schedules/$teamId";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final schedules = jsonDecode(response.body);

      List<Appointment> appointments = [];

      for (var schedule in schedules) {
        appointments
            .add(await getAppointmentByScheduleId(schedule["schedule_id"]));
      }

      return appointments;
    } else {
      print("Schedules not found");
    }
  } catch (e) {
    print(e);
  }
  throw Exception("Schedules not found");
}

Color getColourByScheduleType(ScheduleType scheduleType) {
  switch (scheduleType) {
    case ScheduleType.training:
      return Colors.blue;
    case ScheduleType.match:
      return Colors.green;
    case ScheduleType.meeting:
      return Colors.red;
    case ScheduleType.other:
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}

ScheduleType getScheduleTypeByColour(Color colour) {
  if (colour == Colors.blue) {
    return ScheduleType.training;
  } else if (colour == Colors.green) {
    return ScheduleType.match;
  } else if (colour == Colors.red) {
    return ScheduleType.meeting;
  } else if (colour == Colors.yellow) {
    return ScheduleType.other;
  } else {
    return ScheduleType.other;
  }
}

Future<Appointment> getAppointmentByScheduleId(int scheduleId) async {
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
