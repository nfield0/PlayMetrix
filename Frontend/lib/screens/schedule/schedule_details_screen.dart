import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/announcement_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/announcement_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/schedule/add_announcement_screen.dart';
import 'package:play_metrix/screens/schedule/edit_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/match_line_up_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/players_attending_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class ScheduleDetailsScreen extends StatefulWidget {
  final int scheduleId;
  final int userId;
  final int teamId;
  final UserRole userRole;
  const ScheduleDetailsScreen(
      {super.key,
      required this.scheduleId,
      required this.userId,
      required this.userRole,
      required this.teamId});

  @override
  ScheduleDetailsScreenState createState() => ScheduleDetailsScreenState();
}

class ScheduleDetailsScreenState extends State<ScheduleDetailsScreen> {
  PlayerAttendingStatus playerAttendingStatus = PlayerAttendingStatus.undecided;
  List<Announcement> announcements = [];

  @override
  void initState() {
    super.initState();

    getPlayerAttendingStatus(widget.userId, widget.scheduleId)
        .then((value) => setState(() {
              playerAttendingStatus = value;
            }));

    getAnnouncementsByScheduleId(widget.scheduleId)
        .then((value) => setState(() {
              announcements = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    ScheduleType scheduleType;

    return FutureBuilder(
        future: getFilteredDataSource(widget.teamId, widget.scheduleId),
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
                          if (widget.userRole == UserRole.manager)
                            smallButton(Icons.edit, "Edit", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditScheduleScreen(
                                    playerId: widget.userRole == UserRole.player
                                        ? widget.userId
                                        : -1,
                                    scheduleId: widget.scheduleId,
                                    teamId: widget.teamId,
                                    userRole: widget.userRole,
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
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
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
                                  if (widget.userRole == UserRole.manager ||
                                      widget.userRole == UserRole.coach)
                                    underlineButtonTransparent(
                                        scheduleType == ScheduleType.match
                                            ? "Match lineup"
                                            : "Players attending", () {
                                      if (scheduleType == ScheduleType.match) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MatchLineUpScreen(
                                                    userRole: widget.userRole,
                                                    teamId: widget.teamId,
                                                    scheduleId:
                                                        widget.scheduleId,
                                                    schedule: sch,
                                                  )),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayersAttendingScreen(
                                                    scheduleId:
                                                        widget.scheduleId,
                                                    teamId: widget.teamId,
                                                  )),
                                        );
                                      }
                                    })
                                ],
                              ),
                              if (widget.userRole == UserRole.player)
                                const Text(
                                  "Attending?",
                                  style: TextStyle(
                                    fontFamily: AppFonts.gabarito,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              if (widget.userRole == UserRole.player)
                                const SizedBox(height: 15),
                              if (widget.userRole == UserRole.player)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    children: [
                                      if (playerAttendingStatus ==
                                          PlayerAttendingStatus.present)
                                        smallButtonBlue(
                                            Icons.check, "Yes", () {}),
                                      if (playerAttendingStatus !=
                                          PlayerAttendingStatus.present)
                                        smallButton(Icons.check, "Yes", () {
                                          setState(() {
                                            playerAttendingStatus =
                                                PlayerAttendingStatus.present;
                                          });
                                          updatePlayerAttendingStatus(
                                            widget.userId,
                                            widget.scheduleId,
                                            PlayerAttendingStatus.present,
                                          );
                                        }),
                                      const SizedBox(width: 10),
                                      if (playerAttendingStatus ==
                                          PlayerAttendingStatus.absent)
                                        smallButtonBlue(
                                            Icons.close, "No", () {}),
                                      if (playerAttendingStatus !=
                                          PlayerAttendingStatus.absent)
                                        smallButton(Icons.close, "No", () {
                                          setState(() {
                                            playerAttendingStatus =
                                                PlayerAttendingStatus.absent;
                                          });
                                          updatePlayerAttendingStatus(
                                            widget.userId,
                                            widget.scheduleId,
                                            PlayerAttendingStatus.absent,
                                          );
                                        }),
                                      const SizedBox(width: 10),
                                      if (playerAttendingStatus ==
                                          PlayerAttendingStatus.undecided)
                                        smallButtonBlue(Icons.question_mark,
                                            "Unknown", () {}),
                                      if (playerAttendingStatus !=
                                          PlayerAttendingStatus.undecided)
                                        smallButton(
                                            Icons.question_mark, "Unknown", () {
                                          setState(() {
                                            playerAttendingStatus =
                                                PlayerAttendingStatus.undecided;
                                          });
                                          updatePlayerAttendingStatus(
                                            widget.userId,
                                            widget.scheduleId,
                                            PlayerAttendingStatus.undecided,
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 15),
                              greyDivider(),
                              SizedBox(
                                height: 160,
                                child: SfCalendar(
                                  view: CalendarView.schedule,
                                  dataSource: dataSource,
                                  minDate: sch.startTime,
                                  maxDate: sch.startTime
                                      .add(const Duration(days: 1)),
                                  scheduleViewSettings:
                                      const ScheduleViewSettings(
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
                              _announcementsSection(
                                  context,
                                  widget.userRole,
                                  widget.scheduleId,
                                  widget.userId,
                                  announcements,
                                  widget.teamId),
                            ],
                          ),
                        ),
                      )),
                  bottomNavigationBar:
                      roleBasedBottomNavBar(widget.userRole, context, 3));
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        });
  }
}

Future<AppointmentDataSource> getFilteredDataSource(
    int teamId, int appointmentId) async {
  List<Appointment> allAppointments = await getTeamAppointments(teamId);
  List<Appointment> filteredAppointments = allAppointments
      .where((appointment) => appointment.id == appointmentId)
      .toList();
  return AppointmentDataSource(filteredAppointments);
}

Widget _announcementsSection(BuildContext context, UserRole userRole,
    int scheduleId, int userId, List<Announcement> announcements, int teamId) {
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
                  builder: (context) => AddAnnouncementScreen(
                        userId: userId,
                        scheduleId: scheduleId,
                        userRole: userRole,
                        teamId: teamId,
                      )),
            );
          })
      ]),
      const SizedBox(height: 15),
      if (announcements.isEmpty)
        Column(children: [
          const SizedBox(height: 20),
          emptySection(Icons.announcement, "No announcements yet")
        ]),
      for (Announcement announcement in announcements)
        announcementBox(
            icon: Icons.announcement,
            iconColor: AppColours.darkBlue,
            title: announcement.title,
            description: announcement.description,
            date: announcement.date)
    ],
  );
}
