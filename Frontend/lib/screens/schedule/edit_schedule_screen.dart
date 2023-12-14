import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({Key? key}) : super(key: key);

  @override
  _EditScheduleScreenState createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
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
              child: Container(
            padding: const EdgeInsets.all(40.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  formFieldBottomBorderNoTitle("Title", "", true),
                  formFieldBottomBorderNoTitle("Location", "", false)
                ]),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  dateTimePickerWithDivider(
                      context, "Starts", DateTime.now(), (p0) {}),
                  greyDivider(),
                  dateTimePickerWithDivider(
                      context, "Ends", DateTime.now(), (p0) {}),
                ]),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColours.darkBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  dropdownWithDivider("Type", "Training",
                      ["Training", "Match", "Meeting", "Other"], (p0) {}),
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
                ]),
              ),
              const SizedBox(height: 30),
              bigButton("Save Changes", () {}),
            ]),
          )),
        ),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
