import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/main.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/player/players_screen.dart';
import 'package:play_metrix/screens/player/statistics_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/schedule/monthly_schedule_screen.dart';
import 'package:play_metrix/screens/settings.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    return FutureBuilder<Profile>(
        future: getProfileDetails(userId, userRole),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Profile profile = snapshot.data!;

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      smallPill(userRoleText(userRole)),
                      profileDropdown(context, profile, userRole, ref),
                    ]),
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/signup_page_bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      top: kToolbarHeight + 70,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hey, ${profile.firstName}!",
                                style: const TextStyle(
                                  fontFamily: AppFonts.gabarito,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                  height: 230, child: _menu(userRole, context))
                            ],
                          ))),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 30),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text("Latest Notifications",
                                      style: TextStyle(
                                        color: AppColours.darkBlue,
                                        fontFamily: AppFonts.gabarito,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      )),
                                  const SizedBox(height: 70),
                                  emptySection(Icons.notifications_none,
                                      "No notifications"),

                                  bigButton("test notif", () async {
                                    await _showNotification();
                                  })
                                  // announcementBox(
                                  //   icon: Icons.cancel,
                                  //   iconColor: AppColours.red,
                                  //   title: "Lucy Field is injured",
                                  //   description:
                                  //       "Date of injury: 26/10/2023\nInjury type: Sprained ankle",
                                  //   date: "2024-02-03T14:27:00Z",
                                  //   onDeletePressed: () {},
                                  // ),
                                  // announcementBox(
                                  //   icon: Icons.cancel,
                                  //   iconColor: AppColours.red,
                                  //   title: "Lucy Field is injured",
                                  //   description:
                                  //       "Date of injury: 26/10/2023\nInjury type: Sprained ankle",
                                  //   date: "2024-02-03T14:27:00Z",
                                  //   onDeletePressed: () {},
                                  // ),
                                  // announcementBox(
                                  //   icon: Icons.cancel,
                                  //   iconColor: AppColours.red,
                                  //   title: "Lucy Field is injured",
                                  //   description:
                                  //       "Date of injury: 26/10/2023\nInjury type: Sprained ankle",
                                  //   date: "2024-02-03T14:27:00Z",
                                  //   onDeletePressed: () {},
                                  // ),
                                ],
                              )),
                        ),
                      ))
                ],
              ),
              bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 2),
            );
          } else {
            return const Text('No data available');
          }
        });
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  Widget _buildMenuItem(
      String text, String imagePath, Color colour, VoidCallback onPressed) {
    return InkWell(
        onTap: onPressed,
        child: SizedBox(
            width: 200,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white60,
                border: Border.all(color: colour, width: 5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    text,
                    style: TextStyle(
                      color: colour,
                      fontFamily: AppFonts.gabarito,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )));
  }

  Widget _menu(UserRole userRole, BuildContext context) {
    switch (userRole) {
      case UserRole.manager:
        return _managerMenu(context);
      case UserRole.coach:
        return _coachMenu(context);
      case UserRole.player:
        return _playerMenu(context);
      case UserRole.physio:
        return _physioMenu(context);
    }
  }

  Widget _gapBetweenMenuItems() {
    return const SizedBox(width: 20);
  }

  Widget _coachMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildMenuItem('Players', 'lib/assets/icons/players_menu.png',
            AppColours.mediumDarkBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => PlayersScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
            AppColours.mediumBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  MonthlyScheduleScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
            AppColours.lightBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => ProfileScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
      ],
    );
  }

  Widget _physioMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildMenuItem('Players & Coaches', 'lib/assets/icons/players_menu.png',
            AppColours.mediumDarkBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => PlayersScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
            AppColours.lightBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => ProfileScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
      ],
    );
  }

  Widget _playerMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildMenuItem('Statistics', 'lib/assets/icons/statistics_menu.png',
            AppColours.mediumDarkBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  StatisticsScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
            AppColours.mediumBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  MonthlyScheduleScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('My Profile', 'lib/assets/icons/players_menu.png',
            AppColours.lightBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  PlayerProfileScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
      ],
    );
  }

  Widget _managerMenu(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildMenuItem('Players & Coaches', 'lib/assets/icons/players_menu.png',
            AppColours.mediumDarkBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => PlayersScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('Schedule', 'lib/assets/icons/schedule_menu.png',
            AppColours.mediumBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  MonthlyScheduleScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
        _gapBetweenMenuItems(),
        _buildMenuItem('My Profile', 'lib/assets/icons/manager_coach_menu.png',
            AppColours.lightBlue, () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => ProfileScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }),
      ],
    );
  }
}

Widget profileDropdown(
    BuildContext context, Profile profile, UserRole userRole, WidgetRef ref) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        value: 'profile',
        hint: Row(
          children: [
            profile.imageBytes != null && profile.imageBytes!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.memory(
                      profile.imageBytes!,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    "lib/assets/icons/profile_placeholder.png",
                    width: 25,
                  ),
            const SizedBox(width: 10),
            const Text(
              "My Profile",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AppColours.darkBlue,
                fontSize: 18,
                color: AppColours.darkBlue,
                // fontFamily: AppFonts.gabarito,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        items: [
          DropdownMenuItem(
            value: 'profile',
            child: Row(
              children: [
                profile.imageBytes != null && profile.imageBytes!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.memory(
                          profile.imageBytes!,
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "lib/assets/icons/profile_placeholder.png",
                        width: 25,
                      ),
                const SizedBox(width: 10),
                const Text(
                  "My Profile",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: AppColours.darkBlue,
                    decorationColor: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const DropdownMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 5),
                Text("Settings"),
              ],
            ),
          ),
          const DropdownMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 5),
                Text("Log Out"),
              ],
            ),
          ),
        ],
        onChanged: (String? value) {
          if (value == 'profile') {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    userRole == UserRole.player
                        ? PlayerProfileScreen()
                        : const ProfileScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (value == 'settings') {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const SettingsScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (value == 'logout') {
            ref.read(userRoleProvider.notifier).state = UserRole.manager;
            ref.read(userIdProvider.notifier).state = 0;
            ref.read(profilePictureProvider.notifier).state = null;
            ref.read(teamIdProvider.notifier).state = -1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LandingScreen()),
            );
          }
        },
      ));
}
