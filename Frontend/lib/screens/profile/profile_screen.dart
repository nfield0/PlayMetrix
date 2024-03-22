import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/api_clients/coach_api_client.dart';
import 'package:play_metrix/api_clients/manager_api_client.dart';
import 'package:play_metrix/api_clients/physio_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/coach_data_model.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/data_models/team_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/profile/edit_profile_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

Future<Profile> getProfileDetails(int userId, UserRole userRole) async {
  if (userRole == UserRole.manager) {
    return await getManagerProfile(userId);
  } else if (userRole == UserRole.physio) {
    return await getPhysioProfile(userId);
  } else if (userRole == UserRole.coach) {
    return await getCoachProfile(userId);
  } else {
    return await getPlayerProfile(userId);
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;
    final userId = ref.watch(userIdProvider.notifier).state;

    if (userRole != UserRole.coach) {
      return FutureBuilder<Profile>(
          future: getProfileDetails(userId, userRole),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Profile profile = snapshot.data!;

              return profileDetails(
                  profile, context, ref, userId, userRole, "", false);
            } else {
              return const Text('No data available');
            }
          });
    } else {
      return FutureBuilder<CoachData>(
          future: getCoachDataProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              CoachData coachData = snapshot.data!;

              return profileDetails(coachData.profile, context, ref, userId,
                  userRole, coachTeamRoleToText(coachData.role), false);
            } else {
              return const Text('No data available');
            }
          });
    }
  }
}

Widget profileDetails(Profile profile, BuildContext context, WidgetRef ref,
    int userId, UserRole userRole, String teamRole, bool isViewOnly) {
  return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Profile",
              style: TextStyle(
                fontFamily: AppFonts.gabarito,
                color: AppColours.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            smallButton(Icons.edit, "Edit", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                          userId: userId,
                          userRole: userRole,
                        )),
              );
            }),
          ],
        ),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 35, left: 35),
                      child: Column(children: [
                        Center(
                          child: Column(children: [
                            Text(
                              "${profile.firstName} ${profile.surname}",
                              style: const TextStyle(
                                fontFamily: AppFonts.gabarito,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            profile.imageBytes != null &&
                                    profile.imageBytes!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        75), // Adjust the radius as needed
                                    child: Image.memory(
                                      profile.imageBytes!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit
                                          .cover, // Ensure the image fills the rounded rectangle
                                    ),
                                  )
                                : Image.asset(
                                    "lib/assets/icons/profile_placeholder.png",
                                    width: 150),
                            const SizedBox(height: 20),
                            smallPill(userRole == UserRole.coach
                                ? teamRole
                                : userRoleText(userRole)),
                            const SizedBox(height: 40),
                            FutureBuilder(
                                future: getTeamById(
                                    ref.read(teamIdProvider.notifier).state),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    TeamData team = snapshot.data!;
                                    return profilePill(
                                        team.team_name,
                                        team.team_location,
                                        "lib/assets/icons/logo_placeholder.png",
                                        team.team_logo, () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeamProfileScreen()),
                                      );
                                    });
                                  } else {
                                    return emptySection(
                                        Icons.group_off, "No team yet");
                                  }
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
                            detailWithDivider(
                                "Phone", profile.contactNumber, context),
                            const SizedBox(height: 10),
                            detailWithDivider("Email", profile.email, context),
                            const SizedBox(height: 25),
                            if (!isViewOnly)
                              bigButton("Log Out", () async {
                                logOut(ref, context);
                              }),
                            const SizedBox(height: 25),
                          ]),
                        )
                      ]))))),
      bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 2));
}
