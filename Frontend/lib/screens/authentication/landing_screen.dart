import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/data_models/authentication_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/push_notification_manager.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/name_sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:play_metrix/keys.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/landing_page_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                width: 350,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 320,
                    maxWidth:
                        MediaQuery.of(context).size.width <= 500 ? 350 : 500,
                    minHeight: 68,
                    maxHeight: 68),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NameSignUpScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: AppColours.darkBlue,
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.openSans,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "or",
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.openSans,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 320,
                    maxWidth:
                        MediaQuery.of(context).size.width <= 500 ? 350 : 500,
                    minHeight: 68,
                    maxHeight: 68),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: Colors.white,
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log in with email',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 320,
                      maxWidth:
                          MediaQuery.of(context).size.width <= 500 ? 350 : 500,
                      minHeight: 68,
                      maxHeight: 68),
                  child: CupertinoButton(
                    onPressed: () async {
                      final GoogleSignIn googleSignIn = GoogleSignIn(
                        clientId: CLIENT_ID,
                      );

                      final googleUser = await googleSignIn.signIn();
                      if (googleUser != null) {
                        print(googleUser);
                        ref.read(userIdProvider.notifier).state = 0;


                        getDetailsByEmail(googleUser.email)
                            .then((response) async {
                              print(response);
                              if (response.toString() != "Error retrieving user") {
                                int userId = const JsonDecoder().convert(response)['user_id'];
                                ref.read(userIdProvider.notifier).state = userId;

                                UserRole userRole = stringToUserRole(
                                    const JsonDecoder()
                                        .convert(response)['user_type']);

                                if (userRole == UserRole.manager) {
                                  logInFunctionality(context, ref, userRole, userId);
                                } else if (userRole == UserRole.physio) {
                                  logInFunctionality(context, ref, userRole, userId);
                                } else if (userRole == UserRole.player) {
                                  logInFunctionality(context, ref, userRole, userId);
                                } else {
                                  
                                   logInFunctionality(context, ref, userRole, userId);
                                }
                                    }
                                    else {
                                      
                                  showGoogleFail(context, ref);

                                    }
                              });
                            }
                            else {
                       
                            
                            showGoogleFail(context, ref);

  
                        print('Google Sign In Failed');
                      }
                    },
                    borderRadius: BorderRadius.circular(25),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/assets/icons/google_icon.png',
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Log in with Google',
                            style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }



  void logInFunctionality(BuildContext context, WidgetRef ref,
      UserRole userRole, int userId) async {
    ref.read(userRoleProvider.notifier).state = userRole;

    await AuthStorage.saveLoginStatus(true);
    await AuthStorage.saveUserId(userId);
    await AuthStorage.saveUserRole(userRole);

    if (userRole == UserRole.manager) {
      int teamId = await getTeamByManagerId(userId);
      ref.read(teamIdProvider.notifier).state = teamId;
      await AuthStorage.saveTeamId(teamId);
      scheduleNotificationsForTeamSchedules(teamId);
    } else if (userRole == UserRole.coach) {
      int teamId = await getTeamByCoachId(userId);
      ref.read(teamIdProvider.notifier).state = teamId;
      await AuthStorage.saveTeamId(teamId);

      scheduleNotificationsForTeamSchedules(teamId);
    } else if (userRole == UserRole.physio) {
      int teamId = await getTeamByPhysioId(userId);
      ref.read(teamIdProvider.notifier).state = teamId;
      await AuthStorage.saveTeamId(teamId);
      scheduleNotificationsForTeamSchedules(teamId);
    } else if (userRole == UserRole.player) {
      int teamId = await getTeamByPlayerId(userId);
      ref.read(teamIdProvider.notifier).state = teamId;
      scheduleNotificationsForTeamSchedules(teamId);
      await AuthStorage.saveTeamId(teamId);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
  Widget googleLogInFail(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Google Sign In Failed'),
      content: const Text(
          'Google Sign In Failed. Please register with your Google email first.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
    void showGoogleFail(BuildContext context, WidgetRef ref) {
   
    print("Google Sign In Failed");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return googleLogInFail(context, ref);
      },
    );
  }
}
