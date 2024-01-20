import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/player/player_profile_screen.dart';
import 'package:play_metrix/screens/widgets/buttons.dart';
import 'package:play_metrix/screens/widgets/common_widgets.dart';

class TeamSelectionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'lib/assets/logo.png',
          width: 150,
          fit: BoxFit.contain,
        ),
        iconTheme: const IconThemeData(
          color: AppColours.darkBlue, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(35),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Team Selection',
                        style: TextStyle(
                          color: AppColours.darkBlue,
                          fontFamily: AppFonts.gabarito,
                          fontSize: 36.0,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 10),
                    divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(children: [
                              const SizedBox(height: 50),
                              Center(
                                  child: Column(children: [
                                const Text(
                                  "What team are you on?",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                    value: "team1",
                                    items:
                                        ["team1", "team2"].map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      );
                                    }).toList(),
                                    onChanged: (p0) {}),
                              ]))
                            ]),
                            const SizedBox(height: 50),
                            bigButton("Save Changes", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            })
                          ]),
                    )
                  ]))),
    );
  }
}
