import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/add_schedule_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MonthlyScheduleScreen extends StatefulWidget {
  const MonthlyScheduleScreen({Key? key}) : super(key: key);

  @override
  _MonthlyScheduleScreenState createState() => _MonthlyScheduleScreenState();
}

class _MonthlyScheduleScreenState extends State<MonthlyScheduleScreen> {
  @override
  Widget build(BuildContext context) {
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
                  smallButton(Icons.add_task, "Add", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddScheduleScreen()),
                    );
                  })
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SfCalendar(
                  dataSource: _getCalendarDataSource(),
                  view: CalendarView.month,
                  todayHighlightColor: AppColours.darkBlue,
                  selectionDecoration: BoxDecoration(
                    border: Border.all(color: AppColours.darkBlue, width: 2.0),
                  ),
                  headerStyle: const CalendarHeaderStyle(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.gabarito,
                    ),
                  ),
                  monthViewSettings: const MonthViewSettings(showAgenda: true),
                ),
              )
            ])),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

_AppointmentDataSource _getCalendarDataSource() {
  List<Appointment> appointments = [
    Appointment(
      startTime: DateTime(2023, 11, 5, 10, 0),
      endTime: DateTime(2023, 11, 5, 11, 0),
      subject: 'Meeting 1',
      color: Colors.blue,
    ),
    Appointment(
      startTime: DateTime(2023, 11, 12, 14, 0),
      endTime: DateTime(2023, 11, 12, 15, 0),
      subject: 'Meeting 2',
      color: Colors.green,
    ),
    Appointment(
      startTime: DateTime(2023, 11, 20, 16, 0),
      endTime: DateTime(2023, 11, 20, 17, 0),
      subject: 'Meeting 3',
      color: Colors.red,
    ),
  ];

  return _AppointmentDataSource(appointments);
}
