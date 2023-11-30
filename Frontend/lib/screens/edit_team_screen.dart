import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class EditTeamScreen extends StatefulWidget {
  const EditTeamScreen({Key? key}) : super(key: key);

  @override
  _EditTeamScreenState createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  String selectedDivisionValue = "Division 1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            "Team Profile",
            style: TextStyle(
              color: AppColours.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ]),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
          child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Team',
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.gabarito,
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                )),
            const Divider(
              color: AppColours.darkBlue,
              thickness: 1.0, // Set the thickness of the line
              height: 40.0, // Set the height of the line
            ),
            const SizedBox(height: 20),
            Center(
                child: Column(children: [
              Image.asset(
                "lib/assets/icons/logo_placeholder.png",
                width: 100,
              ),
              const SizedBox(height: 10),
              underlineButtonTransparent("Upload logo", () {}),
            ])),
            formFieldBottomBorder("Club name", "Louth GAA"),
            const SizedBox(height: 10),
            formFieldBottomBorder("Team name", "Senior Football"),
            const SizedBox(height: 10),
            formFieldBottomBorder("Location", "Louth"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Division",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  // Wrap the DropdownButtonFormField with a Container
                  width: 220, // Provide a specific width
                  child: DropdownButtonFormField<String>(
                    focusColor: AppColours.darkBlue,
                    value: selectedDivisionValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDivisionValue = newValue!;
                      });
                    },
                    items: ['Division 1', 'Division 2', 'Division 3']
                        .map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            bigButton("Save Changes", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TeamProfileScreen()),
              );
            })
          ],
        ),
      )),
    );
  }
}
