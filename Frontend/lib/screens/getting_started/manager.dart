import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:play_metrix/screens/getting_started/lib.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/team/team_set_up_screen.dart';

class GettingStartedManager extends ConsumerWidget {
  final introKey = GlobalKey<IntroductionScreenState>();
  final bool isOnSignUp;

  GettingStartedManager({
    super.key,
    this.isOnSignUp = false,
  });

  void _onIntroEnd(context) {
    if (isOnSignUp) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => TeamSetUpScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageDecoration pageDecoration = const PageDecoration(
      contentMargin: EdgeInsets.all(20),
      bodyPadding: EdgeInsets.all(30),
      titlePadding: EdgeInsets.only(top: 70, bottom: 10, left: 30, right: 30),
    );

    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Colors.white, Color(0xFFECECEC), Color(0xC6005C97)],
          ),
        ),
      ),
      IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.transparent,
        infiniteAutoScroll: false,
        pages: [
          PageViewModel(
            title: "Getting started as a Manager",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/1.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Set up your team",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/2.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Add players to your team",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/3.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Add coaches and physios to your team",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/4.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Add schedules to your team",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/5.png",
              context,
            ),
          ),
          PageViewModel(
            title: "View players attending for each schedule",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/6.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Post announcements for each schedule",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/7.png",
              context,
            ),
          ),
          PageViewModel(
            title: "View match line up for match schedules",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/8.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Record duration played for each player in matches",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/9.png",
              context,
            ),
          ),
          PageViewModel(
            title: "...and more to explore!",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "manager_showcase/10.png",
              context,
            ),
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        // showBackButton: true,
        //rtl: true, // Display as right-to-left
        back: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        next: const Icon(Icons.arrow_forward, color: Colors.white),
        done: const Text('Done',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        skip: const Text('Skip',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(5.0, 5.0),
          color: Colors.white30,
          activeSize: Size(10.0, 5.0),
          activeColor: Colors.white,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      )
    ]);
  }
}
