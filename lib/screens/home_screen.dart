import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColours.darkBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 180),
                const Icon(
                  Icons.notifications,
                  color: AppColours.darkBlue,
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              "Hey, Brian!",
              style: TextStyle(
                fontFamily: AppFonts.gabarito,
                color: AppColours.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 40),
            // Box 1
            _buildMenuItem('Players & Coaches',
                'lib/assets/icons/players_menu.png', AppColours.mediumDarkBlue),
            const SizedBox(height: 20),
            // Box 2
            _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
                AppColours.mediumBlue),
            const SizedBox(height: 20),
            // Box 3
            _buildMenuItem(
                'My Profile',
                'lib/assets/icons/manager_coach_menu.png',
                AppColours.lightBlue),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavBar([
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.home),
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.groups),
            ),
            label: 'Teams'),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.calendar_month),
          ),
          label: 'Schedule',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.person_rounded),
          ),
          label: 'My Profile',
        ),
      ]),
    );
  }
}

Widget _buildMenuItem(String text, String imagePath, Color colour) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    decoration: BoxDecoration(
      // color: AppColours.darkBlue,
      border: Border.all(color: colour, width: 5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Image.asset(
          imagePath,
          width: 100,
          height: 100,
        ),
        SizedBox(width: 37),
        Flexible(
          child: Wrap(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: colour,
                  fontFamily: AppFonts.gabarito,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
