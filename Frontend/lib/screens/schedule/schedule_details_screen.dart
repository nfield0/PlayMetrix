import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/schedule/add_announcement_screen.dart';
import 'package:play_metrix/screens/schedule/edit_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/match_line_up_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/schedule/players_attending_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Announcement {
  final int id;
  final String title;
  final String description;
  final String date;
  final int scheduleId;
  final int posterId;
  final UserRole posterRole;

  Announcement(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.scheduleId,
      required this.posterId,
      required this.posterRole});
}

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

class ScheduleDetailsScreen extends StatefulWidget {
  final int scheduleId;
  final int playerId;
  final int teamId;
  final UserRole userRole;
  const ScheduleDetailsScreen(
      {super.key,
      required this.scheduleId,
      required this.playerId,
      required this.userRole,
      required this.teamId});

  @override
  ScheduleDetailsScreenState createState() => ScheduleDetailsScreenState();
}

class ScheduleDetailsScreenState extends State<ScheduleDetailsScreen> {
  late PlayerAttendingStatus playerAttendingStatus;
  late List<Announcement> announcements;

  @override
  void initState() {
    super.initState();

    getPlayerAttendingStatus(widget.playerId, widget.scheduleId)
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
                                        ? widget.playerId
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
                                                schedule: sch,
                                              )),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PlayersAttendingScreen(
                                                scheduleId: widget.scheduleId,
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
                            Row(
                              children: [
                                playerAttendingStatus ==
                                        PlayerAttendingStatus.present
                                    ? smallButtonBlue(Icons.check, "Yes", () {})
                                    : smallButton(Icons.check, "Yes", () {
                                        setState(() {
                                          playerAttendingStatus =
                                              PlayerAttendingStatus.present;
                                        });
                                        updatePlayerAttendingStatus(
                                            widget.playerId,
                                            widget.scheduleId,
                                            PlayerAttendingStatus.present);
                                      }),
                                const SizedBox(width: 10),
                                playerAttendingStatus ==
                                        PlayerAttendingStatus.absent
                                    ? smallButtonBlue(Icons.close, "No", () {})
                                    : smallButton(Icons.close, "No", () {
                                        setState(() {
                                          playerAttendingStatus =
                                              PlayerAttendingStatus.absent;
                                        });
                                        updatePlayerAttendingStatus(
                                            widget.playerId,
                                            widget.scheduleId,
                                            PlayerAttendingStatus.absent);
                                      }),
                                const SizedBox(width: 10),
                                playerAttendingStatus ==
                                        PlayerAttendingStatus.undecided
                                    ? smallButtonBlue(
                                        Icons.question_mark, "Unknown", () {})
                                    : smallButton(
                                        Icons.question_mark, "Unknown", () {
                                        setState(() {
                                          playerAttendingStatus =
                                              PlayerAttendingStatus.undecided;
                                        });
                                        updatePlayerAttendingStatus(
                                            widget.playerId,
                                            widget.scheduleId,
                                            PlayerAttendingStatus.undecided);
                                      }),
                              ],
                            ),
                          const SizedBox(height: 15),
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
                          _announcementsSection(context, widget.userRole,
                              widget.scheduleId, announcements),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar:
                      roleBasedBottomNavBar(widget.userRole, context, 2));
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
  List<Appointment> allAppointments = await getTeamSchedules(teamId);
  List<Appointment> filteredAppointments = allAppointments
      .where((appointment) => appointment.id == appointmentId)
      .toList();
  return AppointmentDataSource(filteredAppointments);
}

Widget _announcementsSection(BuildContext context, UserRole userRole,
    int scheduleId, List<Announcement> announcements) {
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
                        scheduleId: scheduleId,
                        userRole: userRole,
                      )),
            );
          })
      ]),
      const SizedBox(height: 15),
      for (Announcement announcement in announcements)
        announcementBox(
            icon: Icons.announcement,
            iconColor: AppColours.darkBlue,
            title: announcement.title,
            description: announcement.description,
            date: announcement.date,
            onDeletePressed: () {})
    ],
  );
}
