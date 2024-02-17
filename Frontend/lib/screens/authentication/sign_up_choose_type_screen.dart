import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/api_clients/authentication_api_client.dart';
import 'package:play_metrix/providers/sign_up_form_provider.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_set_up_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SignUpChooseTypeScreen extends ConsumerWidget {
  const SignUpChooseTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/assets/logo.png',
          width: 150,
          fit: BoxFit.contain,
        ),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AppColours.darkBlue,
                    fontFamily: AppFonts.gabarito,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(
                  color: AppColours.darkBlue,
                  thickness: 1.0,
                  height: 40.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Text(
                    'Are you using this app as a...',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.openSans,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    radioUserTypeOption<UserRole>(
                      "Manager",
                      "lib/assets/icons/manager.png",
                      UserRole.manager,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    radioUserTypeOption<UserRole>(
                      "Player",
                      "lib/assets/icons/player.png",
                      UserRole.player,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    radioUserTypeOption<UserRole>(
                      "Physio",
                      "lib/assets/icons/physio.png",
                      UserRole.physio,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    radioUserTypeOption<UserRole>(
                      "Coach",
                      "lib/assets/icons/whistle.png",
                      UserRole.coach,
                      ref.watch(userRoleProvider),
                      ref,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: bigButton("Sign up", () async {
                        UserRole userRole =
                            ref.read(userRoleProvider.notifier).state;
                        String firstName =
                            ref.read(firstNameProvider.notifier).state;
                        String surname =
                            ref.read(surnameProvider.notifier).state;
                        String email = ref.read(emailProvider.notifier).state;
                        String password =
                            ref.read(passwordProvider.notifier).state;
                        String contactNumber =
                            ref.read(phoneProvider.notifier).state;
                        Uint8List? image =
                            ref.read(profilePictureProvider.notifier).state;

                        await signUpHandler(
                          userRole,
                          firstName,
                          surname,
                          email,
                          password,
                          contactNumber,
                          image,
                          (userId) =>
                              ref.read(userIdProvider.notifier).state = userId,
                          (userRole) => ref
                              .read(userRoleProvider.notifier)
                              .state = userRole,
                          (value) => ref
                              .read(firstNameProvider.notifier)
                              .state = value,
                          (value) =>
                              ref.read(surnameProvider.notifier).state = value,
                          (value) =>
                              ref.read(emailProvider.notifier).state = value,
                          (value) =>
                              ref.read(passwordProvider.notifier).state = value,
                          (userRole) {
                            if (userRole == UserRole.player) {
                              clearSignUpForm(ref);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlayerProfileSetUpScreen(
                                          playerId: ref
                                              .read(userIdProvider.notifier)
                                              .state),
                                ),
                              );
                            } else if (userRole == UserRole.manager) {
                              clearSignUpForm(ref);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamSetUpScreen()),
                              );
                            } else {
                              clearSignUpForm(ref);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget radioUserTypeOption<T>(
  String text,
  String imagePath,
  T value,
  T groupValue,
  WidgetRef ref,
) {
  void onChanged(T? newValue) {
    ref.read(userRoleProvider.notifier).state = newValue! as UserRole;
  }

  return RadioListTile<T>(
    title: Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: AppFonts.openSans,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 8.0),
        Image.asset(
          imagePath,
          width: 22.0,
          height: 22.0,
        ),
      ],
    ),
    value: value,
    activeColor: AppColours.darkBlue,
    groupValue: groupValue,
    onChanged: onChanged,
  );
}

Future<void> signUpHandler(
  UserRole userRole,
  String firstName,
  String surname,
  String email,
  String password,
  String contactNumber,
  Uint8List? image,
  Function(int) userIdSetter,
  Function(UserRole) userRoleSetter,
  Function(String) firstNameReset,
  Function(String) surnameReset,
  Function(String) emailReset,
  Function(String) passwordReset,
  Function(dynamic) navigateToProfile,
) async {
  String response = await registerUser(
    userType: userRoleText(userRole).toLowerCase(),
    firstName: firstName,
    surname: surname,
    email: email,
    password: password,
    contactNumber: contactNumber,
    image: image,
  );

  String idType = "";
  if (userRole == UserRole.manager) {
    idType = "manager_id";
  } else if (userRole == UserRole.player) {
    idType = "player_id";
  } else if (userRole == UserRole.coach) {
    idType = "coach_id";
  } else if (userRole == UserRole.physio) {
    idType = "physio_id";
  } else {
    print("error: user type not found");
  }

  int userId = 0;
  if (userRole == UserRole.player || userRole == UserRole.physio) {
    userId = jsonDecode(response)["id"];
    print("user id: " + userId.toString());
    userIdSetter(userId);
    userRoleSetter(userRole);
  } else {
    userId = jsonDecode(response)["id"][idType];
    userIdSetter(userId);
    userRoleSetter(userRole);
  }

  if (userId != 0) {
    navigateToProfile(userRole);
  }

  firstNameReset("");
  surnameReset("");
  emailReset("");
  passwordReset("");
}
