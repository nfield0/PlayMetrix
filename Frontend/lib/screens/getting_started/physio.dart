import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:play_metrix/screens/getting_started/lib.dart';
import 'package:play_metrix/screens/home_screen.dart';

class GettingStartedPhysio extends ConsumerWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  GettingStartedPhysio({super.key});

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
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
            title: "Getting started as a Physio",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "physio_showcase/1.png",
              context,
            ),
          ),
          PageViewModel(
            title: "View all players in your team",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "physio_showcase/2.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Edit players' availability",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "physio_showcase/3.png",
              context,
            ),
          ),
          PageViewModel(
            title: "Record player injury details",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "physio_showcase/4.png",
              context,
            ),
          ),
          PageViewModel(
            title: "View schedules for your team",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "physio_showcase/5.png",
              context,
            ),
          ),
          PageViewModel(
            title: "...and more to explore!",
            decoration: pageDecoration,
            bodyWidget: showcaseBodyWidget(
              "physio_showcase/6.png",
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
