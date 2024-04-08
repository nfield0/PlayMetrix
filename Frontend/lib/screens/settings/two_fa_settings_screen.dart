import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/profile/profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class TwoFASettingsScreen extends StatefulWidget {
  final UserRole userRole;
  final int userId;

  const TwoFASettingsScreen(
      {super.key, required this.userRole, required this.userId});

  @override
  TwoFASettingsScreenState createState() => TwoFASettingsScreenState();
}

class TwoFASettingsScreenState extends State<TwoFASettingsScreen> {
  bool twoFaOn = true;

  @override
  void initState() {
    super.initState();
    getProfileDetails(widget.userId, widget.userRole).then((profile) {
      setState(() {
        twoFaOn = profile.twoFactorAuthEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Two-Factor Authentication",
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
                      padding: const EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Enable 2FA",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Switch(
                                      value: twoFaOn,
                                      activeColor: AppColours.darkBlue,
                                      onChanged: (bool value) async {
                                        await updateTwoFactor(widget.userId,
                                            widget.userRole, value);
                                        setState(() {
                                          twoFaOn = value;
                                        });
                                      },
                                    )
                                  ],
                                )),
                            const SizedBox(height: 10),
                            greyDividerThick(),
                            const SizedBox(height: 20),
                            const Text(
                                "Two-factor authentication keeps your account safe by asking you to enter a verification code sent to your phone every time you log in.",
                                style: TextStyle(fontSize: 15)),
                          ]))))),
      bottomNavigationBar: roleBasedBottomNavBar(widget.userRole, context, 4),
    );
  }
}
