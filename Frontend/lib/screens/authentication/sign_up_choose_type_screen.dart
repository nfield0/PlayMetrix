import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sign_up_screen.dart';

String firstName2 = firstName;
String surname2 = surname;
String email2 = email;
String password2 = password;


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

Future<void> registerUser({
  required String UserType,
  required String firstName,
  required String surname,
  required String email,
  required String password,
})
async {
if (UserType == "manager")
{
  final apiUrl =
      'http://127.0.0.1:8000/register_manager'; // Replace with your actual backend URL

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
      print('Response: ${response.body}');
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
if(UserType == "player")
{
  final apiUrl =
      'http://127.0.0.1:8000/register_player'; // Replace with your actual backend URL

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
        'player_dob': "",
        'player_height': "",
        'player_gender': "",
        'player_contact_number': "",
        'player_image': "",
      }),
    );

    if (response.statusCode == 200) {
      // Successfully registered, handle the response accordingly
      print('Registration successful!');
      print('Response: ${response.body}');
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

if(UserType == "coach")
{
  final apiUrl =
      'http://127.0.0.1:8000/register_coach'; // Replace with your actual backend URL

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
        'physio_contact_number': "",
      }),
    );

    if (response.statusCode == 200) {
      // Successfully registered, handle the response accordingly
      print('Registration successful!');
      print('Response: ${response.body}');
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

if (UserType == "physio")
{
  final apiUrl =
      'http://127.0.0.1:8000/register_coach'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'physio_email': firstName,
        'surname': surname,
        'user_email': email,
        'user_password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully registered, handle the response accordingly
      print('Registration successful!');
      print('Response: ${response.body}');
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

else{
  print("error: user type not found");
}

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
                      child: bigButton("Sign up", () {
                        print(ref.read(userRoleProvider.notifier).state);
                        String user_type = checkUserType(ref.read(userRoleProvider.notifier).state.toString());
                        print(user_type);
                        registerUser(UserType: user_type, firstName: firstName2, surname: surname2, email: email2, password: password2);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
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
