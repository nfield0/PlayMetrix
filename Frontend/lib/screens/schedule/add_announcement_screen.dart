import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/announcement_api_client.dart';
import 'package:play_metrix/api_clients/notification_api_client.dart';
import 'package:play_metrix/api_clients/schedule_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/schedule/schedule_details_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final int scheduleId;
  final UserRole userRole;
  final int userId;
  final int teamId;

  const AddAnnouncementScreen(
      {super.key,
      required this.scheduleId,
      required this.userRole,
      required this.userId,
      required this.teamId});

  @override
  AddAnnouncementScreenState createState() => AddAnnouncementScreenState();
}

class AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Announcement",
            style: TextStyle(
              fontFamily: AppFonts.gabarito,
              color: AppColours.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      "Title", "", true, titleController,
                                      (value) {
                                    return (value != null && value.isEmpty
                                        ? 'This field is required.'
                                        : null);
                                  }),
                                  formFieldBottomBorderNoTitle(
                                      "Details", "", false, detailsController,
                                      (value) {
                                    return (value != null && value.isEmpty
                                        ? 'This field is required.'
                                        : null);
                                  })
                                ]),
                              ),
                              const SizedBox(height: 30),
                              bigButton("Post", () async {
                                if (formKey.currentState!.validate()) {
                                  String scheduleTitle = await getScheduleById(
                                          widget.scheduleId)
                                      .then((value) => value.schedule_title);

                                  addNotification(
                                      title:
                                          "$scheduleTitle: ${titleController.text}",
                                      desc: detailsController.text,
                                      date: DateTime.now(),
                                      teamId: widget.teamId,
                                      recieverUserRole: UserRole.manager,
                                      type: NotificationType.event);

                                  addNotification(
                                      title:
                                          "$scheduleTitle: ${titleController.text}",
                                      desc: detailsController.text,
                                      date: DateTime.now(),
                                      teamId: widget.teamId,
                                      recieverUserRole: UserRole.coach,
                                      type: NotificationType.event);

                                  addNotification(
                                      title:
                                          "$scheduleTitle: ${titleController.text}",
                                      desc: detailsController.text,
                                      date: DateTime.now(),
                                      teamId: widget.teamId,
                                      recieverUserRole: UserRole.physio,
                                      type: NotificationType.event);

                                  addNotification(
                                      title:
                                          "$scheduleTitle: ${titleController.text}",
                                      desc: detailsController.text,
                                      date: DateTime.now(),
                                      teamId: widget.teamId,
                                      recieverUserRole: UserRole.player,
                                      type: NotificationType.event);

                                  addAnnouncement(
                                      title: titleController.text,
                                      details: detailsController.text,
                                      scheduleId: widget.scheduleId,
                                      posterId: widget.userId,
                                      posterType: widget.userRole);

                                  navigator
                                      .push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScheduleDetailsScreen(
                                                  scheduleId: widget.scheduleId,
                                                  userRole: widget.userRole,
                                                  userId: widget.userId,
                                                  teamId: widget.teamId,
                                                )),
                                      )
                                      .then((_) => setState(() {}));
                                }
                              }),
                            ]),
                      )))),
        ),
        bottomNavigationBar:
            roleBasedBottomNavBar(widget.userRole, context, 3));
  }
}
