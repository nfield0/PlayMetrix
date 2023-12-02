import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class ScheduleDetailsScreen extends StatefulWidget {
  int appointmentId = 1;

  ScheduleDetailsScreen({Key? key, required this.appointmentId})
      : super(key: key);

  @override
  _ScheduleDetailsScreenState createState() => _ScheduleDetailsScreenState();
}

class _ScheduleDetailsScreenState extends State<ScheduleDetailsScreen> {
  AppointmentDataSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = getFilteredDataSource(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage(DateFormat('MMMM y').format(
            _dataSource?.appointments?[0].startTime ?? DateTime.now(),
          )),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 35),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dataSource?.appointments?[0].subject ?? "",
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
                      _dataSource?.appointments?[0].startTime ??
                          DateTime.now()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${DateFormat('jm').format(_dataSource?.appointments?[0].startTime)} to ${DateFormat('jm').format(_dataSource?.appointments?[0].endTime)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                // Location?
                Text(
                  _dataSource?.appointments?[0].location ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [underlineButtonTransparent("Match lineup", () {})],
                ),
                greyDivider(),
                SizedBox(
                  height: 160,
                  child: SfCalendar(
                    view: CalendarView.schedule,
                    dataSource: _dataSource,
                    minDate: _dataSource?.appointments?[0].startTime!,
                    maxDate: _dataSource?.appointments?[0].startTime!
                        .add(const Duration(days: 1)),
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
                divider(),
                const SizedBox(height: 15),
                _announcementsSection()
              ],
            ),
          ),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}

AppointmentDataSource getFilteredDataSource(int id) {
  List<Appointment> allAppointments = getCalendarDataSource();
  // Replace with your specific criteria for filtering
  List<Appointment> filteredAppointments =
      allAppointments.where((appointment) => appointment.id == id).toList();
  return AppointmentDataSource(filteredAppointments);
}

Widget _announcementsSection() {
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
        smallButton(Icons.add_comment, "Add", () {})
      ]),
      _announcementBox(
          icon: Icons.announcement,
          title: "Bring your gym gears",
          description:
              "A dedicated session to enhance our fitness levels. Bring your A-game; we're pushing our boundaries.",
          date: "18/11/2023",
          onDeletePressed: () {})
    ],
  );
}

Widget _announcementBox({
  required IconData icon,
  required String title,
  required String description,
  required String date,
  required VoidCallback onDeletePressed,
}) {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: AppColours.darkBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColours.darkBlue,
                  width: 2,
                ), // Border color
                borderRadius: BorderRadius.circular(8.0),
              ),
              constraints: const BoxConstraints(
                minHeight: 70, // Set your desired minHeight
              ),
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  // Icon on top left
                  // Title and description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(description),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: onDeletePressed,
                      child: const Icon(
                        Icons.delete,
                        size: 20,
                        color: AppColours.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}
