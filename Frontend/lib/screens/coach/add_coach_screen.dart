import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/api_clients/coach_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/team/team_profile_screen.dart';
import 'package:play_metrix/screens/widgets_lib/bottom_navbar.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class AddCoachScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  AddCoachScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedRole = ref.watch(teamRoleProvider);
    final navigator = Navigator.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Coach to Team',
              style: TextStyle(
                color: AppColours.darkBlue,
                fontFamily: AppFonts.gabarito,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              )),
          iconTheme: const IconThemeData(
            color: AppColours.darkBlue, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.always,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Enter registered coach email:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 25),
                                      TextFormField(
                                        cursorColor: AppColours.darkBlue,
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          focusedErrorBorder:
                                              OutlineInputBorder(
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
                                      const SizedBox(height: 20),
                                      dropdownWithDivider(
                                          "Role", selectedRole, [
                                        teamRoleToText(TeamRole.headCoach),
                                        teamRoleToText(TeamRole.defense),
                                        teamRoleToText(TeamRole.attack),
                                        teamRoleToText(TeamRole.midfield),
                                        teamRoleToText(TeamRole.goalkeeper),
                                      ], (value) {
                                        ref
                                            .read(teamRoleProvider.notifier)
                                            .state = value!;
                                      }),
                                      const SizedBox(height: 40),
                                      bigButton("Add Coach", () async {
                                        if (_formKey.currentState!.validate()) {
                                          int coachId =
                                              await findCoachIdByEmail(
                                                  _emailController.text);

                                          if (coachId != -1) {
                                            await addTeamCoach(
                                                ref
                                                    .read(
                                                        teamIdProvider.notifier)
                                                    .state,
                                                coachId,
                                                selectedRole);
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
                                                  title: Text('Coach Not Found',
                                                      style: TextStyle(
                                                          color: AppColours
                                                              .darkBlue,
                                                          fontFamily:
                                                              AppFonts.gabarito,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  content: Text(
                                                      'Sorry, coach with that email does not exist. Please enter a different email address and try again.',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                            ]))))),
        bottomNavigationBar: managerBottomNavBar(context, 2));
  }
}
