import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/api_clients/team_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'dart:convert';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:play_metrix/keys.dart';

class LogInScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

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
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always, // Enable auto validation
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
                          color:
                              AppColours.darkBlue), // Set focused border color
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
                        ref.read(passwordVisibilityNotifier.notifier).state =
                            !passwordIsObscure;
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
                    // sign up functionality
                    if (_formKey.currentState!.validate()) {
                      // Only execute if all fields are valid
                      // NOTE UNSURE IF THIS IS THE CORRECT PLACE TO CALL THE LOGIN FUNCTION AND HOW TO GET THE USER TYPE
                      String response = await loginUser(
                          context,
                          _emailController.text,
                          _passwordController.text,
                          _formKey.toString());

                      if (response != "") {
                        if (const JsonDecoder()
                                .convert(response)['user_password'] !=
                            false) {
                          int userId =
                              const JsonDecoder().convert(response)['user_id'];
                          ref.read(userIdProvider.notifier).state = userId;

                          UserRole userRole = stringToUserRole(
                              const JsonDecoder()
                                  .convert(response)['user_type']);

                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return _2FAPopUp(context);
                          //   },
                          // );

                          ref.read(userRoleProvider.notifier).state = userRole;
                          if (userRole == UserRole.manager) {
                            int teamId = await getTeamByManagerId(userId);
                            ref.read(teamIdProvider.notifier).state = teamId;
                          } else if (userRole == UserRole.coach) {
                            int teamId = await getTeamByCoachId(userId);
                            ref.read(teamIdProvider.notifier).state = teamId;
                          } else if (userRole == UserRole.physio) {
                            int teamId = await getTeamByPhysioId(userId);
                            ref.read(teamIdProvider.notifier).state = teamId;
                          } else if (userRole == UserRole.player) {
                            int teamId = await getTeamByPlayerId(userId);
                            ref.read(teamIdProvider.notifier).state = teamId;
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
                        }
                      }
                    }
                  })),
            ],
          ),
        ),
      ),
    );
  }

  Widget _2FAPopUp(BuildContext context) {
    TextEditingController _phoneNumberController = TextEditingController();
    TextEditingController _verificationCodeController = TextEditingController();

    final phoneVerifyRegex = RegExp(r'^(?:\+\d{1,3}\s?)?\d{9,15}$');
    final verificationCodeRegex = RegExp(r'^\d{6}$');

    String verificationCode = generateRandomCode();
    TwilioService twilioService = TwilioService(
      twilioFlutter: TwilioFlutter(
        accountSid: accountSid,
        authToken: authToken,
        twilioNumber: twilioNumber,
      ),
    );

    return AlertDialog(
        title: const Text('SMS 2FA Verification',
            style: TextStyle(
              color: AppColours.darkBlue,
              fontFamily: AppFonts.gabarito,
              fontSize: 36.0,
              fontWeight: FontWeight.w700,
            )),
        content: Container(
            width: 800, // Set the desired width
            height: 500, // Set the desired width
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: AppColours.darkBlue,
                    thickness: 1.0, // Set the thickness of the line
                    height: 40.0, // Set the height of the line
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
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
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.openSans),
                      ),
                      validator: (String? value) {
                        return (value != null &&
                                !phoneVerifyRegex.hasMatch(value))
                            ? 'Invalid phone number.'
                            : null;
                      },
                    ),
                  ),
                  //const SizedBox(height: 5, width: 10),
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: bigButton("Send Verification Code", () async {
                        String phoneNumber = _phoneNumberController.text;
                        String formattedPhoneNumber =
                            getPhoneNumberPrefix(phoneNumber);
                        bool sentSuccessfully =
                            await twilioService.sendVerificationCode(
                                formattedPhoneNumber, verificationCode);
                        if (!sentSuccessfully) {
                          print('Error sending verification code');
                        }
                      })),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _verificationCodeController,
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
                  Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: bigButton("Verify", () async {
                        String code = _verificationCodeController.text;
                        if (code == verificationCode) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                          _emailController.clear();
                          _passwordController.clear();
                        } else {
                          // Handle error sending code
                          print('Error sending verification code');
                        }
                      })),
                ],
              )
            ])));
  }
}
