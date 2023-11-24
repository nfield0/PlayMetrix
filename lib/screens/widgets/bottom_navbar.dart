import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

Widget bottomNavBar() {
  return BottomNavigationBar(
    backgroundColor: AppColours.darkBlue,
    type: BottomNavigationBarType
        .fixed, // Set type to fixed if you have more than 3 items
    // currentIndex: _selectedIndex,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(.60),
    // onTap: _onItemTapped,
    items: [
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.home),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.groups),
          ),
          label: 'Teams'),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.calendar_month),
        ),
        label: 'Schedule',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.person_rounded),
        ),
        label: 'My Profile',
      ),
    ],
  );
}
