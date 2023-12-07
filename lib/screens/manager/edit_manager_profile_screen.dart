import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';

class EditManagerProfileScreen extends StatefulWidget {
  const EditManagerProfileScreen({Key? key}) : super(key: key);

  @override
  _EditManagerProfileScreenState createState() =>
      _EditManagerProfileScreenState();
}

class _EditManagerProfileScreenState extends State<EditManagerProfileScreen> {
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
        body: Padding(
            padding: const EdgeInsets.only(top: 30, right: 35, left: 35),
            child: Column(children: [])),
        bottomNavigationBar: managerBottomNavBar(context, 3));
  }
}
