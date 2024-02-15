import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/physio_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class AddPhysioScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  AddPhysioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);

    return Scaffold(
        appBar: AppBar(
          title: appBarTitlePreviousPage("Team Profile"),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                          !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                              .hasMatch(value))
                                      ? 'Invalid email format.'
                                      : null;
                                },
                              ),
                              const SizedBox(height: 40),
                              bigButton("Add Physio", () async {
                                if (_formKey.currentState!.validate()) {
                                  int physioId = await findPhysioIdByEmail(
                                      _emailController.text);

                                  if (physioId != -1) {
                                    await addTeamPhysio(
                                        ref.read(teamIdProvider), physioId);
                                    navigator.push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeamProfileScreen()),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Physio Not Found',
                                              style: TextStyle(
                                                  color: AppColours.darkBlue,
                                                  fontFamily: AppFonts.gabarito,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                          content: Text(
                                              'Sorry, physio with that email does not exist. Please enter a different email address and try again.',
                                              style: TextStyle(fontSize: 16)),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              })
                            ]),
                      )
                    ]))),
        bottomNavigationBar: managerBottomNavBar(context, 1));
  }
}
