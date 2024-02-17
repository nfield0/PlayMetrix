import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/profile_picture_sign_up_screen.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';

class PasswordSignUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  PasswordSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordIsObscure = ref.watch(passwordVisibilityNotifier);
    final confirmPasswordIsObscure =
        ref.watch(confirmPasswordVisibilityNotifier);

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
                            'Step 4/5',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Create a password',
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
                                    passwordIsObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColours.darkBlue,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    ref
                                        .read(
                                            passwordVisibilityNotifier.notifier)
                                        .state = !passwordIsObscure;
                                  },
                                ),
                                labelText: 'Password',
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
                            padding: const EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: confirmPasswordIsObscure,
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
                                    confirmPasswordIsObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColours.darkBlue,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    ref
                                        .read(confirmPasswordVisibilityNotifier
                                            .notifier)
                                        .state = !confirmPasswordIsObscure;
                                  },
                                ),
                                labelText: 'Confirm password',
                                labelStyle: const TextStyle(
                                    color: AppColours.darkBlue,
                                    fontFamily: AppFonts.openSans),
                              ),
                              validator: (String? value) {
                                return (value != null &&
                                        _passwordController.text != value)
                                    ? 'Password does not match.'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: bigButton("Next", () async {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(passwordProvider.notifier).state =
                                      _passwordController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePictureSignUpScreen(),
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
