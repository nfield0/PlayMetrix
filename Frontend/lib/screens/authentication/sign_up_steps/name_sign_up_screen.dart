import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/contact_details_sign_up_screen.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';

class NameSignUpScreen extends ConsumerWidget {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final _nameRegex = RegExp(r'^[A-Za-z]+$');

  NameSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
          'lib/assets/logo_white.png',
          width: 150,
          fit: BoxFit.contain,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/signup_page_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 50),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Step 1/5',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'First of all, enter your name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: AppFonts.gabarito,
                              fontSize: 36.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              controller: _firstNameController,
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
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set focused border color
                                ),
                                labelText: 'First name',
                                labelStyle: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        !_nameRegex.hasMatch(value))
                                    ? 'Invalid first name.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              controller: _surnameController,
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
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColours
                                          .darkBlue), // Set focused border color
                                ),
                                labelText: 'Surname',
                                labelStyle: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        !_nameRegex.hasMatch(value))
                                    ? 'Invalid surname.'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: bigButton("Next", () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(firstNameProvider.notifier).state =
                                      _firstNameController.text;
                                  ref.read(surnameProvider.notifier).state =
                                      _surnameController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ContactDetailsSignUpScreen(),
                                    ),
                                  );
                                }
                              })),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
