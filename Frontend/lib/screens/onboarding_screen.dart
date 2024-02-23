import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/authentication_data_model.dart';
import 'package:play_metrix/screens/authentication/landing_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:play_metrix/screens/home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('lib/assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);

    const pageDecoration = PageDecoration(
      pageMargin: EdgeInsets.only(top: 120),
      imageAlignment: Alignment.bottomCenter,
      bodyAlignment: Alignment.topCenter,
      titleTextStyle: TextStyle(
          fontSize: 36.0,
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
            return const HomeScreen();
          } else {
            return IntroductionScreen(
              key: introKey,
              globalBackgroundColor: Colors.white,
              allowImplicitScrolling: true,
              autoScrollDuration: 3000,
              infiniteAutoScroll: true,
              globalHeader: Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: _buildImage('logo.png', 150),
                  ),
                ),
              ),
              globalFooter: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  child: const Text(
                    'Let\'s go right away!',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _onIntroEnd(context),
                ),
              ),
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
                  body:
                      "Make sure to check out our guidebook for more details on using our app by clicking here.",
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
