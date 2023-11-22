import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

class SignUpChooseTypeScreen extends StatefulWidget {
  const SignUpChooseTypeScreen({Key? key}) : super(key: key);

  @override
  _SignUpChooseTypeScreenState createState() => _SignUpChooseTypeScreenState();
}

class _SignUpChooseTypeScreenState extends State<SignUpChooseTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedOption = 'manager';

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
        key: _formKey,
        autovalidateMode: AutovalidateMode.always, // Enable auto validation
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sign Up',
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
              const Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Text('Are you using this app as a...',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.openSans,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RadioListTile(
                    title: Row(
                      children: [
                        const Text(
                          'Manager',
                          style: TextStyle(
                              fontFamily: AppFonts.openSans,
                              //fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          'lib/assets/icons/manager.png',
                          width: 22.0,
                          height: 22.0,
                        ),
                      ],
                    ),
                    activeColor: AppColours.darkBlue,
                    value: 'manager',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Row(
                      children: [
                        const Text(
                          'Player',
                          style: TextStyle(
                              fontFamily: AppFonts.openSans,
                              //fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          'lib/assets/icons/player.png',
                          width: 22.0,
                          height: 22.0,
                        ),
                      ],
                    ),
                    value: 'player',
                    activeColor: AppColours.darkBlue,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Row(
                      children: [
                        const Text(
                          'Physio',
                          style: TextStyle(
                              fontFamily: AppFonts.openSans,
                              //fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          'lib/assets/icons/physio.png',
                          width: 22.0,
                          height: 22.0,
                        ),
                      ],
                    ),
                    value: 'physio',
                    activeColor: AppColours.darkBlue,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Row(
                      children: [
                        const Text(
                          'Coach',
                          style: TextStyle(
                              fontFamily: AppFonts.openSans,
                              //fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          'lib/assets/icons/whistle.png',
                          width: 22.0,
                          height: 22.0,
                        ),
                      ],
                    ),
                    value: 'coach',
                    activeColor: AppColours.darkBlue,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value.toString();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0),
                    child: CupertinoButton(
                      onPressed: () {
                        print(selectedOption);
                      },
                      borderRadius: BorderRadius.circular(30),
                      color: AppColours.darkBlue,
                      child: const SizedBox(
                        width: double
                            .infinity, // Set width to infinity to take up the full width
                        child: Center(
                          child: Text('Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.openSans,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
