import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/schedule_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';

class EditScheduleScreen extends StatefulWidget {
  final int scheduleId;
  final UserRole userRole;
  final int teamId;
  final int playerId;

  const EditScheduleScreen(
      {super.key,
      required this.playerId,
      required this.scheduleId,
      required this.userRole,
      required this.teamId});

  @override
  EditScheduleScreenState createState() => EditScheduleScreenState();
}

class EditScheduleScreenState extends State<EditScheduleScreen> {
  late Schedule schedule;
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String selectedScheduleType = scheduleTypeToText(ScheduleType.training);
  String selectedScheduleAlert = alertTimeToText(AlertTime.none);

  @override
  void initState() {
    super.initState();
    getScheduleById(widget.scheduleId).then((retrievedSchedule) {
      setState(() {
        schedule = retrievedSchedule;
        titleController.text = schedule.schedule_title;
        locationController.text = schedule.schedule_location;
        selectedStartDate = DateTime.parse(schedule.schedule_start_time);
        selectedEndDate = DateTime.parse(schedule.schedule_end_time);
        selectedScheduleType = schedule.schedule_type;
        selectedScheduleAlert = schedule.schedule_alert_time;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          formFieldBottomBorderNoTitle(
                              "Title", "", true, titleController, (value) {
                            return (value != null && value == ""
                                ? 'This field is required.'
                                : null);
                          }),
                          formFieldBottomBorderNoTitle(
                              "Location", "", false, locationController,
                              (value) {
                            return (value != null && value == ""
                                ? 'This field is required.'
                                : null);
                          })
                        ]),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          dateTimePickerWithDivider(
                              context, "Starts", selectedStartDate, (value) {
                            if (value.isAfter(
                                DateTime.parse(schedule.schedule_end_time))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: AppColours.red,
                                      padding: EdgeInsets.all(20.0),
                                      content: Text(
                                          "Start time cannot be after end time",
                                          style: TextStyle(fontSize: 16.0))));
                            } else {
                              setState(() {
                                selectedStartDate = value;
                              });
                            }
                          }),
                          greyDivider(),
                          dateTimePickerWithDivider(
                              context, "Ends", selectedEndDate, (value) {
                            if (value.isBefore(
                                DateTime.parse(schedule.schedule_start_time))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: AppColours.red,
                                      padding: EdgeInsets.all(20.0),
                                      content: Text(
                                          "End time cannot be before start time",
                                          style: TextStyle(fontSize: 16.0))));
                            } else {
                              setState(() {
                                selectedEndDate = value;
                              });
                            }
                          }),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: AppColours.darkBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          dropdownWithDivider("Type", selectedScheduleType, [
                            scheduleTypeToText(ScheduleType.training),
                            scheduleTypeToText(ScheduleType.match),
                            scheduleTypeToText(ScheduleType.meeting),
                            scheduleTypeToText(ScheduleType.other)
                          ], (value) {
                            setState(() {
                              selectedScheduleType = value!;
                            });
                          }),
                          greyDivider(),
                          dropdownWithDivider("Alert", selectedScheduleAlert, [
                            alertTimeToText(AlertTime.none),
                            alertTimeToText(AlertTime.fifteenMinutes),
                            alertTimeToText(AlertTime.thirtyMinutes),
                            alertTimeToText(AlertTime.oneHour),
                            alertTimeToText(AlertTime.twoHours),
                            alertTimeToText(AlertTime.oneDay),
                            alertTimeToText(AlertTime.twoDays),
                          ], (value) {
                            setState(() {
                              selectedScheduleAlert = value!;
                            });
                          }),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      bigButton("Save Changes", () async {
                        if (formKey.currentState!.validate()) {
                          if (selectedEndDate.isBefore(selectedStartDate)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: AppColours.red,
                                    padding: EdgeInsets.all(20.0),
                                    content: Text(
                                        "End time cannot be before start time",
                                        style: TextStyle(fontSize: 16.0))));
                          } else {
                            bool editSuccess = await editSchedule(
                                widget.scheduleId,
                                titleController.text,
                                locationController.text,
                                selectedScheduleType,
                                selectedStartDate,
                                selectedEndDate,
                                selectedScheduleAlert);
                            if (editSuccess) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScheduleDetailsScreen(
                                          userId:
                                              widget.userRole == UserRole.player
                                                  ? widget.playerId
                                                  : -1,
                                          userRole: widget.userRole,
                                          teamId: widget.teamId,
                                          scheduleId: widget.scheduleId,
                                        )),
                              );
                            }
                          }
                        }
                      }),
                    ]),
              )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 3));
  }
}
