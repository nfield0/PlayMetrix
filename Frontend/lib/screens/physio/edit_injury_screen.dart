import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class EditInjuryScreen extends StatefulWidget {
  const EditInjuryScreen({Key? key}) : super(key: key);

  @override
  _EditInjuryScreenState createState() => _EditInjuryScreenState();
}

class _EditInjuryScreenState extends State<EditInjuryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Player Profile"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Edit Injury',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 10),
                      divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Column(children: [
                                Image.asset(
                                  "lib/assets/icons/profile_placeholder.png",
                                  width: 120,
                                ),
                                const SizedBox(height: 15),
                                const Text("Player Name",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gabarito,
                                        fontWeight: FontWeight.bold)),
                              ])),
                              const SizedBox(height: 15),
                              formFieldBottomBorder("Date of injury", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder("Date of recovery", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder("Injury type", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder(
                                  "Expected recovery time", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder("Injury location", ""),
                              const SizedBox(height: 5),
                              formFieldBottomBorder("Recovery method", ""),
                              const SizedBox(height: 35),
                              bigButton("Save Changes", () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
