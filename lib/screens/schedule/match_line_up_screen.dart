import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';

class MatchLineUpScreen extends StatefulWidget {
  const MatchLineUpScreen({Key? key}) : super(key: key);

  @override
  _MatchLineUpScreenState createState() => _MatchLineUpScreenState();
}

class _MatchLineUpScreenState extends State<MatchLineUpScreen> {
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
        body: Container(),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
