import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/notification_api_client.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

final startTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final endTimeProvider = StateProvider<DateTime>((ref) => DateTime.now().add(
      const Duration(hours: 1),
    ));
final typeProvider =
    StateProvider<String>((ref) => scheduleTypeToText(ScheduleType.training));
final alertTimeProvider =
    StateProvider<String>((ref) => alertTimeToText(AlertTime.none));

class AddScheduleScreen extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AddScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);

    String selectedType = ref.watch(typeProvider);
    String selectedAlertTime = ref.watch(alertTimeProvider);
    DateTime selectedStartDate = ref.watch(startTimeProvider);
    DateTime selectedEndDate = ref.watch(endTimeProvider);

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
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Schedule',
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
                          dateTimePickerWithDivider(
                              context, "Starts", selectedStartDate, (value) {
                            ref.read(startTimeProvider.notifier).state = value;
                          }),
                          greyDivider(),
                          dateTimePickerWithDivider(
                              context, "Ends", selectedEndDate, (value) {
                            ref.read(endTimeProvider.notifier).state = value;
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
                          dropdownWithDivider("Type", selectedType, [
                            scheduleTypeToText(ScheduleType.training),
                            scheduleTypeToText(ScheduleType.match),
                            scheduleTypeToText(ScheduleType.meeting),
                            scheduleTypeToText(ScheduleType.other)
                          ], (value) {
                            ref.read(typeProvider.notifier).state = value!;
                          }),
                          greyDivider(),
                          dropdownWithDivider("Alert", selectedAlertTime, [
                            alertTimeToText(AlertTime.none),
                            alertTimeToText(AlertTime.fifteenMinutes),
                            alertTimeToText(AlertTime.thirtyMinutes),
                            alertTimeToText(AlertTime.oneHour),
                            alertTimeToText(AlertTime.twoHours),
                            alertTimeToText(AlertTime.oneDay),
                            alertTimeToText(AlertTime.twoDays),
                          ], (value) {
                            ref.read(alertTimeProvider.notifier).state = value!;
                          }),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      bigButton("Add Schedule", () async {
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
                            int scheduleId = await addSchedule(
                                titleController.text,
                                locationController.text,
                                selectedStartDate,
                                selectedEndDate,
                                textToScheduleType(selectedType),
                                textToAlertTime(selectedAlertTime),
                                ref.read(teamIdProvider));

                            await addNotification(
                                title: "New event: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: DateTime.now(),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.coach);

                            await addNotification(
                                title: "New event: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: DateTime.now(),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.physio);

                            await addNotification(
                                title: "New event: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: DateTime.now(),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.player);

                            await addNotification(
                                title:
                                    "Event reminder: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: selectedStartDate.subtract(
                                    alertTimeToDuration(
                                        textToAlertTime(selectedAlertTime))),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.coach);

                            await addNotification(
                                title:
                                    "Event reminder: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: selectedStartDate.subtract(
                                    alertTimeToDuration(
                                        textToAlertTime(selectedAlertTime))),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.physio);

                            await addNotification(
                                title:
                                    "Event reminder: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: selectedStartDate.subtract(
                                    alertTimeToDuration(
                                        textToAlertTime(selectedAlertTime))),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.player);

                            await addNotification(
                                title:
                                    "Event reminder: ${titleController.text}",
                                desc: "Location: ${locationController.text}\n"
                                    "Starts: ${selectedStartDate.toString().substring(0, 16)}\n"
                                    "Ends: ${selectedEndDate.toString().substring(0, 16)}",
                                date: selectedStartDate.subtract(
                                    alertTimeToDuration(
                                        textToAlertTime(selectedAlertTime))),
                                teamId: ref.read(teamIdProvider),
                                recieverUserRole: UserRole.manager);

                            navigator
                                .push(MaterialPageRoute(builder: (context) {
                              return ScheduleDetailsScreen(
                                userId: ref.read(userIdProvider),
                                userRole: ref.read(userRoleProvider),
                                teamId: ref.read(teamIdProvider),
                                scheduleId: scheduleId,
                              );
                            }));

                            titleController.clear();
                            locationController.clear();
                            ref.read(startTimeProvider.notifier).state =
                                DateTime.now();
                            ref.read(endTimeProvider.notifier).state =
                                DateTime.now().add(const Duration(hours: 1));
                            ref.read(typeProvider.notifier).state =
                                scheduleTypeToText(ScheduleType.training);
                            ref.read(alertTimeProvider.notifier).state =
                                alertTimeToText(AlertTime.none);
                          }
                        }
                      }),
                    ]),
              )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 3));
  }
}
