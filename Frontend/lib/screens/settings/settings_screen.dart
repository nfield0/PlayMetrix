import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/profile/edit_profile_screen.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/settings/change_password_screen.dart';
import 'package:play_metrix/screens/settings/two_fa_settings_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole userRole = ref.watch(userRoleProvider.notifier).state;
    final Uri contactUsUrl = Uri.parse("https://linktr.ee/playmetrix");
    final Uri guidebookUrl =
        Uri.parse("https://online.fliphtml5.com/shnzj/gdnt/index.html#p=1");

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
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionHeader("Your account"),
                              const SizedBox(height: 15),
                              settingsRow("My profile", Icons.person, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen()),
                                );
                              }),
                              settingsRow("Edit profile", Icons.edit, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                          userId: ref.read(userIdProvider),
                                          userRole:
                                              ref.read(userRoleProvider))),
                                );
                              }),
                              settingsRow("Change password", Icons.key_outlined,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordScreen(
                                              userId: ref.read(userIdProvider),
                                              userRole:
                                                  ref.read(userRoleProvider))),
                                );
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: greyDividerThick(),
                              ),
                              const SizedBox(height: 10),
                              sectionHeader("Security"),
                              const SizedBox(height: 15),
                              settingsRow(
                                  "Two-factor authentication", Icons.lock, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TwoFASettingsScreen(
                                          userId: ref.read(userIdProvider),
                                          userRole:
                                              ref.read(userRoleProvider))),
                                );
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: greyDividerThick(),
                              ),
                              const SizedBox(height: 10),
                              sectionHeader("About PlayMetrix"),
                              const SizedBox(height: 15),
                              settingsRow("Online guidebook", Icons.book_online,
                                  () {
                                _launchUrl(guidebookUrl);
                              }),
                              settingsRow("Contact us", Icons.contacts, () {
                                _launchUrl(contactUsUrl);
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: greyDividerThick(),
                              ),
                              InkWell(
                                  onTap: () {
                                    logOut(ref, context);
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      child: Row(children: [
                                        Text(
                                          "Log out",
                                          style: TextStyle(
                                            color: AppColours.red,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ]))),
                            ]))))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 4));
  }
}

Widget sectionHeader(String title) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: AppFonts.gabarito,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColours.darkBlue),
      ));
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

Widget settingsRow(String name, IconData icon, void Function() onTap) {
  return InkWell(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 28,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                size: 28,
              )
            ],
          )));
}
