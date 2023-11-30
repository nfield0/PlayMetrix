import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';

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
                  radioUserTypeOption(
                      "Manager", "lib/assets/icons/manager.png", selectedOption,
                      (value) {
                    setState(() {
                      selectedOption = value.toString();
                    });
                  }),
                  radioUserTypeOption(
                      "Player", "lib/assets/icons/player.png", selectedOption,
                      (value) {
                    setState(() {
                      selectedOption = value.toString();
                    });
                  }),
                  radioUserTypeOption(
                      "Physio", "lib/assets/icons/physio.png", selectedOption,
                      (value) {
                    setState(() {
                      selectedOption = value.toString();
                    });
                  }),
                  radioUserTypeOption(
                      "Coach", "lib/assets/icons/whistle.png", selectedOption,
                      (value) {
                    setState(() {
                      selectedOption = value.toString();
                    });
                  }),
                  Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: bigButton("Sign up", () {
                        print(selectedOption);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      })),
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

Widget radioUserTypeOption(String text, String imagePath, String selectedOption,
    void Function(String?)? onChanged) {
  return RadioListTile(
    title: Row(
      children: [
        Text(
          text,
          style: const TextStyle(
              fontFamily: AppFonts.openSans,
              //fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        const SizedBox(width: 8.0),
        Image.asset(
          imagePath,
          width: 22.0,
          height: 22.0,
        ),
      ],
    ),
    value: text.toLowerCase(),
    activeColor: AppColours.darkBlue,
    groupValue: selectedOption,
    onChanged: onChanged,
  );
}
