import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole userRole = ref.watch(userRoleProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(
              fontFamily: AppFonts.gabarito,
              color: AppColours.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 20, right: 35, left: 35),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColours.darkBlue),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_2_outlined,
                                size: 28,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 28,
                          )
                        ],
                      )
                    ]))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 4));
  }
}
