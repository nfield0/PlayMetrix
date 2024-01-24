import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddPhysioScreen extends StatefulWidget {
  const AddPhysioScreen({Key? key}) : super(key: key);

  @override
  _AddPhysioScreenState createState() => _AddPhysioScreenState();
}

class _AddPhysioScreenState extends State<AddPhysioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Team Profile"),
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
              Text('Add Physio to Team',
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
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter registered physio email:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
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
                          return (value != null &&
                                  !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value))
                              ? 'Invalid email format.'
                              : null;
                        },
                      ),
                      const SizedBox(height: 40),
                      bigButton("Add Physio", () {
                        if (_formKey.currentState!.validate()) {}
                      })
                    ]),
              )
            ])),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
