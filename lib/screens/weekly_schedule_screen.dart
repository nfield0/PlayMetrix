import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WeeklyScheduleScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const WeeklyScheduleScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  _WeeklyScheduleScreenState createState() => _WeeklyScheduleScreenState();
}

class _WeeklyScheduleScreenState extends State<WeeklyScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Schedule",
                    style: TextStyle(
                      color: AppColours.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ))
              ]),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
            padding: const EdgeInsets.all(30),
            child: SfCalendar(
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.appointment) {
                  // Handle the event tap here
                  // You can navigate to another screen or perform any action
                  // based on the tapped event
                  // Example: Navigate to a new screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleDetailsScreen(
                          appointmentId: details.appointments![0].id),
                    ),
                  );
                }
              },
              view: CalendarView.day,
              headerStyle: const CalendarHeaderStyle(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.gabarito,
                ),
              ),
              todayHighlightColor: AppColours.darkBlue,
              selectionDecoration: BoxDecoration(
                border: Border.all(color: AppColours.darkBlue, width: 2.0),
              ),
              initialSelectedDate: widget.selectedDate,
              initialDisplayDate: widget.selectedDate,
              timeSlotViewSettings: const TimeSlotViewSettings(
                numberOfDaysInView: 5,
              ),
              dataSource: AppointmentDataSource(getCalendarDataSource()),
            )),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
