import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/screens/authentication/sign_up_screen.dart';
import 'package:play_metrix/screens/player/player_profile_set_up_screen.dart';
import 'package:play_metrix/screens/profile/profile_set_up.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// create a fucntion to check the user type and then send the data to the backend
String checkUserType(String userType) {
  String type = "";
  if (userType == "UserRole.manager") {
    type = "manager";
    return type;
  } else if (userType == "UserRole.player") {
    type = "player";
    return type;
  } else if (userType == "UserRole.coach") {
    type = "coach";
    return type;
  } else if (userType == "UserRole.physio") {
    type = "physio";
    return type;
  } else {
    return "error";
  }
}

Future<String> registerUser({
  required String userType,
  required String firstName,
  required String surname,
  required String email,
  required String password,
}) async {
  if (userType == "manager") {
    const apiUrl =
        '$apiBaseUrl/register_manager'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'manager_firstname': firstName,
          'manager_surname': surname,
          'manager_email': email,
          'manager_password': password,
          'manager_contact_number': "",
          'manager_image': "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');

        return response.body;
      } else {
        // Failed to register, handle the error accordingly
        print('Failed to register. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error: $error');
    }
  }
  if (userType == "player") {
    const apiUrl =
        '$apiBaseUrl/register_player'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'player_email': email,
          'player_password': password,
          'player_firstname': firstName,
          'player_surname': surname,
          'player_dob': DateTime.now().toString(),
          'player_height': "",
          'player_gender': "",
          'player_contact_number': "",
          'player_image': "",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        return response.body;
        // You can parse the response JSON here and perform actions based on it
      } else {
        // Failed to register, handle the error accordingly
        print('Failed to register. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error: $error');
    }
  }

  if (userType == "coach") {
    const apiUrl =
        '$apiBaseUrl/register_coach'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'coach_email': email,
          'coach_password': password,
          'coach_firstname': firstName,
          'coach_surname': surname,
          'coach_contact': "",
          'coach_image': ""
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        return response.body;
        // You can parse the response JSON here and perform actions based on it
      } else {
        // Failed to register, handle the error accordingly
        print('Failed to register. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error: $error');
    }
  }

  if (userType == "physio") {
    const apiUrl =
        '$apiBaseUrl/register_physio'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'physio_email': email,
          'physio_password': password,
          'physio_firstname': firstName,
          'physio_surname': surname,
          'physio_contact_number': '',
          'physio_image': '',
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered, handle the response accordingly
        print('Registration successful!');
        return response.body;
        // You can parse the response JSON here and perform actions based on it
      } else {
        // Failed to register, handle the error accordingly
        print('Failed to register. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error: $error');
    }
  } else {
    print("error: user type not found");
  }

  return "";
}

enum UserRole {
  manager,
  coach,
  player,
  physio,
}

final userRoleProvider = StateProvider<UserRole>((ref) => UserRole.manager);

String userRoleText(UserRole userRole) {
  switch (userRole) {
    case UserRole.manager:
      return "Manager";
    case UserRole.player:
      return "Player";
    case UserRole.coach:
      return "Coach";
    case UserRole.physio:
      return "Physio";
  }
}

UserRole stringToUserRole(String userRole) {
  switch (userRole) {
    case "manager":
      return UserRole.manager;
    case "player":
      return UserRole.player;
    case "coach":
      return UserRole.coach;
    case "physio":
      return UserRole.physio;
    default:
      return UserRole.manager;
  }
}

class SignUpChooseTypeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/assets/logo.png',
          width: 150,
          fit: BoxFit.contain,
        ),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(
                  color: AppColours.darkBlue,
                  thickness: 1.0,
                  height: 40.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Text(
                    'Are you using this app as a...',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.openSans,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    radioUserTypeOption<UserRole>(
                      "Manager",
                      "lib/assets/icons/manager.png",
                      UserRole.manager,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    radioUserTypeOption<UserRole>(
                      "Player",
                      "lib/assets/icons/player.png",
                      UserRole.player,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    radioUserTypeOption<UserRole>(
                      "Physio",
                      "lib/assets/icons/physio.png",
                      UserRole.physio,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    radioUserTypeOption<UserRole>(
                      "Coach",
                      "lib/assets/icons/whistle.png",
                      UserRole.coach,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: bigButton("Sign up", () async {
                        UserRole userRole =
                            ref.read(userRoleProvider.notifier).state;
                        String firstName =
                            ref.read(firstNameProvider.notifier).state;
                        String surname =
                            ref.read(surnameProvider.notifier).state;
                        String email = ref.read(emailProvider.notifier).state;
                        String password =
                            ref.read(passwordProvider.notifier).state;

                        await signUpHandler(
                          userRole,
                          firstName,
                          surname,
                          email,
                          password,
                          (userId) =>
                              ref.read(userIdProvider.notifier).state = userId,
                          (userRole) => ref
                              .read(userRoleProvider.notifier)
                              .state = userRole,
                          (value) => ref
                              .read(firstNameProvider.notifier)
                              .state = value,
                          (value) =>
                              ref.read(surnameProvider.notifier).state = value,
                          (value) =>
                              ref.read(emailProvider.notifier).state = value,
                          (value) =>
                              ref.read(passwordProvider.notifier).state = value,
                          (userRole) {
                            if (userRole != UserRole.player) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileSetUpScreen()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlayerProfileSetUpScreen(),
                                ),
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget radioUserTypeOption<T>(
  String text,
  String imagePath,
  T value,
  T groupValue,
  WidgetRef ref,
) {
  void onChanged(T? newValue) {
    ref.read(userRoleProvider.notifier).state = newValue! as UserRole;
  }

  return RadioListTile<T>(
    title: Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: AppFonts.openSans,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 8.0),
        Image.asset(
          imagePath,
          width: 22.0,
          height: 22.0,
        ),
      ],
    ),
    value: value,
    activeColor: AppColours.darkBlue,
    groupValue: groupValue,
    onChanged: onChanged,
  );
}

Future<void> signUpHandler(
  UserRole userRole,
  String firstName,
  String surname,
  String email,
  String password,
  Function(int) userIdSetter,
  Function(UserRole) userRoleSetter,
  Function(String) firstNameReset,
  Function(String) surnameReset,
  Function(String) emailReset,
  Function(String) passwordReset,
  Function(dynamic) navigateToProfile,
) async {
  String response = await registerUser(
    userType: userRoleText(userRole).toLowerCase(),
    firstName: firstName,
    surname: surname,
    email: email,
    password: password,
  );

  String idType = "";
  if (userRole == UserRole.manager) {
    idType = "manager_id";
  } else if (userRole == UserRole.player) {
    idType = "player_id";
  } else if (userRole == UserRole.coach) {
    idType = "coach_id";
  } else if (userRole == UserRole.physio) {
    idType = "physio_id";
  } else {
    print("error: user type not found");
  }

  int userId = 0;
  if (userRole == UserRole.player || userRole == UserRole.physio) {
    userId = jsonDecode(response)["id"];
    print("user id: " + userId.toString());
    userIdSetter(userId);
    userRoleSetter(userRole);
  } else {
    userId = jsonDecode(response)["id"][idType];
    userIdSetter(userId);
    userRoleSetter(userRole);
  }

  if (userId != 0) {
    navigateToProfile(userRole);
  }

  firstNameReset("");
  surnameReset("");
  emailReset("");
  passwordReset("");
}
