import 'package:flutter/cupertino.dart';
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

Future<String> loginUser(BuildContext context, String email, String password,
    String userType) async {
  final apiUrl = '$apiBaseUrl/login';

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
              title: Text('Login Error',
                  style: TextStyle(
                      color: AppColours.darkBlue,
                      fontFamily: AppFonts.gabarito,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              content: Text(
                "User with that email doesn't exist.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
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
                title: Text('Login Error',
                    style: TextStyle(
                        color: AppColours.darkBlue,
                        fontFamily: AppFonts.gabarito,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                content: Text(
                  'Wrong password. Please try again.',
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
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

final userIdProvider = StateProvider<int>((ref) => 0);
final passwordVisibilityNotifier = StateProvider<bool>((ref) => true);

class LogInScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

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
}
