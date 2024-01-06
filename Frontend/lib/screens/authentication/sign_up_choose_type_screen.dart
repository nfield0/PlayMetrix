import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole {
  manager,
  coach,
  player,
  physio,
}

final userRoleProvider = StateProvider<UserRole>((ref) => UserRole.manager);

String userRoleText(UserRole userRole) {
  switch (userRole) {
    case UserRole.manager:
      return "Manager";
    case UserRole.player:
      return "Player";
    case UserRole.coach:
      return "Coach";
    case UserRole.physio:
      return "Physio";
  }
}

class SignUpChooseTypeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();

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
          key: _formKey,
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
                      child: bigButton("Sign up", () {
                        print(ref.read(userRoleProvider.notifier).state);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
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
