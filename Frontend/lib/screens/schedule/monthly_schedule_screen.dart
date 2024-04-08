import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/schedule/add_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/daily_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => DateTime.now());

class MonthlyScheduleScreen extends ConsumerWidget {
  const MonthlyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          title: userRole == UserRole.manager
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Schedule",
                      style: TextStyle(
                        fontFamily: AppFonts.gabarito,
                        color: AppColours.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    smallButton(Icons.add_task, "Add", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddScheduleScreen()),
                      );
                    })
                  ],
                )
              : const Text(
                  "Schedule",
                  style: TextStyle(
                    fontFamily: AppFonts.gabarito,
                    color: AppColours.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: Column(children: [
                      const SizedBox(height: 20),
                      FutureBuilder(
                          future: getTeamAppointments(
                              ref.read(teamIdProvider.notifier).state),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final dataSource = snapshot.data;

                              return Expanded(
                                child: SfCalendar(
                                  onTap: (CalendarTapDetails details) {
                                    ref
                                        .watch(selectedDateProvider.notifier)
                                        .state = details.date;
                                    if (details.targetElement ==
                                            CalendarElement.appointment ||
                                        details.targetElement ==
                                            CalendarElement.agenda) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ScheduleDetailsScreen(
                                            userId: ref.read(userIdProvider),
                                            userRole: userRole,
                                            teamId: ref.read(teamIdProvider),
                                            scheduleId:
                                                details.appointments![0].id,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  dataSource:
                                      AppointmentDataSource(dataSource!),
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
                                    appointmentDisplayMode:
                                        MonthAppointmentDisplayMode.appointment,
                                    showAgenda: true,
                                    agendaViewHeight: 110,
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
                                  builder: (context) =>
                                      const DailyScheduleScreen()),
                            );
                          })),
                    ])))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 3));
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
