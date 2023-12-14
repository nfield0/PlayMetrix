import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class ProfileSetUpScreen extends StatefulWidget {
  const ProfileSetUpScreen({Key? key}) : super(key: key);

  @override
  _ProfileSetUpScreenState createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  String selectedDivisionValue = "Division 1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Form(
          child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile Set Up',
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
                "lib/assets/icons/profile_placeholder.png",
                width: 100,
              ),
              const SizedBox(height: 10),
              underlineButtonTransparent("Upload picture", () {}),
            ])),
            const SizedBox(height: 20),
            formFieldBottomBorder("Phone", ""),
            const SizedBox(height: 50),
            bigButton("Save Changes", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            })
          ],
        ),
      )),
    );
  }
}
