import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class EditProfileScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final phoneRegex = RegExp(r'^(?:\+\d{1,3}\s?)?\d{9,15}$');
  final nameRegex = RegExp(r'^[A-Za-z]+$');
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider.notifier).state;

    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("My Profile"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(35),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Edit Profile',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: AppFonts.gabarito,
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 10),
                      divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                  child: Column(children: [
                                Image.asset(
                                  "lib/assets/icons/profile_placeholder.png",
                                  width: 120,
                                ),
                                const SizedBox(height: 10),
                                underlineButtonTransparent(
                                    "Edit picture", () {}),
                              ])),
                              formFieldBottomBorderController(
                                  "First name", firstNameController,
                                  (String? value) {
                                return (value != null &&
                                        !nameRegex.hasMatch(value))
                                    ? 'Invalid first name.'
                                    : null;
                              }),
                              formFieldBottomBorderController(
                                  "Surname", surnameController,
                                  (String? value) {
                                return (value != null &&
                                        !nameRegex.hasMatch(value))
                                    ? 'Invalid surname.'
                                    : null;
                              }),
                              formFieldBottomBorderController(
                                  "Email", emailController, (String? value) {
                                return (value != null &&
                                        !emailRegex.hasMatch(value))
                                    ? 'Invalid email.'
                                    : null;
                              }),
                              formFieldBottomBorderController(
                                  "Phone", phoneController, (String? value) {
                                return (value != null &&
                                        !phoneRegex.hasMatch(value))
                                    ? 'Invalid phone number.'
                                    : null;
                              }),
                              const SizedBox(height: 30),
                              bigButton("Save Changes", () {
                                if (_formKey.currentState!.validate()) {}
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: roleBasedBottomNavBar(userRole, context, 3));
  }
}
