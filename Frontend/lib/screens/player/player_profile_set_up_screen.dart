import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/api_clients/player_api_client.dart';
import 'package:play_metrix/constants.dart';
import 'package:play_metrix/data_models/player_data_model.dart';
import 'package:play_metrix/screens/home_screen.dart';
import 'package:play_metrix/screens/widgets_lib/buttons.dart';
import 'package:play_metrix/screens/widgets_lib/common_widgets.dart';

class PlayerProfileSetUpScreen extends StatefulWidget {
  final int playerId;

  const PlayerProfileSetUpScreen({super.key, required this.playerId});

  @override
  PlayerProfileSetUpScreenState createState() =>
      PlayerProfileSetUpScreenState();
}

class PlayerProfileSetUpScreenState extends State<PlayerProfileSetUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();

  Uint8List? _profilePicture;
  DateTime _selectedDob = DateTime.now();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    final heightRegex = RegExp(r'^[1-9]\d{0,2}(\.\d{1,2})?$');

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
            child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              padding: const EdgeInsets.all(35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile Set Up',
                    style: TextStyle(
                      color: AppColours.darkBlue,
                      fontFamily: AppFonts.gabarito,
                      fontSize: 36.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        datePickerNoDivider(
                            context, "Date of birth", _selectedDob, (value) {
                          setState(() {
                            _selectedDob = value;
                          });
                        }),
                        formFieldBottomBorderController(
                            "Height (cm)", _heightController, (value) {
                          return (value != null && !heightRegex.hasMatch(value))
                              ? 'Invalid height.'
                              : null;
                        }, context),
                        const SizedBox(height: 5),
                        dropdownWithDivider("Gender", _selectedGender,
                            ["Male", "Female", "Others"], (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        }),
                        const SizedBox(height: 50),
                        bigButton("Save Changes", () async {
                          if (_formKey.currentState!.validate()) {
                            PlayerData player =
                                await getPlayerData(widget.playerId);
                            await updatePlayerProfile(
                              widget.playerId,
                              player,
                              player.player_contact_number,
                              _selectedDob,
                              _heightController.text,
                              _selectedGender,
                              _profilePicture,
                            );

                            navigator.push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
