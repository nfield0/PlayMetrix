import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/notifications_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/settings.dart';

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
    selectedFontSize: 0,
    showSelectedLabels: false,
  );
}

BottomNavigationBarItem bottomNavBarItem(String label, IconData icon) {
  return BottomNavigationBarItem(
    icon: Padding(padding: const EdgeInsets.only(top: 12), child: Icon(icon)),
    label: label,
  );
}

BottomNavigationBarItem bottomNavBarItemCircle(String label, IconData icon) {
  return BottomNavigationBarItem(
    icon: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: AppColours.darkBlue),
          ),
        )),
    label: "",
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
    bottomNavBarItem("Statistics", Icons.bar_chart),
    bottomNavBarItem("Notifications", Icons.notifications),
    bottomNavBarItemCircle("Home", Icons.home),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("Settings", Icons.settings),
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
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
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                NotificationsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
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
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SettingsScreen(),
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
    bottomNavBarItem("Team", Icons.group),
    bottomNavBarItem("Notifications", Icons.notifications),
    bottomNavBarItemCircle("Home", Icons.home),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("Settings", Icons.settings)
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
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
                NotificationsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
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
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SettingsScreen(),
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
    bottomNavBarItem("Players", Icons.group),
    bottomNavBarItem("Notifications", Icons.notifications),
    bottomNavBarItemCircle("Home", Icons.home),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("Settings", Icons.settings)
  ], selectedIndex, (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PlayersScreen(),
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
                NotificationsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(),
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
                MonthlyScheduleScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SettingsScreen(),
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
    bottomNavBarItem("Players", Icons.group),
    bottomNavBarItem("Notifications", Icons.notifications),
    bottomNavBarItemCircle("Home", Icons.home),
    bottomNavBarItem("Schedule", Icons.calendar_month),
    bottomNavBarItem("Settings", Icons.settings),
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
                NotificationsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SettingsScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  });
}
