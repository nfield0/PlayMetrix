import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:play_metrix/screens/authentication/log_in_screen.dart';
import 'package:play_metrix/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/screens/authentication/sign_up_steps/name_sign_up_screen.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/landing_page_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                width: 350,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 320,
                    maxWidth:
                        MediaQuery.of(context).size.width <= 500 ? 350 : 500,
                    minHeight: 68,
                    maxHeight: 68),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NameSignUpScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: AppColours.darkBlue,
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.openSans,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "or",
                style: TextStyle(
                  color: AppColours.darkBlue,
                  fontFamily: AppFonts.openSans,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: 320,
                    maxWidth:
                        MediaQuery.of(context).size.width <= 500 ? 350 : 500,
                    minHeight: 68,
                    maxHeight: 68),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: Colors.white,
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log in with email',
                          style: TextStyle(
                            color: AppColours.darkBlue,
                            fontFamily: 'Open Sans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 18),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 320,
                      maxWidth:
                          MediaQuery.of(context).size.width <= 500 ? 350 : 500,
                      minHeight: 68,
                      maxHeight: 68),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(25),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/assets/icons/google_icon.png',
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Log in with Google',
                            style: TextStyle(
                              color: AppColours.darkBlue,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
