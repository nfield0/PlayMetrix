import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/authentication_data_model.dart';
import 'package:play_metrix/enums.dart';
import 'package:play_metrix/providers/team_set_up_provider.dart';
import 'package:play_metrix/providers/user_provider.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:play_metrix/screens/home_screen_initial.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoardingScreen extends ConsumerWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  OnBoardingScreen({super.key});

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('lib/assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int userId = -1;
    UserRole userRole = UserRole.player;

    const bodyStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);

    const pageDecoration = PageDecoration(
      pageMargin: EdgeInsets.only(top: 50),
      imageAlignment: Alignment.bottomCenter,
      bodyAlignment: Alignment.topCenter,
      titleTextStyle: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w700,
          color: AppColours.darkBlue,
          fontFamily: AppFonts.gabarito),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: Colors.white,
      titlePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
    );

    return FutureBuilder<bool>(
      future: AuthStorage.getLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data == true) {
            return FutureBuilder(
                future: AuthStorage.getUserId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    userId = snapshot.data ?? -1;
                    Future.microtask(() =>
                        {ref.read(userIdProvider.notifier).state = userId});

                    return FutureBuilder(
                        future: AuthStorage.getUserRole(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            userRole = snapshot.data ?? UserRole.manager;
                            Future.microtask(() => {
                                  ref.read(userRoleProvider.notifier).state =
                                      userRole
                                });

                            return FutureBuilder(
                                future: AuthStorage.getTeamId(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Scaffold(
                                      body: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    Future.microtask(() => {
                                          ref
                                              .read(teamIdProvider.notifier)
                                              .state = snapshot.data ?? -1
                                        });
                                    return HomeScreenInitial(
                                        userId: userId,
                                        userRole: userRole,
                                        teamId: snapshot.data ?? -1);
                                  }
                                });
                          }
                        });
                  }
                });
          } else {
            return IntroductionScreen(
              key: introKey,
              globalBackgroundColor: Colors.white,
              allowImplicitScrolling: true,
              autoScrollDuration: 3000,
              infiniteAutoScroll: true,
              pages: [
                PageViewModel(
                  title: "Welcome to PlayMetrix!",
                  body:
                      "Your All-in-One GAA Team Organisation and Injury Prevention App.",
                  image: _buildImage('intro/intro_1.png'),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "Before you get started...",
                  bodyWidget: Column(
                    children: [
                      const Text(
                        "Make sure to check out our socials and guidebook to know more about our app.",
                        textAlign: TextAlign.center,
                        style: bodyStyle,
                      ),
                      underlineButtonTransparent("Check us out!", () {
                        _launchUrl(Uri.parse("https://linktr.ee/playmetrix"));
                      })
                    ],
                  ),
                  image: _buildImage('intro/intro_2.png'),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "Now let’s get started!",
                  body:
                      "Start by signing up an account by entering your details and your role on the team.",
                  image: _buildImage('intro/intro_3.png'),
                  decoration: pageDecoration,
                ),
              ],
              onDone: () => _onIntroEnd(context),
              onSkip: () =>
                  _onIntroEnd(context), // You can override onSkip callback
              showSkipButton: true,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showBackButton: false,
              //rtl: true, // Display as right-to-left
              back: const Icon(Icons.arrow_back),
              skip: const Text('Skip',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              next: const Icon(Icons.arrow_forward),
              done: const Text('Done',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              curve: Curves.fastLinearToSlowEaseIn,
              controlsMargin: const EdgeInsets.all(16),
              controlsPadding: kIsWeb
                  ? const EdgeInsets.all(12.0)
                  : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              dotsDecorator: const DotsDecorator(
                size: Size(10.0, 10.0),
                color: Color(0xFFBDBDBD),
                activeSize: Size(22.0, 10.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              dotsContainerDecorator: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            );
          }
        }
      },
    );
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
