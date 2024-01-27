import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({Key? key}) : super(key: key);

  @override
  _AddAnnouncementScreenState createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Schedule"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Container(
            padding: const EdgeInsets.all(40.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add Announcement',
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
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  formFieldBottomBorderNoTitle(
                      "Title", "", true, titleController, (value) {
                    return (value != null ? 'This field is required.' : null);
                  }),
                  formFieldBottomBorderNoTitle(
                      "Details", "", false, detailsController, (value) {
                    return (value != null ? 'This field is required.' : null);
                  })
                ]),
              ),
              const SizedBox(height: 30),
              bigButton("Send Announcement", () {}),
            ]),
          )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
