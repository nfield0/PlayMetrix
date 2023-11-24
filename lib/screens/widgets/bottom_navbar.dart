import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';

Widget bottomNavBar(List<BottomNavigationBarItem> items) {
  return BottomNavigationBar(
    backgroundColor: AppColours.darkBlue,
    type: BottomNavigationBarType
        .fixed, // Set type to fixed if you have more than 3 items
    // currentIndex: _selectedIndex,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(.60),
    // onTap: _onItemTapped,
    items: items,
  );
}
