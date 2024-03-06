import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/password_sign_up_screen.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';

class VerifyPhoneNumberSignUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final _verificationCodeRegex = RegExp(r'^\d{6}$');

  VerifyPhoneNumberSignUpScreen({super.key});

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
              child: Center(
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
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 650),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Step 3/5',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 40),
                                  const Text(
                                    'Verify your phone number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColours.darkBlue,
                                      fontFamily: AppFonts.gabarito,
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Text(
                                        "A verification code has been sent to ${ref.read(phoneProvider)}.",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  const SizedBox(height: 15),
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
                                          borderSide: BorderSide(
                                              color: AppColours.darkBlue),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColours.darkBlue),
                                        ),
                                        labelText: 'Enter code here',
                                        labelStyle: TextStyle(
                                            color: AppColours.darkBlue,
                                            fontFamily: AppFonts.openSans),
                                      ),
                                      validator: (String? value) {
                                        return (value != null &&
                                                !_verificationCodeRegex
                                                    .hasMatch(value))
                                            ? 'Invalid verification code.'
                                            : null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: bigButton("Next", () {
                                        if (_formKey.currentState!.validate()) {
                                          if (_verificationCodeController
                                                  .text ==
                                              ref.read(
                                                  verificationCodeProvider)) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PasswordSignUpScreen(),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Wrong verification code',
                                                      style: TextStyle(
                                                          color: AppColours
                                                              .darkBlue,
                                                          fontFamily:
                                                              AppFonts.gabarito,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  content: const Text(
                                                    'Oops! It seems like the verification code you entered is incorrect. Please double-check the code and try again.',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      })),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))))
        ],
      ),
    );
  }
}
