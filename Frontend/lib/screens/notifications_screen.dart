import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/state_providers/authentication_providers.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.read(userRoleProvider);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: Container(
          padding: const EdgeInsets.all(40),
          child: Column(children: [
            announcementBox(
              icon: Icons.notifications_active,
              iconColor: AppColours.darkBlue,
              title: "Matchday tomorrow",
              description: "Date: 13/10/2023\nTime: 19:00-20:30",
              date: "2024-02-03T14:27:00Z",
              onDeletePressed: () {},
            ),
            announcementBox(
              icon: Icons.cancel,
              iconColor: AppColours.red,
              title: "Reece James is injured",
              description:
                  "Date of injury: 26/10/2023\nInjury type: Sprained ankle",
              date: "2024-02-03T14:27:00Z",
              onDeletePressed: () {},
            ),
          ]),
        ),
        bottomNavigationBar: roleBasedBottomNavBar(
          userRole,
          context,
          userRole == UserRole.physio ? 2 : 3,
        ));
  }
}
