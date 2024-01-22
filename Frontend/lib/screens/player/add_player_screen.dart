import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerPLayer({
  required String userType,
  required String firstName,
  required String surname,
  required String email,
  required String password,
}) async {
  final apiUrl = 'http://127.0.0.1:8000/register/'; // Replace with your actual backend URL

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_type': userType,
        'first_name': firstName,
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


class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({Key? key}) : super(key: key);

  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = "player";
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Players"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
            padding: EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Add Player to Team',
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  )),
              Divider(
                color: AppColours.darkBlue,
                thickness: 1.0,
                height: 40.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter registered player email:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
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
                          return (value != null &&
                                  !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value))
                              ? 'Invalid email format.'
                              : null;
                        },
                      ),
                      const SizedBox(height: 40),
                      bigButton("Add Player", () {
                        registerPLayer(
                            userType: _formKey,
                            firstName: _firstNameController.text,
                            surname: _surnameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                      })
                    ]),
              )
            ])),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
