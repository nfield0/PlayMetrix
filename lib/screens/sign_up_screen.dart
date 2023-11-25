import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/sign_up_choose_type_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordIsObscure = true;
  bool _confirmPasswordIsObscure = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  final _nameRegex = RegExp(r'^[A-Za-z]+$');

  @override
  Widget build(BuildContext context) {
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
      body: Form(
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
                          color:
                              AppColours.darkBlue), // Set focused border color
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
                          color:
                              AppColours.darkBlue), // Set focused border color
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
                  obscureText: _passwordIsObscure,
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
                          color:
                              AppColours.darkBlue), // Set focused border color
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordIsObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColours.darkBlue,
                      ),
                      onPressed: () {
                        // Toggle the visibility of the password
                        setState(() {
                          _passwordIsObscure = !_passwordIsObscure;
                        });
                      },
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                        color: AppColours.darkBlue,
                        fontFamily: AppFonts.openSans),
                  ),
                  validator: (String? value) {
                    return (value != null && !_passwordRegex.hasMatch(value))
                        ? 'Password must contain at least 8 characters,\na number, and a symbol.'
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextFormField(
                  // controller: _passwordController,
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
                          color: AppColours.darkBlue), // Set border color
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              AppColours.darkBlue), // Set focused border color
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
                    labelText: 'Confirm password',
                    labelStyle: const TextStyle(
                        color: AppColours.darkBlue,
                        fontFamily: AppFonts.openSans),
                  ),
                  validator: (String? value) {
                    return (value != null && _passwordController.text != value)
                        ? 'Password does not match.'
                        : null;
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: bigButton(
                    "Continue",
                    () {
                      // sign up functionality
                      if (_formKey.currentState!.validate()) {
                        // Only execute if all fields are valid
                        print("first name:" + _firstNameController.text);
                        print("surname:" + _surnameController.text);
                        print("email:" + _emailController.text);
                        print("password: " + _passwordController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SignUpChooseTypeScreen()),
                        );
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
