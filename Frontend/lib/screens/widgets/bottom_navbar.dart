import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';

Widget bottomNavBar(List<BottomNavigationBarItem> items, int selectedIndex,
    void Function(int?)? onPressed) {
  return BottomNavigationBar(
    backgroundColor: AppColours.darkBlue,
    type: BottomNavigationBarType
        .fixed, // Set type to fixed if you have more than 3 items
    currentIndex: selectedIndex,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(.60),
    onTap: onPressed,
    items: items,
  );
}

BottomNavigationBarItem bottomNavBarItem(String label, IconData icon) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
  );
}

Widget roleBasedBottomNavBar(
    UserRole userRole, BuildContext context, int selectedIndex) {
  switch (userRole) {
    case UserRole.manager:
      return managerBottomNavBar(context, selectedIndex);
    case UserRole.coach:
      return coachBottomNavBar(context, selectedIndex);
    case UserRole.player:
      return playerBottomNavBar(context, selectedIndex);
    case UserRole.physio:
      return physioBottomNavBar(context, selectedIndex);
  }
}

playerBottomNavBar(BuildContext context, int selectedIndex) {
  return bottomNavBar([
    bottomNavBarItem("Home", Icons.home),
    bottomNavBarItem("Statistics", Icons.bar_chart),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("My Profile", Icons.person_rounded)
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                StatisticsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                PlayerProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  });
}

managerBottomNavBar(BuildContext context, int selectedIndex) {
  return bottomNavBar([
    bottomNavBarItem("Home", Icons.home),
    bottomNavBarItem("Team", Icons.group),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("My Profile", Icons.person_rounded)
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  });
}

coachBottomNavBar(BuildContext context, int selectedIndex) {
  return bottomNavBar([
    bottomNavBarItem("Home", Icons.home),
    bottomNavBarItem("Players", Icons.group),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("My Profile", Icons.person_rounded)
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  });
}

physioBottomNavBar(BuildContext context, int selectedIndex) {
  return bottomNavBar([
    bottomNavBarItem("Home", Icons.home),
    bottomNavBarItem("Players", Icons.group),
    bottomNavBarItem("My Profile", Icons.person_rounded)
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  });
}
