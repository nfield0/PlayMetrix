import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/schedule/add_announcement_screen.dart';
import 'package:play_metrix/screens/schedule/add_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/edit_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/match_line_up_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/players_attending_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class ScheduleDetailsScreen extends ConsumerWidget {
  final int scheduleId;
  const ScheduleDetailsScreen({super.key, required this.scheduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole userRole = ref.watch(userRoleProvider);
    ScheduleType scheduleType;

    return FutureBuilder(
        future: getFilteredDataSource(ref, scheduleId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataSource = snapshot.data;
            for (var schedule in dataSource?.appointments ?? []) {
              Appointment sch = schedule;
              scheduleType = getScheduleTypeByColour(sch.color);

              return Scaffold(
                  appBar: AppBar(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          appBarTitlePreviousPage(DateFormat('MMMM y').format(
                            sch.startTime,
                          )),
                          if (userRole == UserRole.manager)
                            smallButton(Icons.edit, "Edit", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditScheduleScreen(
                                    scheduleId: scheduleId,
                                  ),
                                ),
                              );
                            })
                        ]),
                    iconTheme: const IconThemeData(
                      color: AppColours.darkBlue,
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 35),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sch.subject,
                            style: const TextStyle(
                              fontFamily: AppFonts.gabarito,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            DateFormat('EEEE, d MMMM y').format(
                              sch.startTime,
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${DateFormat('jm').format(sch.startTime)} to ${DateFormat('jm').format(sch.endTime)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          // Location?
                          Text(
                            sch.location ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (userRole == UserRole.manager ||
                                  userRole == UserRole.coach)
                                underlineButtonTransparent(
                                    scheduleType == ScheduleType.match
                                        ? "Match lineup"
                                        : "Players attending", () {
                                  if (scheduleType == ScheduleType.match) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MatchLineUpScreen()),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayersAttendingScreen(
                                                scheduleId: scheduleId,
                                              )),
                                    );
                                  }
                                })
                            ],
                          ),
                          greyDivider(),
                          SizedBox(
                            height: 160,
                            child: SfCalendar(
                              view: CalendarView.schedule,
                              dataSource: dataSource,
                              minDate: sch.startTime,
                              maxDate:
                                  sch.startTime.add(const Duration(days: 1)),
                              scheduleViewSettings: const ScheduleViewSettings(
                                appointmentItemHeight: 70,
                                hideEmptyScheduleWeek: true,
                                monthHeaderSettings: MonthHeaderSettings(
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          greyDivider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 10, right: 10, bottom: 5),
                            child: detailBoldTitle("Alert", sch.notes!),
                          ),
                          divider(),
                          const SizedBox(height: 15),
                          _announcementsSection(context, userRole)
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar:
                      roleBasedBottomNavBar(userRole, context, 2));
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        });
  }
}

Future<AppointmentDataSource> getFilteredDataSource(
    WidgetRef ref, int id) async {
  List<Appointment> allAppointments =
      await getTeamSchedules(ref.read(teamIdProvider.notifier).state);
  List<Appointment> filteredAppointments =
      allAppointments.where((appointment) => appointment.id == id).toList();
  return AppointmentDataSource(filteredAppointments);
}

Widget _announcementsSection(BuildContext context, UserRole userRole) {
  return Column(
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(
          "Announcements",
          style: TextStyle(
            fontFamily: AppFonts.gabarito,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        if (userRole == UserRole.manager || userRole == UserRole.coach)
          smallButton(Icons.add_comment, "Add", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddAnnouncementScreen()),
            );
          })
      ]),
      const SizedBox(height: 15),
      announcementBox(
        icon: Icons.announcement,
        iconColor: AppColours.darkBlue,
        title: "Bring your gym gears",
        description:
            "A dedicated session to enhance our fitness levels. Bring your A-game; we're pushing our boundaries.",
        date: "18/11/2023",
        onDeletePressed: () {},
      )
    ],
  );
}
