import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/authentication/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:http/http.dart' as http;

final firstNameProvider = StateProvider<String>((ref) => "");
final surnameProvider = StateProvider<String>((ref) => "");
final emailProvider = StateProvider<String>((ref) => "");
final passwordProvider = StateProvider<String>((ref) => "");

final passwordVisibilityNotifier = StateProvider<bool>((ref) => true);
final confirmPasswordVisibilityNotifier = StateProvider<bool>((ref) => true);

Future<bool> checkEmailExists(String email) async {
  final apiUrl =
      '$apiBaseUrl/check_email_exists?email=${Uri.encodeComponent(email)}';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      if (response.body == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error: $error');
  }
  throw Exception('Failed to check email');
}

class SignUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  final _nameRegex = RegExp(r'^[A-Za-z]+$');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordIsObscure = ref.watch(passwordVisibilityNotifier);
    final confirmPasswordIsObscure =
        ref.watch(confirmPasswordVisibilityNotifier);

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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always, // Enable auto validation
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sign Up',
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
                              color: AppColours.darkBlue), // Set border color
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
                        return (value != null && !_nameRegex.hasMatch(value))
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
                              color: AppColours.darkBlue), // Set border color
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
                        return (value != null && !_nameRegex.hasMatch(value))
                            ? 'Invalid surname.'
                            : null;
                      },
                    ),
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
                                .read(passwordVisibilityNotifier.notifier)
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
                              color: AppColours.darkBlue), // Set border color
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
                                .read(
                                    confirmPasswordVisibilityNotifier.notifier)
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
                  Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: bigButton(
                        "Continue",
                        () async {
                          // sign up functionality
                          if (_formKey.currentState!.validate()) {
                            if (!await checkEmailExists(
                                _emailController.text)) {
                              ref.read(firstNameProvider.notifier).state =
                                  _firstNameController.text;
                              ref.read(surnameProvider.notifier).state =
                                  _surnameController.text;
                              ref.read(emailProvider.notifier).state =
                                  _emailController.text;
                              ref.read(passwordProvider.notifier).state =
                                  _passwordController.text;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpChooseTypeScreen()),
                              );

                              ref
                                  .read(passwordVisibilityNotifier.notifier)
                                  .state = true;

                              ref
                                  .read(confirmPasswordVisibilityNotifier
                                      .notifier)
                                  .state = true;

                              _firstNameController.clear();
                              _surnameController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Email Already in Use',
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
                        },
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
