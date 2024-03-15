import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/screens/settings/settings_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  final UserRole userRole;
  final int userId;
  const ChangePasswordScreen(
      {super.key, required this.userRole, required this.userId});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _oldPasswordIsObscure = true;
  bool _newPasswordIsObscure = true;
  bool _confirmPasswordIsObscure = true;

  final _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Change Password",
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
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          sectionHeader("Current Password"),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: TextFormField(
                              controller: _oldPasswordController,
                              obscureText: _oldPasswordIsObscure,
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
                                      color: AppColours
                                          .darkBlue), // Set border color
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set focused border color
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _oldPasswordIsObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColours.darkBlue,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    setState(() {
                                      _oldPasswordIsObscure =
                                          !_oldPasswordIsObscure;
                                    });
                                  },
                                ),
                                labelText: 'Enter your current password',
                                labelStyle: const TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        !_passwordRegex.hasMatch(value))
                                    ? 'Password must contain at least 8 characters,\na number, and a symbol.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: greyDividerThick(),
                          ),
                          sectionHeader("New Password"),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: TextFormField(
                              controller: _newPasswordController,
                              obscureText: _newPasswordIsObscure,
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
                                      color: AppColours
                                          .darkBlue), // Set border color
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set focused border color
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _newPasswordIsObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColours.darkBlue,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    setState(() {
                                      _newPasswordIsObscure =
                                          !_newPasswordIsObscure;
                                    });
                                  },
                                ),
                                labelText: 'Enter your new password',
                                labelStyle: const TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        !_passwordRegex.hasMatch(value))
                                    ? 'Password must contain at least 8 characters,\na number, and a symbol.'
                                    : null;
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _confirmPasswordIsObscure,
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
                                      color: AppColours
                                          .darkBlue), // Set border color
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set focused border color
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _confirmPasswordIsObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColours.darkBlue,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    setState(() {
                                      _confirmPasswordIsObscure =
                                          !_confirmPasswordIsObscure;
                                    });
                                  },
                                ),
                                labelText: 'Confirm new password',
                                labelStyle: const TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        _newPasswordController.text != value)
                                    ? 'Password does not match.'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: bigButton("Change Password", () {
                                if (_formKey.currentState!.validate()) {
                                  

                                  _oldPasswordController.clear();
                                  _newPasswordController.clear();
                                  _confirmPasswordController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Password changed successfully')));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SettingsScreen()));
                                }
                              }))
                        ],
                      ),
                    )))),
        bottomNavigationBar:
            roleBasedBottomNavBar(widget.userRole, context, 4));
  }
}
