import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/keys.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/verify_phone_number_sign_up_screen.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class ContactDetailsSignUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final _phoneRegex = RegExp(r'^(?:\+\d{1,3}\s?)?\d{9,15}$');

  final TwilioService twilioService = TwilioService(
    twilioFlutter: TwilioFlutter(
      accountSid: accountSid,
      authToken: authToken,
      twilioNumber: twilioNumber,
    ),
  );

  ContactDetailsSignUpScreen({super.key});

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
                            'Step 2/5',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Your contact details',
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
                                  borderSide:
                                      BorderSide(color: AppColours.darkBlue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColours.darkBlue),
                                ),
                                labelText: 'Email address',
                                labelStyle: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        !_emailRegex.hasMatch(value))
                                    ? 'Invalid email format.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              controller: _phoneController,
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
                                labelText: 'Phone number',
                                labelStyle: TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        !_phoneRegex.hasMatch(value))
                                    ? 'Invalid phone number.'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: bigButton("Next", () async {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(emailProvider.notifier).state =
                                      _emailController.text;
                                  ref.read(phoneProvider.notifier).state =
                                      _phoneController.text;

                                  if (!await checkEmailExists(
                                      _emailController.text)) {
                                    String formattedPhoneNumber =
                                        getPhoneNumberPrefix(
                                            _phoneController.text);
                                    String verificationCode =
                                        generateRandomCode();
                                    ref
                                        .read(verificationCodeProvider.notifier)
                                        .state = verificationCode;
                                    bool sentSuccessfully = await twilioService
                                        .sendVerificationCode(
                                            formattedPhoneNumber,
                                            verificationCode);

                                    if (!sentSuccessfully) {
                                      print("SMS not sent");
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyPhoneNumberSignUpScreen(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Email Already in Use',
                                              style: TextStyle(
                                                  color: AppColours.darkBlue,
                                                  fontFamily: AppFonts.gabarito,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                          content: const Text(
                                            'Sorry, an account with this email already exists. Please use a different email address and try again.',
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
                                  }
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
