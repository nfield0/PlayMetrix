import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/api_clients/coach_api_client.dart';
import 'package:play_metrix/api_clients/manager_api_client.dart';
import 'package:play_metrix/api_clients/physio_api_client.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/authentication_data_model.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/data_models/profile_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/push_notification_manager.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'dart:convert';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:play_metrix/keys.dart';

class LogInScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final TwilioService twilioService = TwilioService(
    twilioFlutter: TwilioFlutter(
      accountSid: accountSid,
      authToken: authToken,
      twilioNumber: twilioNumber,
    ),
  );

  LogInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool passwordIsObscure = ref.watch(passwordVisibilityNotifier);

    return Scaffold(
        appBar: AppBar(
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
            child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Form(
              key: _formKey,
              autovalidateMode:
                  AutovalidateMode.always, // Enable auto validation
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Log In',
                        style: TextStyle(
                          color: AppColours.darkBlue,
                          fontFamily: AppFonts.gabarito,
                          fontSize: 36.0,
                          fontWeight: FontWeight.w700,
                        )),
                    const Divider(
                      color: AppColours.darkBlue,
                      thickness: 1.0, // Set the thickness of the line
                      height: 40.0, // Set the height of the line
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: AppColours.darkBlue,
                        decoration: const InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColours.darkBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColours.darkBlue),
                          ),
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.openSans),
                        ),
                        validator: (String? value) {
                          return (value != null && !_emailRegex.hasMatch(value))
                              ? 'Invalid email format.'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: passwordIsObscure,
                        cursorColor: AppColours.darkBlue,
                        decoration: InputDecoration(
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColours.darkBlue), // Set border color
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColours
                                    .darkBlue), // Set focused border color
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordIsObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColours.darkBlue,
                            ),
                            onPressed: () {
                              // Toggle the visibility of the password
                              ref
                                  .read(passwordVisibilityNotifier.notifier)
                                  .state = !passwordIsObscure;
                            },
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.openSans),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: bigButton("Log in", () async {
                          if (_formKey.currentState!.validate()) {
                            String response = await loginUser(
                                context,
                                _emailController.text,
                                _passwordController.text,
                                _formKey.toString());

                            if (response != "") {
                              if (const JsonDecoder()
                                      .convert(response)['user_password'] !=
                                  false) {
                                int userId = const JsonDecoder()
                                    .convert(response)['user_id'];
                                ref.read(userIdProvider.notifier).state =
                                    userId;

                                UserRole userRole = stringToUserRole(
                                    const JsonDecoder()
                                        .convert(response)['user_type']);

                                if (userRole == UserRole.manager) {
                                  Profile managerProfile =
                                      await getManagerProfile(userId);
                                  String formattedPhoneNumber =
                                      getPhoneNumberPrefix(
                                          managerProfile.contactNumber);
                                  String verificationCode =
                                      generateRandomCode();
                                  ref
                                      .read(verificationCodeProvider.notifier)
                                      .state = verificationCode;
                                  bool sentSuccessfully =
                                      await twilioService.sendVerificationCode(
                                          formattedPhoneNumber,
                                          verificationCode);

                                  if (!sentSuccessfully) {
                                    print("SMS not sent");
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return twoFactorAuthPopUp(
                                          context,
                                          formattedPhoneNumber,
                                          ref,
                                          userRole,
                                          userId,
                                          verificationCode);
                                    },
                                  );
                                } else if (userRole == UserRole.physio) {
                                  Profile physioProfile =
                                      await getPhysioProfile(userId);
                                  String formattedPhoneNumber =
                                      getPhoneNumberPrefix(
                                          physioProfile.contactNumber);
                                  String verificationCode =
                                      generateRandomCode();
                                  ref
                                      .read(verificationCodeProvider.notifier)
                                      .state = verificationCode;
                                  bool sentSuccessfully =
                                      await twilioService.sendVerificationCode(
                                          formattedPhoneNumber,
                                          verificationCode);

                                  if (!sentSuccessfully) {
                                    print("SMS not sent");
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return twoFactorAuthPopUp(
                                          context,
                                          formattedPhoneNumber,
                                          ref,
                                          userRole,
                                          userId,
                                          verificationCode);
                                    },
                                  );
                                } else if (userRole == UserRole.player) {
                                  PlayerData playerProfile =
                                      await getPlayerById(userId);
                                  String formattedPhoneNumber =
                                      getPhoneNumberPrefix(
                                          playerProfile.player_contact_number);
                                  String verificationCode =
                                      generateRandomCode();
                                  ref
                                      .read(verificationCodeProvider.notifier)
                                      .state = verificationCode;
                                  bool sentSuccessfully =
                                      await twilioService.sendVerificationCode(
                                          formattedPhoneNumber,
                                          verificationCode);

                                  if (!sentSuccessfully) {
                                    print("SMS not sent");
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return twoFactorAuthPopUp(
                                          context,
                                          formattedPhoneNumber,
                                          ref,
                                          userRole,
                                          userId,
                                          verificationCode);
                                    },
                                  );
                                } else {
                                  Profile coachProfile =
                                      await getCoachProfile(userId);
                                  String formattedPhoneNumber =
                                      getPhoneNumberPrefix(
                                          coachProfile.contactNumber);
                                  String verificationCode =
                                      generateRandomCode();
                                  ref
                                      .read(verificationCodeProvider.notifier)
                                      .state = verificationCode;
                                  bool sentSuccessfully =
                                      await twilioService.sendVerificationCode(
                                          formattedPhoneNumber,
                                          verificationCode);

                                  if (!sentSuccessfully) {
                                    print("SMS not sent");
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return twoFactorAuthPopUp(
                                          context,
                                          formattedPhoneNumber,
                                          ref,
                                          userRole,
                                          userId,
                                          verificationCode);
                                    },
                                  );
                                }
                              }
                            }
                          }
                        }))
                  ],
                ),
              ),
            ),
          ),
        )));
  }

  Widget twoFactorAuthPopUp(BuildContext context, String phoneNumber,
      WidgetRef ref, UserRole userRole, int userId, String verificationCode) {
    final TextEditingController verificationCodeController =
        TextEditingController();
    final verificationCodeRegex = RegExp(r'^\d{6}$');
    return AlertDialog(
        title: const Text('SMS 2FA Verification',
            style: TextStyle(
              color: AppColours.darkBlue,
              fontFamily: AppFonts.gabarito,
              fontSize: 36.0,
              fontWeight: FontWeight.w700,
            )),
        content: SizedBox(
            width: 800,
            height: 300,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: AppColours.darkBlue,
                    thickness: 1.0,
                    height: 25.0,
                  ),
                  const SizedBox(height: 10),
                  Text("A verification code has been sent to $phoneNumber",
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.openSans,
                        fontSize: 18.0,
                      )),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: verificationCodeController,
                      cursorColor: AppColours.darkBlue,
                      decoration: const InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColours.darkBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColours.darkBlue),
                        ),
                        labelText: 'Verification Code',
                        labelStyle: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.openSans),
                      ),
                      validator: (String? value) {
                        return (value != null &&
                                !verificationCodeRegex.hasMatch(value))
                            ? 'Incorrect Verification Code.'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: bigButton("Verify", () async {
                        String code = verificationCodeController.text;
                        if (code == verificationCode) {
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
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                          _emailController.clear();
                          _passwordController.clear();
                          ref.read(passwordVisibilityNotifier.notifier).state =
                              true;
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Wrong verification code',
                                    style: TextStyle(
                                        color: AppColours.darkBlue,
                                        fontFamily: AppFonts.gabarito,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                content: const Text(
                                  'Oops! It seems like the verification code you entered is incorrect. Please double-check the code and try again.',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      })),
                ],
              )
            ])));
  }
}
