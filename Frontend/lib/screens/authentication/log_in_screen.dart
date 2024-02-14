import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';
import 'dart:math';
import 'package:play_metrix/keys.dart';

Future<String> loginUser(BuildContext context, String email, String password,
    String userType) async {
  const apiUrl = '$apiBaseUrl/login';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_email': email,
        'user_password': password,
        'user_type': userType,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      // Successfully logged in, handle the response accordingly
      if (response.body.toLowerCase().contains("error")) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Error',
                  style: TextStyle(
                      color: AppColours.darkBlue,
                      fontFamily: AppFonts.gabarito,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              content: const Text(
                "User with that email doesn't exist.",
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
      } else {
        if (!jsonDecode(response.body)['user_password']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Error',
                    style: TextStyle(
                        color: AppColours.darkBlue,
                        fontFamily: AppFonts.gabarito,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                content: const Text(
                  'Wrong password. Please try again.',
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
          return "";
        }

        return response.body;
      }
    } else {
      // Failed to log in, handle the error accordingly
      print('Failed to log in. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  return "";
}

Future<int> getTeamByManagerId(int managerId) async {
  final teams = await getAllTeams();

  try {
    for (TeamData team in teams) {
      if (team.manager_id == managerId) {
        return team.team_id;
      }
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<int> getTeamByCoachId(int coachId) async {
  final apiUrl = '$apiBaseUrl/coaches_team/$coachId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return data[0]['team_id'];
      } else {
        return -1;
      }
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<int> getTeamByPhysioId(int physioId) async {
  final apiUrl = '$apiBaseUrl/physios_team/$physioId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return data[0]['team_id'];
      } else {
        return -1;
      }
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

Future<int> getTeamByPlayerId(int playerId) async {
  final apiUrl = '$apiBaseUrl/players_team/$playerId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully retrieved data
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        return data[0]['team_id'];
      } else {
        return -1;
      }
    } else {
      // Failed to retrieve data, handle the error accordingly
      print('Failed to retrieve data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw (Exception("Team not found."));
}

class TwilioService {
  final TwilioFlutter twilioFlutter;

  TwilioService({required this.twilioFlutter});

  Future<bool> sendVerificationCode(String to, String code) async {
    try {
      await twilioFlutter.sendSMS(
        toNumber: to,
        messageBody: 'Hey there! Your PlayMetrix verification code is: $code',
      );

      return true;
    } catch (e) {
      print('Error sending verification code: $e');
      return false;
    }
  }
}

String generateRandomCode() {
  final random = Random();
  // Generate a random 6-digit code
  return (100000 + random.nextInt(900000)).toString();
}

String getPhoneNumberPrefix(String phoneNumber) {
  List<String> irishMobilePrefixes = ['083', '085', '086', '087', '089'];

  List<String> ukMobilePrefixes = [
    '07402',
    '07403',
    '07404',
    '07405',
    '07406',
    '07407',
    '07408',
    '07409',
    '07520',
    '07521',
    '07522',
    '07523',
    '07524',
    '07525',
    '07526',
    '07527',
    '07528',
    '07529',
    '07770',
    '07771',
    '07772',
    '07773',
    '07774',
    '07775',
    '07776',
    '07777',
    '07778',
    '07779',
    '07850',
    '07851',
    '07852',
    '07853',
    '07854',
    '07855',
    '07856',
    '07857',
    '07858',
    '07859',
    '07724',
    '07781',
    '07782',
    '07783',
    '07784',
    '07785',
    '07786',
    '07787',
    '07788',
    '07789',
    '07824',
    '07825',
    '07826',
    '07827',
    '07828',
    '07829',
    '07730',
    '07731',
    '07732',
    '07733',
    '07734',
    '07735',
    '07736',
    '07737',
    '07738',
    '07739',
    '07911',
    '07912',
    '07913',
    '07914',
    '07915',
    '07916',
    '07917',
    '07918',
    '07919',
    '07400',
    '07401',
    '07402',
    '07403',
    '07404',
    '07405',
    '07406',
    '07407',
    '07408',
    '07409',
  ];
  //phoneNumber = phoneNumber.replaceAll(RegExp('^0+'), '');
  String prefix = phoneNumber.substring(0, 3);
  String prefixUk = phoneNumber.substring(0, 5);

  if (irishMobilePrefixes.contains(prefix)) {
    String formattedPhoneNumberForIreland = '+353' + phoneNumber.substring(1);
    return formattedPhoneNumberForIreland;
  } else if (ukMobilePrefixes.contains(prefixUk)) {
    String formattedPhoneNumberForEngland = '+44' + phoneNumber.substring(1);
    print(formattedPhoneNumberForEngland);
    return formattedPhoneNumberForEngland;
  } else {
    return '';
  }
}

final userIdProvider = StateProvider<int>((ref) => 0);
final passwordVisibilityNotifier = StateProvider<bool>((ref) => true);

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
    TextEditingController _codeReceivedController = TextEditingController();
    bool _showPhoneNumberInput = true;
    bool _showCodeSentInput = false;
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
              _showPhoneNumberInput
                  ? Column(
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
                                borderSide:
                                    BorderSide(color: AppColours.darkBlue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColours.darkBlue),
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
                            child:
                                bigButton("Send Verification Code", () async {
                              String phoneNumber = _phoneNumberController.text;
                              String formattedPhoneNumber =
                                  getPhoneNumberPrefix(phoneNumber);
                              bool sentSuccessfully =
                                  await twilioService.sendVerificationCode(
                                      formattedPhoneNumber, verificationCode);
                              if (sentSuccessfully) {
                                _showPhoneNumberInput = false;
                                _showCodeSentInput = true;
                              } else {
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
                                borderSide:
                                    BorderSide(color: AppColours.darkBlue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColours.darkBlue),
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
                                _showPhoneNumberInput = false;
                                _showCodeSentInput = true;
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
                  : _showCodeSentInput
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _codeReceivedController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Verification Code (Received)'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Verify the entered verification code (received)
                                // Implement verification logic for the code received
                                // For simplicity, let's assume the code is correct
                                // TODO: Implement Twilio API call to verify the verification code

                                // Assuming the code is correct, close the dialog
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Verify Code (Received)'),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _verificationCodeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Verification Code (Sent)'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Verify the entered verification code (sent)
                                // Implement verification logic for the code sent
                                // For simplicity, let's assume the code is correct
                                // TODO: Implement Twilio API call to verify the verification code

                                // Assuming the code is correct, close the dialog
                                Navigator.of(context).pop();
                              },
                              child: const Text('Verify Code (Sent)'),
                            ),
                          ],
                        ),
            ])));
  }
}
