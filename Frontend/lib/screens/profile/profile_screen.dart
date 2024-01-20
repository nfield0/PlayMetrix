import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/profile/edit_profile.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

Future<Profile> getProfileDetails(int userId, UserRole userRole) async {
  if (userRole == UserRole.manager) {
    return await getManagerProfile(userId);
  } else if (userRole == UserRole.physio) {
    return await getPhysioProfile(userId);
  } else if (userRole == UserRole.coach) {
    return await getCoachProfile(userId);
  }

  return Profile(
      "firstName", "surname", "contactNumber", "email", Uint8List(0));
}

class ProfileScreen extends ConsumerWidget {
  late Profile profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    return FutureBuilder<Profile>(
        future: getProfileDetails(4, UserRole.coach),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            profile = snapshot.data!;

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
                body: SingleChildScrollView(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 30, right: 35, left: 35),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Profile",
                                style: TextStyle(
                                  fontFamily: AppFonts.gabarito,
                                  color: AppColours.darkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                              smallButton(Icons.edit, "Edit", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen()),
                                );
                              }),
                            ],
                          ),
                          Center(
                            child: Column(children: [
                              const SizedBox(height: 20),
                              Text(
                                "${profile.firstName} ${profile.surname}",
                                style: const TextStyle(
                                  fontFamily: AppFonts.gabarito,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              profile.imageBytes != null
                                  ? Image.memory(
                                      profile.imageBytes!,
                                      width: 150,
                                      height: 150,
                                    )
                                  : Image.asset(
                                      "lib/assets/icons/profile_placeholder.png",
                                      width: 150),
                              const SizedBox(height: 20),
                              smallPill(userRoleText(userRole)),
                              const SizedBox(height: 40),
                              profilePill("Louth GAA", "Senior Football",
                                  "lib/assets/icons/logo_placeholder.png", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeamProfileScreen()),
                                );
                              }),
                              const SizedBox(height: 20),
                              divider(),
                              const SizedBox(height: 20),
                              const Text("Contacts",
                                  style: TextStyle(
                                    fontFamily: AppFonts.gabarito,
                                    fontSize: 32,
                                    color: AppColours.darkBlue,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 20),
                              detailWithDivider("Phone", profile.contactNumber),
                              const SizedBox(height: 10),
                              detailWithDivider("Email", profile.email),
                              const SizedBox(height: 25),
                              bigButton("Log Out", () {
                                ref.read(userRoleProvider.notifier).state =
                                    UserRole.manager;
                                ref.read(userIdProvider.notifier).state = 0;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LandingScreen()),
                                );
                              }),
                              const SizedBox(height: 25),
                            ]),
                          )
                        ]))),
                bottomNavigationBar: userRole != UserRole.physio
                    ? roleBasedBottomNavBar(userRole, context, 3)
                    : roleBasedBottomNavBar(userRole, context, 2));
          } else {
            return Text('No data available');
          }
        });
  }
}
